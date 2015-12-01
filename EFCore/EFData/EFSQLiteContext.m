//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <objc/runtime.h>
#import "EFSQLiteContext.h"
#import "EFSQLiteObject.h"
#import "EFSQLiteHelper.h"
#import "FMDatabase.h"
#import "EFKeyValuePair.h"

@interface EFSQLiteContext ()

- (NSString *)buildUpdateSQL:(EFSQLiteObject *)object;

- (NSString *)buildInsertSQL:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option;

- (NSString *)buildDeleteSQL:(EFSQLiteObject *)object;


@end

static NSMutableDictionary *sUpdateSQLs;
static NSMutableDictionary *sInsertSQLs;
static NSMutableDictionary *sDeleteSQLs;

@implementation EFSQLiteContext

+ (void)initialize
{
    if (self == [EFSQLiteContext class]) {
        sUpdateSQLs = [[NSMutableDictionary alloc] init];
        sInsertSQLs = [[NSMutableDictionary alloc] init];
        sDeleteSQLs = [[NSMutableDictionary alloc] init];
    }
}


- (id)init
{
    [NSException raise:@"EFSQLiteContext Error" format:@"use initWithHelper: to create context"];
    return nil;
}

- (id)initWithHelper:(EFSQLiteHelper *)helper
{
    self = [super init];
    if (self) {
        _helper = helper;
    }
    return self;
}

- (BOOL)addObject:(EFSQLiteObject *)object
{
    return [self addObject:object withConflictOption:ConflictOptionAbort];
}

- (BOOL)addObjects:(NSArray *)objects
{
    return [self addObjects:objects withConflictOption:ConflictOptionAbort];
}

- (BOOL)addObject:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option
{
    __block BOOL result;

    [_helper inDatabase:^(FMDatabase *database) {
        result = [self addObject:object withConflictOption:option toDatabase:database];
    }];


    return result;
}

- (BOOL)addObject:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option toDatabase:(FMDatabase *)database
{
    NSString *className    = @(object_getClassName([object class]));
    NSString *insertSQLKey = [NSString stringWithFormat:@"%@_%@", className, @(option)];

    NSString *insertSQL = sInsertSQLs[insertSQLKey];

    if (!insertSQL) {
        insertSQL = [self buildInsertSQL:object withConflictOption:option];
        sInsertSQLs[insertSQLKey] = insertSQL;
    }

    NSArray        *fields      = [[object class] fieldsForPersistence];
    NSMutableArray *fieldValues = [[NSMutableArray alloc] initWithCapacity:[fields count]];

    for (EFKeyValuePair *pair in fields) {
        if ([((NSString *) pair.value) rangeOfString:@"R,"].location == NSNotFound) {
            [fieldValues addObject:[object valueForKey:pair.key] ?: [NSNull null]];
        }
    }

    return [database executeUpdate:insertSQL withArgumentsInArray:fieldValues];
}

- (BOOL)addObjects:(NSArray<EFSQLiteObject *> *)objects withConflictOption:(ConflictOption)option
{
    __block BOOL result;

    [_helper inTransaction:^(FMDatabase *database, BOOL *rollback) {
        for (EFSQLiteObject *object in objects) {
            *rollback = ![self addObject:object withConflictOption:option toDatabase:database];

            if (*rollback) {
                break;
            }
        }

        result = !*rollback;
    }];

    return result;
}

- (BOOL)removeObject:(EFSQLiteObject *)object
{
    __block BOOL result;

    NSString *className = [NSString stringWithFormat:@"%s", object_getClassName([object class])];

    NSString *deleteSQL = sDeleteSQLs[className];

    if (!deleteSQL) {
        deleteSQL = [self buildDeleteSQL:object];
        sDeleteSQLs[className] = deleteSQL;
    }

    NSArray        *primaryKey  = [[object class] primaryKey];
    NSMutableArray *fieldValues = [[NSMutableArray alloc] initWithCapacity:[primaryKey count]];

    for (NSString *field in primaryKey) {
        [fieldValues addObject:[object valueForKey:field]];
    }

    [_helper inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:deleteSQL withArgumentsInArray:fieldValues];
    }];

    return result;
}

- (BOOL)updateObject:(EFSQLiteObject *)object
{
    if (![object.changedFields count]) {
        [object endModification];
        return NO;
    }

    NSString *className = [NSString stringWithFormat:@"%s", object_getClassName([object class])];

    NSString *keyForUpdateSQL = [[object.changedFields componentsJoinedByString:@""] stringByAppendingString:className];

    NSString *updateSQL;

    updateSQL = sUpdateSQLs[keyForUpdateSQL];

    if (!updateSQL) {
        updateSQL = [self buildUpdateSQL:object];
        sUpdateSQLs[keyForUpdateSQL] = updateSQL;
    }

    __block BOOL result;

    NSArray        *fields      = object.changedFields;
    NSMutableArray *fieldValues = [[NSMutableArray alloc] initWithCapacity:[fields count] + [[[object class] primaryKey] count]];

    for (NSString *field in fields) {
        [fieldValues addObject:[object valueForKey:field]];
    }

    for (NSString *field in [[object class] primaryKey]) {
        [fieldValues addObject:[object valueForKey:field]];
    }


    [_helper inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:updateSQL withArgumentsInArray:fieldValues];
    }];

    if (!result) {
        NSLog(@"update object failed");
    }
    [object endModification];

    return result;
}

