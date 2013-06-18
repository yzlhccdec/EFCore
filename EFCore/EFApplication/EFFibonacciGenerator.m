//
// Created by yizhuolin on 12-9-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFFibonacciGenerator.h"

const NSInteger array[] = {1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, -1};

@implementation EFFibonacciGenerator

- (NSInteger)getInterval:(NSInteger)index
{
    return index < 0 || index > 11? -1 : array[index];
}


@end