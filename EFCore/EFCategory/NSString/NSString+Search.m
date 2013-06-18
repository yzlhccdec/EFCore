//
// Created by baidu on 13-3-14.
// Copyright 2011 Baidu Inc. All rights reserved.
//
#import "NSString+Search.h"


@implementation NSString (BDVRSearch)

- (BOOL)containsString:(NSString *)str
{
    return [self rangeOfString:str].location != NSNotFound;
}

- (BOOL)matchesPattern:(NSString *)regexPattern
{
    return [self matchesPattern:regexPattern shouldCachePattern:YES];
}

- (BOOL)matchesPattern:(NSString *)regexPattern shouldCachePattern:(BOOL)shouldCachePattern
{
    NSRegularExpression *expression = [self expressionForPattern:regexPattern shouldCachePattern:shouldCachePattern];
    return [expression firstMatchInString:self options:0 range:NSMakeRange(0, [self length])] != nil;
}

- (NSString *)stringByReplacingMatches:(NSString *)regexPattern withTemplate:(NSString *)template
{
    return [self stringByReplacingMatches:regexPattern withTemplate:template shouldCachePattern:YES];
}

- (NSString *)stringByReplacingMatches:(NSString *)regexPattern withTemplate:(NSString *)template shouldCachePattern:(BOOL)shouldCachePattern
{
    NSRegularExpression *expression = [self expressionForPattern:regexPattern shouldCachePattern:shouldCachePattern];
    NSMutableString *result = [self mutableCopy];
    [expression replaceMatchesInString:result options:0 range:NSMakeRange(0, [result length]) withTemplate:template];
    return result;
}

- (NSRegularExpression *)expressionForPattern:(NSString *)regexPattern shouldCachePattern:(BOOL)shouldCachePattern
{
    static dispatch_once_t once;
    static NSMutableDictionary *regularExpressions;

    dispatch_once(&once, ^{regularExpressions = [[NSMutableDictionary alloc] init];});

    NSRegularExpression *expression = regularExpressions[regexPattern];

    if (expression == nil)
    {
        expression = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:NULL];

        if (shouldCachePattern) {
            regularExpressions[regexPattern] = expression;
        }
    }

    return expression;
}
@end