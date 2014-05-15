//
// Created by yizhuolin on 12-8-30.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class FMDatabase;

typedef void (^IllegalDatabaseVersionFoundHandler)(NSInteger currentVersion, NSInteger newVersion);

@interface EFSQLiteHelper : NSObject {
    FMDatabase *_database;
}

- (id)initWithPath:(NSString *)path andVersion:(NSUInteger)version;

- (void)close;

- (void)inDatabase:(void (^)(FMDatabase *))block;

- (void)inDeferredTransaction:(void (^)(FMDatabase *, BOOL *))block;

- (void)inTransaction:(void (^)(FMDatabase *, BOOL *))block;

- (BOOL)attachDatabaseAtPath:(NSString *)path alias:(NSString *)alias;

- (BOOL)detachDatabase:(NSString *)alias;

- (void)onOpen:(FMDatabase *)database;

- (void)onUpgrade:(FMDatabase *)database databaseVersion:(NSUInteger)databaseVersion currentVersion:(NSUInteger)currentVersion;

- (void)onCreate:(FMDatabase *)database;

+ (void)addIllegalDatabaseVersionFoundHandler:(IllegalDatabaseVersionFoundHandler)block;
@end