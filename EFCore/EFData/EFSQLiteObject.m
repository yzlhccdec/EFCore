//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//
//
#undef DLog

#define DLog(...)

#import <objc/runtime.h>
#import <FMDB/FMResultSet.h>
#import "EFSQLiteObject.h"
#import "EFKeyValuePair.h"
#import "EFSQLiteObject+EFPrivate.h"
#import "EFObject+Private.h"


@interface EFSQLiteObject () {
    NSMutableArray *_changedProperties;
    BOOL _isKVORegistered;
}

- (void)registerForKVO;

- (void)unregisterFromKVO;

@end

@implementation EFSQLiteObject

- (id)initWithFMResultSet:(FMResultSet *)resultSet {
    return [self initWithFMResultSet:resultSet ignoreFieldNotExist:NO];
}

- (id)initWithFMResultSet:(FMResultSet *)resultSet ignoreFieldNotExist:(BOOL)ignore {
    self = [super init];
    if (self) {
        for (EFKeyValuePair *field in [[self class] fieldsForPersistence]) {
            if (ignore && ![[resultSet columnNameToIndexMap] objectForKey:[field.key lowercaseString]]) {
                 
                continue; 
            }
            id value = resultSet[field.key];
            if (value != nil && value != [NSNull null]) {
                [self setValue:value forKey:field.key];
            }
        }
    }

    return self;
}

- (NSArray *)changedFields {
    return _changedProperties;
}

+ (NSSet *)excludedFields {
    return nil;
}

+ (NSArray *)fieldsForPersistence {
    if (self == [EFSQLiteObject class]) {
        return nil;
    }

    NSArray *cachedFields = objc_getAssociatedObject(self, _cmd);
    if (cachedFields != nil) {
        return cachedFields;
    }

    NSMutableArray *fields = [[[self superclass] fieldsForPersistence] mutableCopy];

    if (!fields) {
        fields = [NSMutableArray array];
    }

    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(self, &count);

    NSSet *excludedProperties = [self excludedFields];
    NSMutableDictionary *propertyIndex = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < count; i++) {
        EFKeyValuePair *pair = [[EFKeyValuePair alloc] initWithKey:@(property_getName(properties[i])) andValue:@(property_getAttributes(properties[i]))];
        if ([self isStorageProperty:pair.key]) {
            propertyIndex[pair.key] = pair;
        }
    }

    [propertyIndex removeObjectsForKeys:excludedProperties.allObjects];
    free(properties);

    [fields addObjectsFromArray:propertyIndex.allValues];
    objc_setAssociatedObject(self, _cmd, fields, OBJC_ASSOCIATION_COPY);

    return fields;
}

+ (NSArray *)primaryKey {
    [NSException raise:@"Invalid Primary Key" format:@"No primary key defined in %@", self];
    return nil;
}

+ (NSString *)tableName {
    return NSStringFromClass([self class]);
}

- (void)startModification {
    _changedProperties = [[NSMutableArray alloc] init];
    if (!_isKVORegistered) {
        [self registerForKVO];
    }
}

- (void)endModification {
    //delay clean the changedProperties
    // [_changedProperties removeAllObjects];

    if (_isKVORegistered) {
        [self unregisterFromKVO];
    }
}

#pragma mark - private

- (void)registerForKVO {
    DLog("register");
    _isKVORegistered = YES;
    NSArray *observableKeyPaths = [[self class] fieldsForPersistence];
    for (EFKeyValuePair *pair in observableKeyPaths) {
        [self addObserver:self forKeyPath:pair.key options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    DLog("unregister");
    _isKVORegistered = NO;
    NSArray *observableKeyPaths = [[self class] fieldsForPersistence];
    for (EFKeyValuePair *pair in observableKeyPaths) {
        [self removeObserver:self forKeyPath:pair.key];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    for (EFKeyValuePair *pair in [[self class] fieldsForPersistence]) {
        if ([((NSString *) pair.key) isEqualToString:keyPath] && ![[[self class] primaryKey] containsObject:keyPath]) {
            [_changedProperties addObject:keyPath];
        }
    }
}

- (void)dealloc {
    if (_isKVORegistered) {
        [self unregisterFromKVO];
    }
}

@end