//
// Created by yizhuolin on 12-9-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSURL+Additions.h"


@implementation NSURL (Additions)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString
{
    if (![queryString length]) {
        return self;
    }

    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                                                           [self query] ? @"&" : @"?", queryString];

    return [NSURL URLWithString:URLString];
}

@end