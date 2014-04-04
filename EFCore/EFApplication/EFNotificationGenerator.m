//
// Created by yizhuolin on 12-9-22.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EFNotificationGenerator.h"
#import "EFFibonacciGenerator.h"
#import "NSFileManager+SystemDirectory.h"

#define INTERVAL_ONEDAY   (24*60*60)

static EFFibonacciGenerator *sFibonacciGenerator;

static NSString *const kNotificationFileName = @"notificationGen.dat";
static NSMutableDictionary *sData;
static dispatch_queue_t    sQueue;

@implementation EFNotificationGenerator
{
    id <EFIntervalGenerator> _intervalGenerator;
    NSTimeInterval           _nextTime;
    NSInteger                _index;
    NSString                 *_serviceName;
}

+ (void)initialize
{
    if (self == [EFNotificationGenerator class]) {
        sFibonacciGenerator = [[EFFibonacciGenerator alloc] init];
        NSString *absolutePath = [[NSFileManager cachesDirectory] stringByAppendingPathComponent:kNotificationFileName];
        sData = [[NSMutableDictionary alloc] initWithContentsOfFile:absolutePath];
        if (sData == nil) {
            sData = [[NSMutableDictionary alloc] init];
        }

        sQueue = dispatch_queue_create("com.aaronyi.EFNotificationGenerator", DISPATCH_QUEUE_CONCURRENT);
    }
}

- (id)initWithServiceName:(NSString *)serviceName
{
    return [self initWithServiceName:serviceName intervalGenerator:sFibonacciGenerator];
}

- (id)initWithServiceName:(NSString *)serviceName intervalGenerator:(id <EFIntervalGenerator>)intervalGenerator
{
    self = [super init];

    if (self) {
        _generatorType     = EFNotificationGeneratorTypeDate;
        _intervalGenerator = intervalGenerator;
        _serviceName       = serviceName;

        __block NSString *data;

        dispatch_sync(sQueue, ^{
            data = sData[serviceName];
        });

        if ([data length]) {
            NSArray *array = [data componentsSeparatedByString:@","];
            _nextTime = [[array objectAtIndex:0] doubleValue];
            _index    = [[array objectAtIndex:1] integerValue];
        }
    }

    return self;
}

- (BOOL)shouldShowNotification
{
    if (_index == 0) {
        [self calculateNext];
    }

    if (_nextTime == -1) {
        return NO;
    }

    return _generatorType == EFNotificationGeneratorTypeTimes ?
           _nextTime <= [_dataSource currentValueForService:_serviceName] : _nextTime <= [[NSDate date] timeIntervalSince1970];
}

- (void)reset
{
    _index = 0;

    [self calculateNext];
}

- (void)calculateNext
{
    NSInteger interval = [_intervalGenerator getInterval:_index++];

    if (interval <= -1) {
        _nextTime = -1;
    } else if (_generatorType == EFNotificationGeneratorTypeTimes) {
        _nextTime = [_dataSource currentValueForService:_serviceName] + interval;
    } else {
        _nextTime = [[NSDate date] timeIntervalSince1970] + interval * INTERVAL_ONEDAY;
    }

    __weak EFNotificationGenerator *weakSelf = self;

    dispatch_barrier_sync(sQueue, ^{
        [weakSelf __save];
    });

#ifdef DEBUG
    if (_generatorType == EFNotificationGeneratorTypeTimes) {
        NSLog(@"next time for service %@ is %f", _serviceName, _nextTime);
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSLog(@"next date for service %@ is %@", _serviceName, [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_nextTime]]);
    }

#endif
}

- (void)__save
{
    sData[_serviceName] = [NSString stringWithFormat:@"%f,%d", _nextTime, _index];
    NSString *absolutePath = [[NSFileManager cachesDirectory] stringByAppendingPathComponent:kNotificationFileName];
    [sData writeToFile:absolutePath atomically:YES];
}

@end