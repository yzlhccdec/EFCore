//
// Created by yizhuolin on 13-6-18.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSFileManager (SystemDirectory)
+ (NSString *)documentDirectory;

+ (NSString *)libraryDirectory;

+ (NSString *)cachesDirectory;

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)searchPath;
@end