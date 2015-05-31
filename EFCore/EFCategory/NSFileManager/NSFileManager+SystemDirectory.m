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

+ (NSString *)sharedDocumentDirectoryForGroupIdentifier:(NSString *)identifier
{
    static NSString *documentDirectory;
    if (documentDirectory == nil) {
        documentDirectory = [self sharedPathForDirectory:@"Documents" groupIdentifier:identifier];
    }

    return documentDirectory;
}

+ (NSString *)sharedLibraryDirectoryForGroupIdentifier:(NSString *)identifier
{
    static NSString *documentDirectory;
    if (documentDirectory == nil) {
        documentDirectory = [self sharedPathForDirectory:@"Library" groupIdentifier:identifier];
    }

    return documentDirectory;
}

+ (NSString *)sharedCachesDirectoryForGroupIdentifier:(NSString *)identifier
{
    static NSString *documentDirectory;
    if (documentDirectory == nil) {
        documentDirectory = [self sharedPathForDirectory:@"Library/Caches" groupIdentifier:identifier];
    }

    return documentDirectory;
}

+ (NSString *)sharedPathForDirectory:(NSString *)directory groupIdentifier:(NSString *)identifier
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSURL    *appGroupContainer     = [fileManager containerURLForSecurityApplicationGroupIdentifier:identifier];
    NSString *appGroupContainerPath = [appGroupContainer path];
    NSString *directoryPath         = [appGroupContainerPath stringByAppendingPathComponent:directory];

    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return directoryPath;
}

@end