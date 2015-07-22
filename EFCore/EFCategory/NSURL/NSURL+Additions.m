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

- (NSURL *)URLByAppendingKey:(NSString *)key value:(NSString *)value
{
    if (key.length == 0 || value.length == 0) {
        return self;
    }

    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@=%@", [self absoluteString],
                                                           [self query] ? @"&" : @"?", key, value];

    return [NSURL URLWithString:URLString];
}

- (NSURL *)URLByAppendingParameters:(NSDictionary *)params
{
    if (params.count == 0) {
        return self;
    }

    NSMutableString *queryString = [[NSMutableString alloc] initWithFormat:@"%@%@", [self absoluteString], [self query] ? @"&" : @"?"];

    for (NSString *key in params.allKeys) {
        id value = params[key];
        if (![value isKindOfClass:[NSString class]]) {
            [queryString appendFormat:@"%@=%@&", key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }

    [queryString deleteCharactersInRange:NSMakeRange(queryString.length - 1, 1)];

    return [NSURL URLWithString:queryString];
}

@end