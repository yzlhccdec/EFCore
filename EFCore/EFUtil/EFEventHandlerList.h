//
// Created by yizhuolin on 12-8-13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface EFEventHandlerList : NSObject

- (void)addObserver:(id)observer handler:(id)handler;

- (void)clear;

- (void)fireEventUsingBlock:(void (^)(id))block;

- (void)removeObserver:(id)observer;


@end