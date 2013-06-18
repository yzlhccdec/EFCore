//
// Created by yizhuolin on 12-9-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSCache+SharedCache.h"

//#define TOTAL_COST_LIMIT 1024*1024*2


@implementation NSCache (SharedCache)

static NSMutableDictionary *sShareCaches = nil;

+ (NSCache *)sharedCacheForName:(NSString *)cacheName
{

    @synchronized (sShareCaches) {
        if (sShareCaches == nil) {
            sShareCaches = [[NSMutableDictionary alloc] init];
        }

        NSCache *cache = sShareCaches[cacheName];

        if (cache == nil) {
            cache = [[NSCache alloc] init];
            sShareCaches[cacheName] = cache;
        }

        return cache;
    }
}

+ (NSDictionary *)allSharedCaches
{
    return sShareCaches;
}

@end