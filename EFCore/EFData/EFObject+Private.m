//
// Created by chachi on 15/12/16.
// Copyright (c) 2015 yizhuolin. All rights reserved.
//

#import <objc/runtime.h>
#import "EFObject+Private.h"
#import "EXTRuntimeExtensions.h"
#import "EXTScope.h"
#import "EFRuntime.h"

@implementation EFObject (Private)

+ (BOOL)isStorageProperty:(NSString *)propertyKey {
    objc_property_t property = class_getProperty(self.class, propertyKey.UTF8String);

    if (property == NULL) {
        return NO;
    }

    ext_propertyAttributes *attributes = ext_copyPropertyAttributes(property);
    @onExit{
        free(attributes);
    };

    BOOL hasGetter = [self instancesRespondToSelector:attributes->getter];
    BOOL hasSetter = [self instancesRespondToSelector:attributes->setter];
    if (!attributes->dynamic && attributes->ivar == NULL && !hasGetter && !hasSetter) {
        return NO;
    } else if (attributes->readonly && attributes->ivar == NULL) {
        if ([self isEqual:EFObject.class]) {
            return NO;
        } else {
            return [self.superclass isStorageProperty:propertyKey];
        }
    } else {
        return YES;
    }
}

- (BOOL)__valitedateAndSetValue:(id)value forKey:(NSString *)key ignoreFieldNotExist:(BOOL)ignoreFieldNotExist ignoreInvalidValue:(BOOL)ignoreInvalidValue error:(NSError **)pError {
    __autoreleasing id validatedValue = value;

    if (![[self class] isStorageProperty:key]) {
        return ignoreFieldNotExist;
    }

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