//
// Created by yizhuolin on 12-8-30.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class FMDatabase;

typedef void (^IllegalDatabaseVersionFoundHandler)(NSInteger currentVersion, NSInteger newVersion);

@interface EFSQLiteHelper : NSObject {
    FMDatabase *_database;
}

@property (nonatomic, copy) IllegalDatabaseVersionFoundHandler illegalDatabaseVersionFoundHandler;
@property (nonatomic, copy) NSString *encryptionKey;
@property (nonatomic, readonly) NSString *path;


- (id)initWithPath:(NSString *)path andVersion:(NSUInteger)version;

- (void)close;

- (void)inDatabase:(void (^)(FMDatabase *))block;

- (void)inDeferredTransaction:(void (^)(FMDatabase *, BOOL *))block;

- (void)inTransaction:(void (^)(FMDatabase *, BOOL *))block;

#if SQLITE_VERSION_NUMBER >= 3007000
- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block;
#endif

- (void)attachDatabaseAtPath:(NSString *)path alias:(NSString *)alias password:(NSString *)password;

- (BOOL)detachDatabase:(NSString *)alias;

- (void)onOpen:(FMDatabase *)database;

- (void)onUpgrade:(FMDatabase *)database databaseVersion:(NSUInteger)databaseVersion currentVersion:(NSUInteger)currentVersion;

- (void)onCreate:(FMDatabase *)database;

- (FMDatabase *)onPasswordErrorWithDBFilePath:(NSString *)dbFilePath;

@end