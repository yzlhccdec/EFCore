//
// Created by yizhuolin on 14-1-26.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import "NSURL+EFAppStoreLinks.h"


@implementation NSURL (EFAppStoreLinks)

+ (NSURL *)appStoreURLForApplicationIdentifier:(NSString *)identifier
{
    NSString *link = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?mt=8", identifier];

    return [NSURL URLWithString:link];
}

+ (NSURL *)appStoreReviewURLForApplicationIdentifier:(NSString *)identifier
{
//    if (IOS_VERSION_LESS_THAN(@"7.1") && IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
//        return [self appStoreURLForApplicationIdentifier:identifier];
//    }

    NSString *link  = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", identifier];

    return [NSURL URLWithString:link];
}

@end