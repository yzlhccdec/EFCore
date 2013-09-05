//
// Created by yizhuolin on 13-9-5.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
- (NSString *)encodeToPercentEscapeStringUsingEncoding:(CFStringBuiltInEncodings)encoding;

- (NSString *)decodeFromPercentEscapeStringUsingEncoding:(CFStringBuiltInEncodings)encoding;
@end