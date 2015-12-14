//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class EFSQLiteObject;
@class EFSQLiteHelper;
@class FMResultSet;

typedef enum {
    ConflictOptionRollback,
    ConflictOptionAbort,
    ConflictOptionIgnore,
    ConflictOptionFail,
    ConflictOptionReplace
} ConflictOption;


@interface EFSQLiteContext : NSObject

@property(nonatomic, readonly) EFSQLiteHelper *helper;

- (id)initWithHelper:(EFSQLiteHelper *)helper;

- (BOOL)addObject:(EFSQLiteObject *)object;

- (BOOL)addObjects:(NSArray<EFSQLiteObject *> *)objects;

- (BOOL)addObject:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option;

- (BOOL)addObjects:(NSArray *)objects withConflictOption:(ConflictOption)option;

- (BOOL)removeObject:(EFSQLiteObject *)object;

- (BOOL)removeObject:(EFSQLiteObject *)object withCondition:(NSString *)condition;

- (BOOL)updateObject:(EFSQLiteObject *)object;

- (BOOL)updateObject:(EFSQLiteObject *)object withCondition:(NSString *)condition

- (NSArray<EFSQLiteObject *> *)getObjects:(Class)objectClass query:(NSString *)query, ...;

- (NSArray<EFSQLiteObject *> *)getObjectsWithBlock:(EFSQLiteObject *(^)(FMResultSet *))block query:(NSString *)query, ...;

- (void)enumerateResultSetUsingBlock:(void (^)(FMResultSet *, BOOL *))block query:(NSString *)query, ...;
@end