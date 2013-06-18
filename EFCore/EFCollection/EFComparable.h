//
// Created by yizhuolin on 12-8-27.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol EFComparable <NSObject>

@required
- (CFComparisonResult)compareTo:(id)object;

@optional
- (NSString *)keyPathForObserving;

@end