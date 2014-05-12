//
// Created by yizhuolin on 14-5-12.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <objc/runtime.h>
#import <objc/message.h>
#import <EFCore/EFRuntime.h>
#import "UIResponder+EFCustomizeAction.h"

static char ActionDelegate;
static char ShouldDisableActions;
const char * prefix = "EFCustomizeAction_";

@implementation UIResponder (EFCustomizeAction)


- (void)setShouldDisableActions:(BOOL)shouldDisableActions
{
    [self __changeMetaClass];

    objc_setAssociatedObject(self, &ShouldDisableActions, @(shouldDisableActions), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)shouldDisableActions
{
    return [objc_getAssociatedObject(self, &ShouldDisableActions) boolValue];
}

- (void)setActionDelegate:(id)actionDelegate
{
    [self __changeMetaClass];

    objc_setAssociatedObject(self, &ActionDelegate, actionDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id)actionDelegate
{
    return objc_getAssociatedObject(self, &ActionDelegate);
}

- (void)__changeMetaClass
{
    Class superClass = [self class];
    NSString * className = NSStringFromClass(superClass);
    if (strncmp(prefix, [className UTF8String], strlen(prefix)) != 0) {
        NSString * subclassName = [NSString stringWithFormat:@"%s%@", prefix, className];
        Class subclass = NSClassFromString(subclassName);

        if (subclass == nil) {
            subclass = objc_allocateClassPair(superClass, [subclassName UTF8String], 0);
            if (subclass != nil) {
                IMP canPerformAction = class_getMethodImplementation([self class], @selector(__canPerformAction:withSender:));
                IMP class = class_getMethodImplementation([self class], @selector(__class));

                class_addMethod(subclass, @selector(canPerformAction:withSender:), canPerformAction, method_getTypeEncoding(class_getInstanceMethod(superClass, @selector(canPerformAction:withSender:))));
                class_addMethod(subclass, @selector(class), class, method_getTypeEncoding(class_getInstanceMethod(superClass, @selector(class))));
                objc_registerClassPair(subclass);

                object_setClass(self, subclass);
            } else {
                DLog(@"can't subclass %@", subclass);
            }
        } else {
            object_setClass(self, subclass);
        }
    }
}

- (BOOL)__canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.shouldDisableActions) {
        return NO;
    }

    if ([self.actionDelegate respondsToSelector:@selector(canPerformAction:withSender:)]) {
        return [self.actionDelegate canPerformAction:action withSender:sender];
    }

    struct objc_super obS;
    obS.receiver = self;
    obS.super_class = [self superclass];
    return [objc_msgSendSuper(&obS, @selector(canPerformAction:withSender:), action, sender) boolValue];
}

- (Class)__class
{
    return class_getSuperclass(object_getClass(self));
}

@end