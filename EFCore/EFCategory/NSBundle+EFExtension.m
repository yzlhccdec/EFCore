//
// Created by yizhuolin on 14-10-12.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "NSBundle+EFExtension.h"
#import "NSString+Path.h"


@implementation NSBundle (EFExtension)

- (NSString *)pathForResource:(NSString *)name
{
    if ([name length] == 0) {
        return nil;
    }

    NSString *directory = [name stringByDeletingLastPathComponent];
    NSString *file      = [name lastPathComponent];
    return [self pathForResource:file ofType:nil inDirectory:directory];
}

- (NSString *)pathForResource:(NSString *)name withScaleFactor:(float)factor
{
    if (factor == 0) {
        factor = [UIScreen mainScreen].scale;
    }

    if (factor != 1.0f) {
        NSString *suffix = [NSString stringWithFormat:@"@%@x", @(factor)];
        NSString *path   = [self pathForResource:[name stringByAppendingSuffixToFilename:suffix]];
        if (path) {
            return path;
        }
    }

    return [self pathForResource:name];
}

@end