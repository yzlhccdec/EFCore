//
// Created by yizhuolin on 12-8-31.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSString+AES.h"
#import "NSData+AES.h"


@implementation NSString (AES)

- (NSData *)AES128EncryptDataWithKeyString:(NSString *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKeyString:key];
}

- (NSData *)AES128EncryptDataWithKeyData:(NSData *)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKeyData:key];
}

@end