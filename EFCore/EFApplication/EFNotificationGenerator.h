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
* @return interval(day/times) or -1(forever)
*/
- (NSInteger)getInterval:(NSInteger)index;

@end

@protocol EFNotificationGeneratorDataSource

@required
- (NSUInteger)currentValueForService:(NSString *)serviceName;

@end

typedef NS_ENUM(char, EFNotificationGeneratorType) {
    EFNotificationGeneratorTypeTimes,           // depends on use times
    EFNotificationGeneratorTypeDate,            // depends on date
};

@interface EFNotificationGenerator : NSObject {
}

@property (nonatomic, weak) id<EFNotificationGeneratorDataSource> dataSource;
@property (nonatomic, assign) EFNotificationGeneratorType generatorType;
/**
* @param serviceName name used for distinguishing modules
* @param type type is only used for the first time after this instance initialized or reset
*/
- (id)initWithServiceName:(NSString *)serviceName;

- (id)initWithServiceName:(NSString *)serviceName intervalGenerator:(id <EFIntervalGenerator>)intervalGenerator;

- (BOOL)shouldShowNotification;

- (void)reset;

- (void)calculateNext;


@end