//
// Created by yizhuolin on 14-1-27.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "NSFileManager+EFFileAttributes.h"
#import <sys/xattr.h>

@implementation NSFileManager (EFFileAttributes)

- (BOOL)removeAttribute:(NSString *)attribute ofItemAtPath:(NSString *)path
{
    const char *attrName = [attribute UTF8String];
    const char *filePath = [path fileSystemRepresentation];

    int result = removexattr(filePath, attrName, 0);

    return result == 0;
}

- (BOOL)setValue:(NSString *)value forAttribute:(NSString *)attribute ofItemAtPath:(NSString *)path
{
    if ([attribute length] == 0) {
        return NO;
    }

    if ([value length] == 0) {
        // remove it instead
        return [self removeAttribute:attribute ofItemAtPath:path];
    }

    const char *attrName = [attribute UTF8String];
    const char *filePath = [path fileSystemRepresentation];

    const char *val = [value UTF8String];

    int result = setxattr(filePath, attrName, val, strlen(val), 0, 0);

    return result == 0;
}

- (NSString *)valueForAttribute:(NSString *)attribute ofItemAtPath:(NSString *)path
{
    if ([attribute length] == 0) {
        return nil;
    }

    const char *attrName = [attribute UTF8String];
    const char *filePath = [path fileSystemRepresentation];

    // get size of needed buffer
    ssize_t bufferLength = getxattr(filePath, attrName, NULL, 0, 0, 0);

    if (bufferLength <= 0) {
        return nil;
    }

    // make a buffer of sufficient length
    char *buffer = malloc(bufferLength);

    // now actually get the attribute string
    getxattr(filePath, attrName, buffer, bufferLength, 0, 0);

    // convert to NSString
    NSString *retString = [[NSString alloc] initWithBytes:buffer length:bufferLength encoding:NSUTF8StringEncoding];

    // release buffer
    free(buffer);

    return retString;
}

@end