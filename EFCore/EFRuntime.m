//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <objc/runtime.h>
#import "EFRuntime.h"
#import "EFImageCache.h"

typedef enum MethodImplementationType {
    MethodNotFound = 0, // method not found
    MethodImplement,    // first in tree to implement method
    MethodOverride,     // class overrides method
    MethodSuper         // class does not override superclass method
} MethodImplementationType;

MethodImplementationType getMethodImplementationType(Class class, SEL selector, BOOL isClassMethod) {

    Method method = isClassMethod ? class_getClassMethod(class, selector)
                    : class_getInstanceMethod(class, selector);
    if(method) {
        Class superclass = class_getSuperclass(class);
        if(superclass) {
            Method superclassMethod = isClassMethod ? class_getClassMethod(superclass, selector)
                                      : class_getInstanceMethod(superclass, selector);
            if(superclassMethod) {
                return method == superclassMethod ? MethodSuper : MethodOverride;
            } else {
                return MethodImplement;
            }
        }
    }
    return MethodNotFound;
}

UIImage *cachedImage(NSString *imageName, ImageDrawingBlock block)
{
    NSString *key = [NSString stringWithFormat:@"%@", imageName];

    UIImage *image = [[EFImageCache sharedCache] objectForKey:key];

    if (image == nil)
    {
        UIImage *defaultImage = block();

        if (defaultImage != nil)
        {
            image = defaultImage;
            [[EFImageCache sharedCache] setObject:image forKey:key];
        }
    }

    return image;
}