//
// Created by yizhuolin on 14-10-12.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (Path)
- (NSString *)fullPathExtension;

- (NSString *)stringByDeletingFullPathExtension;

- (NSString *)stringByAppendingSuffixToFilename:(NSString *)suffix;
@end