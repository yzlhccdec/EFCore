//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <objc/runtime.h>
#import "EFRuntime.h"
#import "EFImageCache.h"
#import "pthread.h"

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

void DebugLog(BOOL detailedOutput, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    va_list ap;

    va_start (ap, format);
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body =  [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);
    NSString *fileName = [@(file) lastPathComponent];

    mach_port_t machTID = pthread_mach_thread_np(pthread_self());
    char threadIdString[9];
    snprintf(threadIdString, 9, "%x", machTID);

    char *isMainThread = [[NSThread currentThread] isMainThread] ? "(main)" : "";
    if (detailedOutput) {
        fprintf(stderr,"%s/%s (%s:%d) %s",threadIdString, funcName, [fileName UTF8String], lineNumber, [body UTF8String]);
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

        fprintf(stderr,"%s [%s:%d] [thread:%s%s] %s",[dateString UTF8String], [fileName UTF8String],lineNumber, threadIdString, isMainThread, [body UTF8String]);
    }
}
