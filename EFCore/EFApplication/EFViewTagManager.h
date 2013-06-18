//
// Created by yizhuolin on 12-9-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define REGISTERTAG(viewTag) [TAGS setObject:@(viewTag) forKey:@(#viewTag)]

@interface EFViewTagManager : NSObject

- (void)initTags;

+ (NSInteger)viewTagFromString:(NSString *)tagString;

+ (NSString *)stringFromViewTag:(NSInteger)viewTag;

@end