- (NSArray<EFSQLiteObject *> *)getObjects:(Class)objectClass query:(NSString *)query, ...
{
    if ([objectClass isSubclassOfClass:[EFSQLiteObject class]]) {
        NSMutableArray *result = [[NSMutableArray alloc] init];

        va_list args;
        va_start(args, query);
        va_list *argsReference = &args;

        [self.helper inDatabase:^(FMDatabase *database) {

            FMResultSet *resultSet = [database executeQuery:query withVAList:*argsReference];

            while ([resultSet next]) {
                id item = [(EFSQLiteObject *) [objectClass alloc] initWithFMResultSet:resultSet];
                [result addObject:item];
            }
        }];

        va_end(args);

        return result;
    } else {
        [NSException raise:[NSString stringWithFormat:@"%@ Error", NSStringFromClass([self class])] format:@"object must be a subclass of EFSQLiteObject"];
    }
}

- (NSArray<EFSQLiteObject *> *)getObjectsWithBlock:(EFSQLiteObject* (^)(FMResultSet *resultSet))block query:(NSString *)query, ...
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    va_list args;
    va_start(args, query);
    va_list *argsReference = &args;

    [self.helper inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:query withVAList:*argsReference];

        while ([resultSet next]) {
            @autoreleasepool {
                EFSQLiteObject *object = block(resultSet);
                if ([object isKindOfClass:[EFSQLiteObject class]]) {
                    [result addObject:object];
                } else if (object) {
                    [NSException raise:[NSString stringWithFormat:@"%@ Error", NSStringFromClass([object class])] format:@"object must be a subclass of EFSQLiteObject"];
                }
            }
        }
    }];

    va_end(args);

    return result;
}

- (void)enumerateResultSetUsingBlock:(void (^)(FMResultSet *resultSet, BOOL *stop))block query:(NSString *)query, ...
{
    va_list args;
    va_start(args, query);
    va_list *argsReference = &args;

    [self.helper inDatabase:^(FMDatabase *database) {

        FMResultSet *resultSet = [database executeQuery:query withVAList:*argsReference];
        BOOL stop = NO;

        while ([resultSet next]) {
            @autoreleasepool {
                block(resultSet, &stop);
            }

            if (stop) {
                break;
            }
        }
    }];

    va_end(args);
}

#pragma mark - private

- (NSString *)buildUpdateSQL:(EFSQLiteObject *)object
{
    NSArray         *primaryKey  = [[object class] primaryKey];
    NSMutableString *whereClause = [[NSMutableString alloc] init];

    if (![primaryKey count]) {
        [NSException raise:@"Invalid Primary Key" format:@"No primary key defined in %@", object];
    } else {
        for (NSString *key in primaryKey) {
            [whereClause appendFormat:@"%@ = ?", key];
            [whereClause appendString:@" AND "];
        }
    }

    NSArray         *fields       = object.changedFields;
    NSMutableString *updateFields = [[NSMutableString alloc] init];

    for (NSString *field in fields) {
        [updateFields appendFormat:@"%@ = ?", field];
        [updateFields appendString:@","];
    }

    return [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@", [[object class] tableName], [updateFields substringToIndex:[updateFields length] - 1], [whereClause substringToIndex:[whereClause length] - 5]];
}

- (NSString *)buildInsertSQL:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option
{
    NSMutableString *paramNames  = [[NSMutableString alloc] init];
    NSMutableString *paramValues = [[NSMutableString alloc] init];
    NSArray         *fields      = [[object class] fieldsForPersistence];

    for (EFKeyValuePair *field in fields) {
        if ([((NSString *) field.value) rangeOfString:@"R,"].location == NSNotFound) {
            [paramNames appendString:field.key];
            [paramNames appendString:@","];
            [paramValues appendString:@"?"];
            [paramValues appendString:@","];
        }


    }

    NSString *optionString;

    switch (option) {
        case ConflictOptionFail: {
            optionString = @"OR FAIL";
            break;
        }
        case ConflictOptionIgnore: {
            optionString = @"OR IGNORE";
            break;
        }
        case ConflictOptionReplace: {
            optionString = @"OR REPLACE";
            break;
        }
        case ConflictOptionRollback: {
            optionString = @"OR ROLLBACK";
            break;
        }
        default: {
            optionString = @"";
            break;
        }
    }

    return [[NSString alloc] initWithFormat:@"INSERT %@ INTO %@(%@) VALUES(%@);",
                                            optionString,
                                            [[object class] tableName] ?: @(object_getClassName(object)),
                                            [paramNames substringToIndex:[paramNames length] - 1],
                                            [paramValues substringToIndex:[paramValues length] - 1]];
}

- (NSString *)buildDeleteSQL:(EFSQLiteObject *)object
{
    NSArray         *primaryKey = [[object class] primaryKey];
    NSMutableString *param      = [[NSMutableString alloc] init];

    if (![primaryKey count]) {
        [NSException raise:@"Invalid Primary Key" format:@"No primary key defined in %@", object];
    } else {
        for (NSString *key in primaryKey) {
            [param appendFormat:@"%@ = ?", key];
            [param appendString:@" AND "];
        }
    }

    return [[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@", [[object class] tableName] ?: @(object_getClassName(object)), [param substringToIndex:[param length] - 5]];
}

@end