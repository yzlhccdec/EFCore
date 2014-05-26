//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//
#undef DLog

#define DLog(...)

#import <objc/runtime.h>
#import <FMDB/FMResultSet.h>
#import "EFSQLiteObject.h"
#import "EFKeyValuePair.h"
#import "EFSQLiteObject+EFPrivate.h"

@interface EFSQLiteObject ()
{
    NSMutableArray *_changedProperties;
    BOOL           _isKVORegistered;
}

- (void)registerForKVO;

- (void)unregisterFromKVO;

@end

static NSMutableDictionary *sFieldProperties;

@implementation EFSQLiteObject

+ (void)initialize
{
    if ([self class] == [EFSQLiteObject class]) {
        sFieldProperties = [NSMutableDictionary dictionary];
    } else {
        [self __inspectProperties];
    }
}

- (id)initWithFMResultSet:(FMResultSet *)resultSet
{
    self = [super init];
    if (self) {
        for (EFKeyValuePair *field in [[self class] fieldsForPersistence]) {
            id value = resultSet[field.key];
            if (value != nil && value != [NSNull null]) {
                [self setValue:value forKey:field.key];
            }
        }
    }

    return self;
}

- (NSArray *)changedFields
{
    return _changedProperties;
}

+ (NSSet *)excludedFields
{
    return nil;
}

+ (NSArray *)fieldsForPersistence
{
    return [sFieldProperties[NSStringFromClass([self class])] allValues];
}

+ (NSArray *)primaryKey
{
    [NSException raise:@"Invalid Primary Key" format:@"No primary key defined in %@", self];
    return nil;
}

+ (NSString *)tableName
{
    return NSStringFromClass([self class]);
}

+ (void)__inspectProperties
{
    NSMutableDictionary *propertyIndex = [sFieldProperties[NSStringFromClass([self superclass])] mutableCopy];
    if (propertyIndex == nil) {
        propertyIndex = [[NSMutableDictionary alloc] init];
    }

    Class class                 = [self class];

    NSUInteger      count;
    objc_property_t *properties = class_copyPropertyList(class, &count);

    NSSet *excludedProperties = [self excludedFields];

    for (int i = 0; i < count; i++) {
        EFKeyValuePair *pair = [[EFKeyValuePair alloc] initWithKey:@(property_getName(properties[i])) andValue:@(property_getAttributes(properties[i]))];
        propertyIndex[pair.key] = pair;
    }

    [propertyIndex removeObjectsForKeys:excludedProperties.allObjects];
    free(properties);

    sFieldProperties[NSStringFromClass([self class])] = propertyIndex;
}

- (void)startModification
{
    _changedProperties = [[NSMutableArray alloc] init];
    if (!_isKVORegistered) {
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
    NSArray             *observableKeyPaths = [[self class] fieldsForPersistence];
    for (EFKeyValuePair *pair in observableKeyPaths) {
        [self addObserver:self forKeyPath:pair.key options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO
{
    DLog("unregister");
    _isKVORegistered = NO;
    NSArray             *observableKeyPaths = [[self class] fieldsForPersistence];
    for (EFKeyValuePair *pair in observableKeyPaths) {
        [self removeObserver:self forKeyPath:pair.key];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    for (EFKeyValuePair *pair in [[self class] fieldsForPersistence]) {
        if ([((NSString *) pair.key) isEqualToString:keyPath] && ![[[self class] primaryKey] containsObject:keyPath]) {
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