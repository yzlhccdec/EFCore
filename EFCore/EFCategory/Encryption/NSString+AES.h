//
// Created by yizhuolin on 12-8-31.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSString (AES)

- (NSData *)AES128EncryptDataWithKeyString:(NSString *)key;

- (NSData *)AES128EncryptDataWithKeyData:(NSData *)key;


@end