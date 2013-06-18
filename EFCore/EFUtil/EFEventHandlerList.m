//
// Created by yizhuolin on 12-8-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFEventHandlerList.h"

@interface EFEventHandlerList () {
    NSMutableDictionary *_listeners;
    NSMutableArray *_listenerArray;
}

@end

@implementation EFEventHandlerList

- (id)init
{
    self = [super init];

    if (self) {
        _listeners = [[NSMutableDictionary alloc] init];
        _listenerArray = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)addObserver:(id)observer handler:(id)handler
{
    @synchronized (self) {
        id handlerCopy = [handler copy];
        id hash = @([observer hash]);

        id originalHandler = [_listeners objectForKey:hash];

        if (originalHandler) {
            [_listenerArray removeObject:originalHandler];
        }

        [_listeners setObject:handlerCopy forKey:hash];
        [_listenerArray addObject:handlerCopy];
    }
}

- (void)clear
{
    @synchronized (self) {
        [_listeners removeAllObjects];
        [_listenerArray removeAllObjects];
    }
}

- (void)fireEventUsingBlock:(void (^)(id))block
{
    @synchronized (self) {
        for (id listener in _listenerArray) {
            block(listener);
        }
    }
}

- (void)removeObserver:(id)observer
{
    @synchronized (self) {
        id hash = @([observer hash]);

        id originalHandler = [_listeners objectForKey:hash];

        if (originalHandler) {
            [_listenerArray removeObject:originalHandler];
        }

        [_listeners removeObjectForKey:hash];
    }
}


@end