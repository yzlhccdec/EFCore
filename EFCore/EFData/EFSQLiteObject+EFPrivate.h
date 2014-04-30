//
//  EFSQLiteObject+EFPrivate.h
//  EFCore
//
//  Created by yizhuolin on 14-3-16.
//  Copyright (c) 2014年 yizhuolin. All rights reserved.
//

#import <EFCore/EFCore.h>

@interface EFSQLiteObject (EEFPrivate)

@property(nonatomic, readonly) NSArray *changedFields;
@property(nonatomic, readonly) NSArray *primaryKeys;

- (NSDictionary *)fieldProperties;

@end
