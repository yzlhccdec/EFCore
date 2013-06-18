//
// Created by yizhuolin on 12-9-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFViewTagManager.h"


static NSMutableDictionary *TAGS;

@implementation EFViewTagManager

+ (void)initialize
{
    TAGS = [[NSMutableDictionary alloc] init];
}

- (id)init
{
    self = [super init];

    if (self) {
        [self initTags];
    }

    return self;
}

- (void)initTags
{
    //REGISTERTAG(ViewTagFootBarXXButton);
}

+ (NSInteger)viewTagFromString:(NSString *)tagString
{
    return ((NSNumber *)[TAGS objectForKey:tagString]).integerValue;
}

+ (NSString *)stringFromViewTag:(NSInteger)viewTag
{
    for(NSString *tag in TAGS.allKeys) {
        if(((NSNumber *)[TAGS objectForKey:tag]).integerValue == viewTag) {
            return tag;
        }
    }

    return nil;
}


@end