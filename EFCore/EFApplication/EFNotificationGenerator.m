//
// Created by yizhuolin on 12-9-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFNotificationGenerator.h"
#import "EFFibonacciGenerator.h"

#define INTERVAL_ONEDAY   (24*60*60)

static EFFibonacciGenerator *sFibonacciGenerator;

static NSString *const kNotificationGeneratorPrefix = @"notificationGen_";

@interface EFNotificationGenerator () {
    id <EFIntervalGenerator> _intervalGenerator;
    NSTimeInterval _nextDate;
    NSInteger _index;
    NSString *_serviceName;
}

- (void)save;

@end

@implementation  EFNotificationGenerator

+ (void)initialize
{
    sFibonacciGenerator = [[EFFibonacciGenerator alloc] init];
}

- (id)initWithServiceName:(NSString *)serviceName
{
    return [self initWithServiceName:serviceName andIntervalGenerator:sFibonacciGenerator];
}

- (id)initWithServiceName:(NSString *)serviceName andIntervalGenerator:(id <EFIntervalGenerator>)intervalGenerator
{
    self = [super init];

    if (self) {
        _serviceName = [kNotificationGeneratorPrefix stringByAppendingString:serviceName];
        _intervalGenerator = intervalGenerator;

        if (!_dataSource) {
            NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:_serviceName];

            if ([data length]) {
                NSArray *array = [data componentsSeparatedByString: @","];
                _nextDate = [[array objectAtIndex:0] doubleValue];
                _index = [[array objectAtIndex:1] integerValue];
            } else {
                _nextDate = _index = -1;
            }
        } else {
            [_dataSource loadNextDate:&_nextDate AndIndex:&_index ForService:_serviceName];
        }
    }

    return self;
}

- (BOOL)showNotification
{
    if (_nextDate == -1) {
        return YES;
    }

    if (_nextDate == 0) {
        return NO;
    }

    return _nextDate <= [[NSDate date] timeIntervalSince1970];
}

- (void)reset
{
    _nextDate = _index = -1;
    [self save];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_serviceName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)calculateNext
{
    _index++;
    NSTimeInterval interval = [_intervalGenerator getInterval:_index];
    _nextDate = interval == -1 ? 0 : [[NSDate date] timeIntervalSince1970] + interval * INTERVAL_ONEDAY;

    [self save];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    DLog("next date for service %@ is %@", _serviceName, [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_nextDate]])
}

#pragma mark - private

- (void)save
{
    if (!_dataSource) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f,%d", _nextDate, _index] forKey:_serviceName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [_dataSource saveNextDate:_nextDate AndIndex:_index ForService:_serviceName];
    }
}

@end