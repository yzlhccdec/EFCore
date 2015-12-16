//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//

#import "NSError+EFException.h"

static NSString *const EFObjectErrorDomain = @"EFObjectErrorDomain";

static const NSInteger EFObjectErrorExceptionThrown = 1;

static NSString *const EFObjectThrownExceptionErrorKey = @"EFObjectThrownException";

@implementation NSError (EFException)

+ (instancetype)ef_objectErrorWithException:(NSException *)exception {
    NSParameterAssert(exception != nil);

    NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey : exception.description,
            NSLocalizedFailureReasonErrorKey : exception.reason,
            EFObjectThrownExceptionErrorKey : exception
    };

    return [NSError errorWithDomain:EFObjectErrorDomain code:EFObjectErrorExceptionThrown userInfo:userInfo];
}

@end