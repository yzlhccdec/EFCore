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

@property (nonatomic, readonly) EFSQLiteHelper *helper;

- (id)initWithHelper:(EFSQLiteHelper *)helper;

- (BOOL)addObject:(EFSQLiteObject *)object;

- (BOOL)addObjects:(NSArray<EFSQLiteObject *> *)objects;

- (BOOL)addObject:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option;

- (BOOL)addObjects:(NSArray *)objects withConflictOption:(ConflictOption)option;

- (BOOL)removeObject:(EFSQLiteObject *)object;

- (BOOL)updateObject:(EFSQLiteObject *)object;

- (NSArray<EFSQLiteObject *> *)getObjects:(Class)objectClass query:(NSString *)query, ...;

- (NSArray<EFSQLiteObject *> *)getObjectsWithBlock:(Class (^)(FMResultSet *resultSet))block query:(NSString *)query, ...;
@end