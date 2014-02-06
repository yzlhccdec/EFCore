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
    float    version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version < 7.1 && version >= 7) {
        return [self appStoreURLForApplicationIdentifier:identifier];
    }

    NSString *link  = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", identifier];

    return [NSURL URLWithString:link];
}

@end