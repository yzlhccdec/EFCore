//
// Created by baidu on 13-3-14.
// Copyright 2011 Baidu Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (BDVRSearch)

- (BOOL)containsString:(NSString *)str;

// check if the string matches a specified regex pattern
- (BOOL)matchesPattern:(NSString *)regexPattern;

- (BOOL)matchesPattern:(NSString *)regexPattern shouldCachePattern:(BOOL)shouldCachePattern;

- (NSString *)stringByReplacingMatches:(NSString *)regexPattern withTemplate:(NSString *)template;

- (NSString *)stringByReplacingMatches:(NSString *)regexPattern withTemplate:(NSString *)template shouldCachePattern:(BOOL)shouldCachePattern;
@end