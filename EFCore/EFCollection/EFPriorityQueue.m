/*
#import "EFPriorityQueue.h"

@implementation EFPriorityQueue {
    CFBinaryHeapRef _heap;
}

#pragma mark CFBinaryHeap functions for sorting the priority queue

static const void *ObjectRetain(CFAllocatorRef allocator, const void *ptr)
{
    return CFBridgingRetain((__bridge id) ptr);
}

static void ObjectRelease(CFAllocatorRef allocator, const void *ptr)
{
    CFBridgingRelease(ptr);
}

static CFStringRef ObjectCopyDescription(const void *ptr)
{
    id event = (__bridge id) ptr;
    CFStringRef desc = (__bridge CFStringRef) [event description];
    return desc;
}

static void ObjectApplier(const void *val, void *context)
{
    Applier applier = (__bridge Applier)context;
    applier((__bridge id)val);
}

static CFComparisonResult ObjectCompare(const void *ptr1, const void *ptr2, void *context)
{
    id<EFComparable> item1 = (__bridge id<EFComparable>) ptr1;
    id<EFComparable> item2 = (__bridge id<EFComparable>) ptr2;

    return [item1 compareTo:item2];
}

#pragma mark NSObject methods

- (id)init
{
    if ((self = [super init])) {

        CFBinaryHeapCallBacks callbacks;
        callbacks.version = 0;

        // Callbacks to the functions above
        callbacks.retain = ObjectRetain;
        callbacks.release = ObjectRelease;
        callbacks.copyDescription = ObjectCopyDescription;
        callbacks.compare = ObjectCompare;

        // Create the priority queue
        _heap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, NULL);
    }

    return self;
}

- (void)dealloc
{
    if (_heap) {
        CFRelease(_heap);
    }
}

- (NSString *)description
{
    if (_heap && self.count) {
        NSMutableString *desc = [[NSMutableString alloc] init];
        [self enumerateObjectsUsingBlock:^(id item) {
            [desc appendString:[item description]];
            [desc appendString:@","];
        }];

        return [NSString stringWithFormat:@"EFPriorityQueue = {%@}", desc];
    }

    return [NSString stringWithFormat:@"EFPriorityQueue = null"];
}

#pragma mark -
#pragma mark Queue methods

- (NSUInteger)count
{
    return CFBinaryHeapGetCount(_heap);
}

- (void)addObject:(id)object
{
    CFBinaryHeapAddValue(_heap, (__bridge void *) object);
}

- (void)removeAllObjects
{
    CFBinaryHeapRemoveAllValues(_heap);
}

- (id)poll
{
    id obj = [self peek];
    CFBinaryHeapRemoveMinimumValue(_heap);
    return obj;
}

- (id)peek
{
    return (__bridge id) CFBinaryHeapGetMinimum(_heap);
}

- (void)enumerateObjectsUsingBlock:(Applier)block
{
    CFBinaryHeapApplyFunction(_heap, ObjectApplier, (__bridge void*)block);
}


@end*/

#import "EFPriorityQueue.h"

@interface EFPriorityQueue () {
    NSMutableArray *_queue;
    BOOL _useHashToCompare;
}

- (void)insertObject:(id)object;

- (void)unregisterFromKVO:(id)object;

@end

@implementation EFPriorityQueue

- (id)init
{
    self = [super init];

    if (self) {
        _queue = [[NSMutableArray alloc] init];
    }

    return self;
}

- (id)initWithArray:(NSArray *)array
{
    self = [super init];

    if (self) {
        _queue = [[NSMutableArray alloc] initWithCapacity:[array count]];
        [self addObjects:array];
    }

    return self;
}

- (NSUInteger)count
{
    return _queue.count;
}

