//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFSQLiteObject.h"

@interface EFSQLiteObject (EFModel)

- (instancetype)initWithSafeDictionary:(NSDictionary *)dictionary error:(NSError **)error;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ignoreFieldNotExist:(BOOL)ignoreFieldNotExist ignoreInvalidValue:(BOOL)ignoreInvalidValue error:(NSError **)error;

- (NSDictionary *)dictionaryValue;
@end