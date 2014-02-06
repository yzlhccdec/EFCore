//
// Created by yizhuolin on 14-1-27.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSFileManager (EFFileAttributes)

/**
 @name Reading/Writing Extended Attributes
 */

/**
 Removes an extended file attribute from the receiver.

 @param attribute The name of the attribute.
 @param path Path of file.
 @returns `YES` if successful.
 */
- (BOOL)removeAttribute:(NSString *)attribute ofItemAtPath:(NSString *)path;


/**
 Sets the value of an extended file attribute for the receiver.

 If the value is `nil` then this is the same as calling <removeAttribute:>.

 @param value The string to save for this attribute.
 @param attribute The name of the attribute.
 @param path Path of file.
 @returns `YES` if successful.
 */
- (BOOL)setValue:(NSString *)value forAttribute:(NSString *)attribute ofItemAtPath:(NSString *)path;


/**
 Gets the value of an extended file attribute from the receiver.

 @param attribute The name of the attribute.
 @param path Path of file.
 @returns The string for the value or `nil` if the value is not set.
 */
- (NSString *)valueForAttribute:(NSString *)attribute ofItemAtPath:(NSString *)path;
@end