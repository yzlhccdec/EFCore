//
// Created by yizhuolin on 12-9-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol EFIntervalGenerator

/**
* get an interval between the occurrence of two notifications
* @param index the index'th element in the interval series
* @return interval(day) or -1(forever)
*/
- (NSInteger)getInterval:(NSInteger)index;

@end

@protocol EFNotificationGeneratorDataSource

- (void)loadNextDate:(NSTimeInterval *)nextDate AndIndex:(NSInteger *)index ForService:(NSString *)serviceName;
- (void)saveNextDate:(NSTimeInterval)nextDate AndIndex:(NSInteger)index ForService:(NSString *)serviceName;

@end

@interface EFNotificationGenerator : NSObject {
}

@property (nonatomic, weak) id<EFNotificationGeneratorDataSource> dataSource;

- (id)initWithServiceName:(NSString *)serviceName;

- (id)initWithServiceName:(NSString *)serviceName andIntervalGenerator:(id <EFIntervalGenerator>)intervalGenerator;

- (BOOL)showNotification;

- (void)reset;

- (void)calculateNext;


@end