//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFSynchronizedQueue.h"

@interface EFSynchronizedQueue () {
    id <EFQueue> _queue;
    BOOL _supportExtendedFunctions;
}

@end

@implementation EFSynchronizedQueue

- (id)init
{
    return nil;
}

- (id)initWithQueue:(id <EFQueue>)queue
{
    self = [super init];

    if (self) {
        _queue = queue;
        _supportExtendedFunctions = [self conformsToProtocol:@protocol(EFQueueExtended)];
    }

    return self;
}

- (NSUInteger)count
{
    @synchronized (self) {
        return [_queue count];
    }
}

- (void)addObject:(id)object
{
    @synchronized (self) {
        [_queue addObject:object];
    }
}

- (void)removeObject:(id)object
{
    @synchronized (self) {
        [_queue removeObject:object];
    }
}


- (id)pollObject
{
    @synchronized (self) {
        return [_queue pollObject];
    }
}

- (id)peekObject
{
    @synchronized (self) {
        return [_queue peekObject];
    }
}

- (void)addObjects:(NSArray *)objects
{
    if (_supportExtendedFunctions) {
        @synchronized (self) {
            [((id <EFQueueExtended>) _queue) addObjects:objects];
        }
    }
}

- (void)removeAllObjects
{
    if (_supportExtendedFunctions) {
        @synchronized (self) {
            [((id <EFQueueExtended>) _queue) removeAllObjects];
        }
    }
}

- (BOOL)containsObject:(id)object
{
    if (_supportExtendedFunctions) {
        @synchronized (self) {
            return [((id <EFQueueExtended>) _queue) containsObject:object];
        }
    }

    return false;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    if (_supportExtendedFunctions) {
        @synchronized (self) {
            [((id <EFQueueExtended>) _queue) enumerateObjectsUsingBlock:block];
        }
    }
}


@end