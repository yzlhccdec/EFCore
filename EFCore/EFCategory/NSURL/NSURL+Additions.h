//
// Created by yizhuolin on 12-9-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSURL (Additions)

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

- (NSURL *)URLByAppendingKey:(NSString *)key value:(NSString *)value;

- (NSURL *)URLByAppendingParameters:(NSDictionary *)params;
@end