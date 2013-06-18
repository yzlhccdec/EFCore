//
// Created by yizhuolin on 12-10-14.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface EFSecurity : NSObject

@property (nonatomic, readonly) SecKeyRef privateKey;
@property (nonatomic, readonly) SecKeyRef publicKey;

- (OSStatus)extractKeysFromPKCS12Data:(NSData *)pkcsData passphrase:(NSString *)pkcsPassword;

- (OSStatus)extractKeysFromPKCS12File:(NSString *)pkcsPath passphrase:(NSString *)pkcsPassword;

- (OSStatus)extractPublicKeyFromCertificateData:(NSData *)certData;

- (OSStatus)extractPublicKeyFromCertificateFile:(NSString *)certPath;

- (NSData *)encryptWithPublicKey:(NSData *)plainData;

- (NSData *)decryptWithPrivateKey:(NSData *)cipherData;

@end