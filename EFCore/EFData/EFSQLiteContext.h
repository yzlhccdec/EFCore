//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class EFSQLiteObject;
@class EFSQLiteHelper;

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

- (BOOL)addObjects:(NSArray *)objects;

- (BOOL)addObject:(EFSQLiteObject *)object withConflictOption:(ConflictOption)option;

- (BOOL)addObjects:(NSArray *)objects withConflictOption:(ConflictOption)option;

- (BOOL)removeObject:(EFSQLiteObject *)object;

- (BOOL)updateObject:(EFSQLiteObject *)object;

- (NSArray *)getObjects:(Class)objectClass query:(NSString *)query, ...;
@end