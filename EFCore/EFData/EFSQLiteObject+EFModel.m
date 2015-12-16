//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//

#import <objc/runtime.h>
#import "EFSQLiteObject+EFModel.h"
#import "EFKeyValuePair.h"
#import "NSError+EFException.h"
#import "EFRuntime.h"

@implementation EFSQLiteObject (EFModel)
- (instancetype)initWithSafeDictionary:(NSDictionary *)dictionary error:(NSError **)error {
    return [self initWithDictionary:dictionary ignoreFieldNotExist:YES ignoreInvalidValue:YES error:error];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary ignoreFieldNotExist:(BOOL)ignoreFieldNotExist ignoreInvalidValue:(BOOL)ignoreInvalidValue error:(NSError **)error {
    if (!(self = [super init])) return nil;

    for (EFKeyValuePair *field in [[self class] fieldsForPersistence]) {
        if (![[dictionary allKeys] containsObject:field.key]) {
            if (!ignoreFieldNotExist) {
                NSException *ex = [[NSException alloc] initWithName:@"Miss Field" reason:[NSString stringWithFormat:@"%@ ,miss field \"%@\" when init with Dictionary", NSStringFromClass([self class]), field.key] userInfo:nil];
#if DEBUG
                // Fail fast in Debug builds.
            DLog(@"%@ *** Miss Filed \"%@\" when init with Dictionary", NSStringFromClass([self class]), field.key);
            [ex raise];
#else
                *error = [NSError ef_objectErrorWithException:ex];
                return nil;
#endif
            }
        } else {
            BOOL success = [self __validateAndSetValue:dictionary[field.key] forKey:field.key ignoreInvalidValue:ignoreInvalidValue error:error];
            if (!success) return nil;
        }
    }

    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableSet *keys = [[NSMutableSet alloc] init];
    for (EFKeyValuePair *field in [[self class] fieldsForPersistence]) {
        [keys addObject:field.key];
    }

    return [self dictionaryWithValuesForKeys:keys.allObjects];
}

- (BOOL)__validateAndSetValue:(id)value forKey:(NSString *)key ignoreInvalidValue:(BOOL)ignoreInvalidValue error:(NSError **)pError {
    __autoreleasing id validatedValue = value;

    if (![self validateValue:&validatedValue forKey:key error:pError]) {
        NSException *ex = [[NSException alloc] initWithName:@"Invalid value" reason:[NSString stringWithFormat:@"%@ ,invalid value for setting key \"%@\" : %@", NSStringFromClass([self class]), key, value] userInfo:nil];
#if DEBUG
        // Fail fast in Debug builds.
        DLog(@"%@ *** Caught invalid value for setting key \"%@\" : %@", NSStringFromClass([self class]), key, value);
        [ex raise];
#else
        *pError = [NSError ef_objectErrorWithException:ex];
        return ignoreInvalidValue;
#endif
    }

    [self setValue:validatedValue forKey:key];
}
@end