//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//
#import "EFObject.h"
#import "EFObject+Private.h"

@implementation EFObject

- (instancetype)initWithSafeDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    return [self initWithDictionary:dictionary ignoreFieldNotExist:YES ignoreInvalidValue:YES error:error];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ignoreFieldNotExist:(BOOL)ignoreFieldNotExist ignoreInvalidValue:(BOOL)ignoreInvalidValue error:(NSError **)error {
    if (!(self = [super init])) return nil;

    for (NSString *key in dictionary) {
        __autoreleasing id value = [dictionary objectForKey:key];

        if ([value isEqual:NSNull.null]) value = nil;

        BOOL success = [self valitedateAndSetValue:value forKey:key ignoreFieldNotExist:ignoreFieldNotExist ignoreInvalidValue:ignoreInvalidValue error:error];
        if (!success) return nil;
    }

    return self;
}

@end