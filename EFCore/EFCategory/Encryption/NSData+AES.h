//
// Created by yizhuolin on 12-9-26.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSData (AES)

- (NSString *)AES128DecryptStringWithKeyString:(NSString *)key;

- (NSString *)AES128DecryptStringWithKeyData:(NSData *)key;

- (NSData *)AES128EncryptWithKeyString:(NSString *)key;


- (NSData *)AES128EncryptWithKeyData:(NSData *)key;

- (NSData *)AES128DecryptWithKeyData:(NSData *)key;

- (NSData *)AES128DecryptWithKeyString:(NSString *)key;


@end