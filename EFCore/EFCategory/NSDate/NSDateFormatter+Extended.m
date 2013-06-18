//
// Created by yizhuolin on 12-11-14.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDateFormatter+Extended.h"

#define INTERVAL_ONEDAY                         24*60*60
#define INTERVAL_ONEHOUR                        60*60
#define INTERVAL_ONEMINUTE                      60

@implementation NSDateFormatter (Extended)

+ (NSString *)timeBeforeNowForDate:(NSTimeInterval)date
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = now - date;

    if (timeInterval >= (INTERVAL_ONEDAY) || timeInterval < 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    }

    if (timeInterval >= (INTERVAL_ONEHOUR)) {
        return [NSString stringWithFormat:@"%d小时前", (NSInteger) (timeInterval / (INTERVAL_ONEHOUR))];
    }

    if (timeInterval >= (INTERVAL_ONEMINUTE)) {
        return [NSString stringWithFormat:@"%d分钟前", (NSInteger) (timeInterval / (INTERVAL_ONEMINUTE))];
    }

    return [NSString stringWithFormat:@"%d秒前", (NSInteger) MAX(timeInterval, 1)];
}

@end