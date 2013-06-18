//
// Created by yizhuolin on 12-8-22.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "EFQueue.h"
#import "EFComparable.h"
#import "EFQueueExtended.h"

typedef void (^Applier)(id);

@interface EFPriorityQueue : NSObject <EFQueueExtended, NSFastEnumeration> {
}

- (id)initWithArray:(NSArray *)array;

@end