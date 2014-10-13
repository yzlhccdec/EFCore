//
// Created by yizhuolin on 14-10-12.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSBundle (EFExtension)
- (NSString *)pathForResource:(NSString *)name;

- (NSString *)pathForResource:(NSString *)name withScaleFactor:(float)factor;
@end