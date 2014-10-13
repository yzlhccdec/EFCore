//
// Created by yizhuolin on 14-10-12.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "NSString+Path.h"


@implementation NSString (Path)

- (NSString *)fullPathExtension
{
    NSString *filename = [self lastPathComponent];
    NSRange range = NSMakeRange(1, filename.length - 1);
    uint dotLocation = [filename rangeOfString:@"." options:NSLiteralSearch range:range].location;
    return dotLocation == NSNotFound ? @"" : [filename substringFromIndex:dotLocation + 1];
}

- (NSString *)stringByDeletingFullPathExtension
{
    NSString *base = self;
    while (![base isEqualToString:(base = [base stringByDeletingPathExtension])]) {}
    return base;
}

- (NSString *)stringByAppendingSuffixToFilename:(NSString *)suffix
{
    return [[self stringByDeletingFullPathExtension] stringByAppendingFormat:@"%@.%@",
                                                                             suffix, [self fullPathExtension]];
}

@end