//
// Created by yizhuolin on 13-9-5.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "NSString+URLEncode.h"


@implementation NSString (URLEncode)

// Encode a string to embed in an URL.
- (NSString *)encodeToPercentEscapeStringUsingEncoding:(CFStringBuiltInEncodings)encoding {
    return (__bridge_transfer NSString *)
            CFURLCreateStringByAddingPercentEscapes(NULL,
                    (__bridge CFStringRef) self,
                    NULL,
                    (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                    encoding);
}

// Decode a percent escape encoded string.
- (NSString *)decodeFromPercentEscapeStringUsingEncoding:(CFStringBuiltInEncodings)encoding {
    return (__bridge_transfer NSString *)
            CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                    (__bridge CFStringRef) self,
                    CFSTR(""),
                    encoding);
}

@end