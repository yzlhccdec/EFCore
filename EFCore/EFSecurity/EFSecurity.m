//
// Created by yizhuolin on 12-10-14.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFSecurity.h"


@implementation EFSecurity

- (OSStatus)extractKeysFromPKCS12Data:(NSData *)pkcsData passphrase:(NSString *)pkcsPassword
{
    SecIdentityRef identity;
    SecTrustRef trust;
    OSStatus status = -1;

    if (pkcsData) {
        CFStringRef password = (__bridge CFStringRef) pkcsPassword;
        const void *keys[] = {kSecImportExportPassphrase};
        const void *values[] = {password};
        CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
        CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, NULL, 0, NULL);
        status = SecPKCS12Import((__bridge CFDataRef) pkcsData, options, &items);

        if (status == errSecSuccess) {
            CFDictionaryRef identity_trust_dic = CFArrayGetValueAtIndex(items, 0);
            identity = (SecIdentityRef) CFDictionaryGetValue(identity_trust_dic, kSecImportItemIdentity);
            trust = (SecTrustRef) CFDictionaryGetValue(identity_trust_dic, kSecImportItemTrust);

            // certs数组中包含了所有的证书
            CFArrayRef certs = (CFArrayRef) CFDictionaryGetValue(identity_trust_dic, kSecImportItemCertChain);

            if ([(__bridge NSArray *) certs count] && trust && identity) {
                // 如果没有下面一句，自签名证书的评估信任结果永远是kSecTrustResultRecoverableTrustFailure
                status = SecTrustSetAnchorCertificates(trust, certs);

                if (status == errSecSuccess) {
                    SecTrustResultType trustResultType;
                    // 通常, 返回的trust result type应为kSecTrustResultUnspecified，如果是，就可以说明签名证书是可信的
                    status = SecTrustEvaluate(trust, &trustResultType);

                    if ((trustResultType == kSecTrustResultUnspecified || trustResultType == kSecTrustResultProceed) && status == errSecSuccess) {
                        status = SecIdentityCopyPrivateKey(identity, &_privateKey);

                        _publicKey = SecTrustCopyPublicKey(trust);
                    }
                }
            }
        }

        CFRelease(options);
    }

    return status;
}

- (OSStatus)extractKeysFromPKCS12File:(NSString *)pkcsPath passphrase:(NSString *)pkcsPassword
{
    NSData *p12Data = [NSData dataWithContentsOfFile:pkcsPath];

    return [self extractKeysFromPKCS12Data:p12Data passphrase:pkcsPassword];
}

- (OSStatus)extractPublicKeyFromCertificateData:(NSData *)certData
{
    OSStatus status = -1;
    SecTrustRef trust;
    SecTrustResultType trustResult;

    if (certData) {
        SecCertificateRef cert = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certData);
        SecPolicyRef policy = SecPolicyCreateBasicX509();
        status = SecTrustCreateWithCertificates(cert, policy, &trust);

        if (status == errSecSuccess && trust) {
            NSArray *certs = [NSArray arrayWithObject:(__bridge id)cert];
            status = SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)certs);

            if (status == errSecSuccess) {
                status = SecTrustEvaluate(trust, &trustResult);

                // 自签名证书可信
                if (status == errSecSuccess && (trustResult == kSecTrustResultUnspecified || trustResult == kSecTrustResultProceed)) {
                    _publicKey = SecTrustCopyPublicKey(trust);

                    CFRelease(cert);
                    CFRelease(policy);
                    CFRelease(trust);
                }
            }
        }
    }

    return status;
}

- (OSStatus)extractPublicKeyFromCertificateFile:(NSString *)certPath
{
    NSData *derData = [NSData dataWithContentsOfFile:certPath];

    return [self extractPublicKeyFromCertificateData:derData];
}

- (NSData *)encryptWithPublicKey:(NSData *)plainData {

    size_t cipherBufferSize = SecKeyGetBlockSize(_publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    double totalLength = [plainData length];
    size_t blockSize = cipherBufferSize - 12;
    size_t blockCount = (size_t)ceil(totalLength / blockSize);

    NSMutableData *encryptedData = [NSMutableData data];

    for (NSInteger i = 0; i < blockCount; i++) {

        NSUInteger loc = i * blockSize;
        NSUInteger dataSegmentRealSize = MIN(blockSize, [plainData length] - loc);

        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];

        OSStatus status = SecKeyEncrypt(_publicKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, cipherBuffer, &cipherBufferSize);

        if (status == errSecSuccess) {
            NSData *encryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedDataSegment];
        } else {
            free(cipherBuffer);

            return nil;
        }
    }

    free(cipherBuffer);

    return encryptedData;
}

- (NSData *)decryptWithPrivateKey:(NSData *)cipherData {
    size_t plainBufferSize = SecKeyGetBlockSize(_privateKey);
    uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
    NSUInteger totalLength = [cipherData length];
    size_t blockSize = plainBufferSize;
    size_t blockCount = (size_t)ceil((double)totalLength / blockSize);

    NSMutableData *decryptedData = [NSMutableData data];
    for (NSUInteger i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        NSUInteger dataSegmentRealSize = MIN(blockSize, totalLength - loc);

        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        OSStatus status = SecKeyDecrypt(_privateKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, plainBuffer, &plainBufferSize);

        if (status == errSecSuccess) {
            NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:plainBufferSize];
            [decryptedData appendData:decryptedDataSegment];
        } else {
            free(plainBuffer);
            return nil;
        }
    }

    free(plainBuffer);

    return decryptedData;
}

@end