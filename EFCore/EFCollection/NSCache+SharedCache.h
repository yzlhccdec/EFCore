//
// Created by yizhuolin on 12-9-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSCache (SharedCache)

+ (NSCache *)sharedCacheForName:(NSString *)cacheName;

+ (NSDictionary *)allSharedCaches;

+ (void)clearCustomCache;

@end