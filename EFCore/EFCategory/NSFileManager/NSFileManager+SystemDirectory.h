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

+ (NSString *)sharedDocumentDirectoryForGroupIdentifier:(NSString *)identifier;

+ (NSString *)sharedLibraryDirectoryForGroupIdentifier:(NSString *)identifier;

+ (NSString *)sharedCachesDirectoryForGroupIdentifier:(NSString *)identifier;

+ (NSString *)sharedPathForDirectory:(NSString *)directory groupIdentifier:(NSString *)identifier;
@end