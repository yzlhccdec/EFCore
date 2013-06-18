//
// Created by yizhuolin on 12-8-28.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFQueue.h"

@protocol EFQueueExtended <EFQueue>

- (void)addObjects:(NSArray *)objects;

// Removes all objects from the queue
- (void)removeAllObjects;

- (BOOL)containsObject:(id)object;

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end