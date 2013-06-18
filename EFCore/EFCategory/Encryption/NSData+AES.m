//
// Created by yizhuolin on 12-9-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES)

- (NSString *)AES128DecryptStringWithKeyString:(NSString *)key
{
    return [[NSString alloc] initWithData:[self AES128DecryptWithKeyString:key] encoding:NSUTF8StringEncoding];
}

- (NSString *)AES128DecryptStringWithKeyData:(NSData *)key
{
    return [[NSString alloc] initWithData:[self AES128DecryptWithKeyData:key] encoding:NSUTF8StringEncoding];
}

- (NSData *)AES128EncryptWithKeyString:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    return [self transformData:kCCEncrypt key:keyPtr];
}

- (NSData *)AES128EncryptWithKeyData:(NSData *)key   //加密
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));

    memcpy(keyPtr, [key bytes], sizeof(keyPtr));

    return [self transformData:kCCEncrypt key:keyPtr];
}

- (NSData *)AES128DecryptWithKeyData:(NSData *)key   //解密
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));

    memcpy(keyPtr, [key bytes], sizeof(keyPtr));

    return [self transformData:kCCDecrypt key:keyPtr];
}


- (NSData *)AES128DecryptWithKeyString:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    return [self transformData:kCCDecrypt key:keyPtr];
}

- (NSData *)transformData:(CCOperation)operation key:(char [])key
{
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
            kCCOptionPKCS7Padding | kCCOptionECBMode,
            key, kCCBlockSizeAES128,
            NULL,
            [self bytes], dataLength,
            buffer, bufferSize,
            &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


@end