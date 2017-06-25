//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog(args...) DebugLog(NO,__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#define DDLog(args...) DebugLog(YES,__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define DLog(args...);
#define DDLog(args...);
#endif

// ALog and ADLog always displays output regardless of the DEBUG setting
#define ALog(args...) DebugLog(NO,__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#define ADLog(args...) DebugLog(YES,__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

#ifndef ULog
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [L:%d T:%@]", __PRETTY_FUNCTION__, __LINE__, [NSThread currentThread]] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif
#endif

#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

typedef UIImage* (^ImageDrawingBlock)();

UIImage* cachedImage(NSString *imageName, ImageDrawingBlock block);
void DebugLog(BOOL detailedOutput, const char *file, int lineNumber, const char *funcName, NSString *format,...);
