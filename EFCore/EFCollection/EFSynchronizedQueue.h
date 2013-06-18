//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EFQueue.h"
#import "EFQueueExtended.h"


@interface EFSynchronizedQueue : NSObject <EFQueueExtended>

- (id)initWithQueue:(id <EFQueue>)queue;

@end