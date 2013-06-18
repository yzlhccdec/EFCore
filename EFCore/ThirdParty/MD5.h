//
//  MD5.h
//  FreeApp
//
//  Created by quixote on 11-9-19.
//  Copyright 2011年 178.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (MyExtensions)
- (NSString *) md5;
@end

@interface NSData (MyExtensions)
- (NSString *)md5;
@end

