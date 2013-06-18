//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol EFQueue <NSObject>
// Returns number of items in the queue
- (NSUInteger)count;

// Adds an object to the queue
- (void)addObject:(id)object;

- (void)removeObject:(id)object;

// Removes the "top-most" (as determined by the callback sort function) object from the queue
// and returns it
- (id)pollObject;

// Returns the "top-most" (as determined by the callback sort function) object from the queue
// without removing it from the queue
- (id)peekObject;

@end