//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFObject.h"

@interface EFObject (Private)

+ (BOOL)isStorageProperty:(NSString *)propertyKey;
- (BOOL)valitedateAndSetValue:(id)value forKey:(NSString *)key ignoreFieldNotExist:(BOOL)ignoreFieldNotExist ignoreInvalidValue:(BOOL)ignoreInvalidValue error:(NSError **)pError;

@end