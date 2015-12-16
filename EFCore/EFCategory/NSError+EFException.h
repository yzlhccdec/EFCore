//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (EFException)

+ (instancetype)ef_objectErrorWithException:(NSException *)exception;

@end