- (void)addObject:(id)object
{
    if (![object conformsToProtocol:@protocol(EFComparable)]) {
        _useHashToCompare = true;
    }

    if ([object respondsToSelector:@selector(keyPathForObserving)]) {
        [object addObserver:self forKeyPath:[object keyPathForObserving] options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }

    if ([_queue count] == 0) {
        [_queue addObject:object];
    } else {
        [self insertObject:object];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUInteger count = _queue.count;
    if (count > 1 && ![[change objectForKey:@"old"] isEqual:[change objectForKey:@"new"]]) {
        id <EFComparable> obj = object;
        NSUInteger position = [_queue indexOfObject:object];
        BOOL flag = false;
        while (position > 0) {
            if ([obj compareTo:[_queue objectAtIndex:position - 1]] != kCFCompareLessThan) {
                break;
            } else {
                [_queue exchangeObjectAtIndex:position withObjectAtIndex:position - 1];
                position--;
                flag = true;
            }
        }

        if (flag) {
            return;
        }

        count--;

        while (position < count) {
            if ([obj compareTo:[_queue objectAtIndex:position + 1]] != kCFCompareGreaterThan) {
                break;
            } else {
                [_queue exchangeObjectAtIndex:position withObjectAtIndex:position + 1];
                position++;
            }
        }
    }
}

- (void)addObjects:(NSArray *)objects
{
    for (id object in objects) {
        [self addObject:object];
    }
}

- (void)removeAllObjects
{
    [self unregisterFromKVO:nil];
    [_queue removeAllObjects];
}

- (void)removeObject:(id)object
{
    [self unregisterFromKVO:object];
    [_queue removeObject:object];
}

- (BOOL)containsObject:(id)object
{
    return [_queue containsObject:object];
}

- (id)pollObject
{
    NSUInteger size = _queue.count;
    if (size == 0) {
        return nil;
    }

    id result = [_queue objectAtIndex:0];
    [self unregisterFromKVO:result];
    [_queue removeObjectAtIndex:0];

    return result;
}

- (id)peekObject
{
    if (_queue.count == 0) {
        return nil;
    }

    return [_queue objectAtIndex:0];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [_queue enumerateObjectsUsingBlock:block];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])buffer count:(NSUInteger)len
{
    return [_queue countByEnumeratingWithState:state objects:buffer count:len];
}

- (void)insertObject:(id)object
{
    NSUInteger low = 0;
    NSUInteger high = _queue.count - 1;
    NSUInteger mid = 0;

    if (!_useHashToCompare) {
        if ([((id <EFComparable>) [_queue objectAtIndex:0]) compareTo:object] != kCFCompareLessThan) {
            [_queue insertObject:object atIndex:0];
            return;
        }

        if ([((id <EFComparable>) [_queue objectAtIndex:high]) compareTo:object] != kCFCompareGreaterThan) {
            [_queue addObject:object];
            return;
        }

        while (low <= high) {
            mid = low + ((high - low) >> 1);

            id <EFComparable> objectToCompare = (id <EFComparable>) [_queue objectAtIndex:mid];

            if ([objectToCompare compareTo:object] == kCFCompareEqualTo) {
                [_queue insertObject:object atIndex:mid];
                return;
            }

            if ([objectToCompare compareTo:object] == kCFCompareGreaterThan) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }
    } else {
        if ([[_queue objectAtIndex:0] hash] >= [object hash]) {
            [_queue insertObject:object atIndex:0];
            return;
        }

        if ([[_queue objectAtIndex:high] hash] <= [object hash]) {
            [_queue addObject:object];
            return;
        }

        while (low < high) {
            mid = low + ((high - low) >> 1);

            id <EFComparable> objectToCompare = (id <EFComparable>) [_queue objectAtIndex:mid];

            if ([objectToCompare hash] == [object hash]) {
                [_queue insertObject:object atIndex:mid];
                return;
            }

            if ([objectToCompare hash] > [object hash]) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        }

    }

    [_queue insertObject:object atIndex:low];
}

- (void)unregisterFromKVO:(id)object
{
    if (object != nil) {
        if ([object respondsToSelector:@selector(keyPathForObserving)]) {
            [object removeObserver:self forKeyPath:[object keyPathForObserving]];
        }
    } else {
        for (id item in _queue) {
            if ([item respondsToSelector:@selector(keyPathForObserving)]) {
                [item removeObserver:self forKeyPath:[item keyPathForObserving]];
            }
        }
    }
}

- (void)dealloc
{
    [self unregisterFromKVO:nil];
}
@end