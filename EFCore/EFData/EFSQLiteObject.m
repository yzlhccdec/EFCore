//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//
#undef DLog

#define DLog(...)

#import <objc/runtime.h>
#import "EFSQLiteObject.h"
#import "EFKeyValuePair.h"

@interface EFSQLiteObject () {
    NSMutableArray *_changedProperties;
    BOOL _isKVORegistered;
    NSArray *_fieldsForPersistence;
}

- (void)registerForKVO;

- (void)unregisterFromKVO;

@end

@implementation EFSQLiteObject

- (NSArray *)changedFields
{
    return _changedProperties;
}

- (NSArray *)fieldsForPersistence
{
    if (!_fieldsForPersistence) {
        NSMutableArray *propertyList = [[NSMutableArray alloc] init];
        Class class = [self class];

        while (class != [EFSQLiteObject class]) {
            NSUInteger count;
            objc_property_t *properties = class_copyPropertyList(class, &count);

            NSArray *excludedProperties = self.excludedFields;
            NSMutableArray *addedProperties = [[NSMutableArray alloc] init];

            for (int i = 0; i < count; i++) {
                EFKeyValuePair *pair = [[EFKeyValuePair alloc] initWithKey:@(property_getName(properties[i])) andValue:@(property_getAttributes(properties[i]))];
                //DLog(@"%s", name)
                if (![excludedProperties containsObject:pair.key] && ![addedProperties containsObject:pair.key]) {
                    [propertyList addObject:pair];
                    [addedProperties addObject:pair.key];
                }
            }

            free(properties);

            class = [class superclass];
        }

        _fieldsForPersistence = propertyList;
    }

    return _fieldsForPersistence;
}

- (void)startModification
{
    _changedProperties = [[NSMutableArray alloc] init];
    if (_isKVORegistered == NO) {
        [self registerForKVO];
    }
}

- (void)endModification
{
    [_changedProperties removeAllObjects];

    if (_isKVORegistered) {
        [self unregisterFromKVO];
    }
}

#pragma mark - private

- (void)registerForKVO
{
    DLog("register");
    _isKVORegistered = YES;
    NSArray *observableKeypaths = self.fieldsForPersistence;
    for (EFKeyValuePair *pair in observableKeypaths) {
        [self addObserver:self forKeyPath:pair.key options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    DLog("unregister");
    _isKVORegistered = NO;
    NSArray *observableKeypaths = self.fieldsForPersistence;
    for (EFKeyValuePair *pair in observableKeypaths) {
        [self removeObserver:self forKeyPath:pair.key];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    for (EFKeyValuePair *pair in self.fieldsForPersistence) {
        if ([((NSString *) pair.key) isEqualToString:keyPath] && ![self.primaryKey containsObject:keyPath]) {
            [_changedProperties addObject:keyPath];
        }
    }
}

- (void)dealloc
{
    if (_isKVORegistered) {
        [self unregisterFromKVO];
    }
}

@end