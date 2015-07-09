//
// Created by yizhuolin on 12-8-30.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFSQLiteHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#undef DLog
#define DLog(...)

@interface EFSQLiteHelper ()
{
    NSUInteger     _version;
    NSString       *_path;
    NSMutableArray *_statements;
}

@property (nonatomic, readonly) FMDatabase *database;

- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *, BOOL *))block;

- (NSUInteger)version:(FMDatabase *)database;

- (void)setVersion:(NSUInteger)version database:(FMDatabase *)database;

@end

@implementation EFSQLiteHelper

- (id)init
{
    return nil;
}

- (id)initWithPath:(NSString *)path andVersion:(NSUInteger)version
{
    self = [super init];

    if (self) {
        _path       = [path copy];
        _version    = version;
        _statements = [[NSMutableArray alloc] init];
    }

    return self;
}

- (NSString *)path
{
    return _path;
}

- (FMDatabase *)database
{
    if (_database && _database.sqliteHandle) {
        return _database;
    }

    BOOL       success   = NO;
    FMDatabase *database = nil;

    @try {
        database = [[FMDatabase alloc] initWithPath:_path];

        if ([database open]) {

            for (NSString *sql in _statements.reverseObjectEnumerator) {
                [database executeUpdate:sql];
                [_statements removeObject:sql];
            }

            //we don't need to check version when using temporary or in-memory database
            if ([_path length]) {

                if ([_encryptionKey length] > 0) {
                    [database setKey:_encryptionKey];
                    if (![database goodConnection]) {
                        database = [self onPasswordErrorWithDBFilePath:_path];
                        if (database == nil) {
                            [NSException raise:@"Database Password Error" format:@"Password Error"];
                        }
                    }
                }

                NSUInteger version = [self version:database];

                if (version > _version) {
                    if (_illegalDatabaseVersionFoundHandler) {
                        _illegalDatabaseVersionFoundHandler(version, _version);
                        return nil;
                    }

                    [NSException raise:@"Database version error" format:@"Can't downgrade database from %ld to %ld", (long) version, (long) _version];
                }

                if (version < _version) {
                    [database beginTransaction];

                    @try {
                        if (version == 0) {
                            [self onCreate:database];
                        } else {
                            [self onUpgrade:database databaseVersion:version currentVersion:_version];
                        }

                        [self setVersion:_version database:database];
                        [database commit];
                    }
                    @catch (NSException *e) {
                        [database rollback];
                    }
                }
            }

            [self onOpen:database];
            success = true;

            return database;
        }
    }
    @finally {
        //database may be closed after calling onOpen
        if ([database sqliteHandle]) {
            if (success) {
                if (_database) {
                    [_database close];
                }

                _database = database;
            } else {
                if (database) {
                    [database close];
                }
            }
        }
    }

    return _database;
}

- (void)onCreate:(FMDatabase *)database
{
    [NSException raise:@"Illegal function call" format:@"you must subclass EFSQLiteHelper and override this method.Do not call super method when overriding"];
}

- (FMDatabase *)onPasswordErrorWithDBFilePath:(NSString *)dbFilePath
{
    [NSException raise:@"Illegal function call" format:@"you must subclass EFSQLiteHelper and override this method.Do not call super method when overriding"];

    return nil;
}


- (void)onUpgrade:(FMDatabase *)database databaseVersion:(NSUInteger)databaseVersion currentVersion:(NSUInteger)currentVersion
{
    [NSException raise:@"Illegal function call" format:@"you must subclass EFSQLiteHelper and override this method.Do not call super method when overriding"];
}

- (void)close
{
    @synchronized (self) {
        [_database close];
        _database = nil;
    }
}

- (void)inDatabase:(void (^)(FMDatabase *db))block
{
    @synchronized (self) {
        FMDatabase *db = [self database];
        block(db);

        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [inDatabase:]");
        }
    }
}

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [self beginTransaction:YES withBlock:block];
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    [self beginTransaction:NO withBlock:block];
}

- (void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    @synchronized (self) {
        BOOL shouldRollback = NO;

        if (useDeferred) {
            [[self database] beginDeferredTransaction];
        }
        else {
            [[self database] beginTransaction];
        }

        block([self database], &shouldRollback);

        if (shouldRollback) {
            [[self database] rollback];
        }
        else {
            [[self database] commit];
        }
    }
}

- (void)onOpen:(FMDatabase *)database;
{
    [NSException raise:@"EFSQLiteHelper Error" format:@"you must subclass EFSQLiteHelper and override this method.Do not call super method when overriding"];
}

- (NSUInteger)version:(FMDatabase *)database
{
    return (NSUInteger) [database intForQuery:@"PRAGMA user_version"];
}

- (void)setVersion:(NSUInteger)version database:(FMDatabase *)database
{
    [database executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version = %lu", (unsigned long) version]];
}

- (void)attachDatabaseAtPath:(NSString *)path alias:(NSString *)alias password:(NSString *)password
{
    NSString     *attachSQL = [password length] ?
                              [NSString stringWithFormat:@"ATTACH DATABASE \'%s\' AS %s KEY '%s'", [path UTF8String], [alias UTF8String], [password UTF8String]] :
                              [NSString stringWithFormat:@"ATTACH DATABASE \'%s\' AS %s", [path UTF8String], [alias UTF8String]];
    if (_database && _database.sqliteHandle) {
        [_database executeUpdate:attachSQL];
    } else {
        [_statements addObject:attachSQL];
    }
}

- (BOOL)detachDatabase:(NSString *)alias
{
    __block BOOL result;
    [self inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:[NSString stringWithFormat:@"DETACH DATABASE %s", [alias UTF8String]]];
    }];

    return result;
}

- (void)dealloc
{
    [_database close];
    _database = nil;
}

@end