//
// Created by yizhuolin on 13-6-18.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "NSFileManager+SystemDirectory.h"


@implementation NSFileManager (SystemDirectory)

+ (NSString *)documentDirectory
{
    static NSString *documentDirectory;
    if (documentDirectory == nil) {
        documentDirectory = [self pathForDirectory:NSDocumentDirectory];
    }
    return documentDirectory;
}

+ (NSString *)libraryDirectory
{
    static NSString *libraryDirectory;
    if (libraryDirectory == nil) {
        libraryDirectory = [self pathForDirectory:NSLibraryDirectory];
    }
    return libraryDirectory;
}

+ (NSString *)cachesDirectory
{
    static NSString *cachesDirectory;
    if (cachesDirectory == nil) {
        cachesDirectory = [self pathForDirectory:NSCachesDirectory];
    }
    return cachesDirectory;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)searchPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end