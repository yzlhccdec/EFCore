//
// Created by yizhuolin on 12-10-19.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define FieldName(property) [[@(#property) componentsSeparatedByString: @"."] lastObject]

@interface EFSQLiteObject : NSObject

@property(nonatomic, readonly) NSArray *changedFields;

- (id)initWithFMResultSet:(FMResultSet *)resultSet;
- (id)initWithFMResultSet:(FMResultSet *)resultSet ignoreFieldNotExistWarning:(BOOL) ignore;

- (void)startModification;

- (void)endModification;

+ (NSSet *)excludedFields;

+ (NSArray *)fieldsForPersistence;

+ (NSArray *)primaryKey;

+ (NSString *)tableName;
@end