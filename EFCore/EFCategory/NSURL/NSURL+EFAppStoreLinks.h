//
// Created by yizhuolin on 14-1-26.
// Copyright 2013 {Company} Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSURL (EFAppStoreLinks)

/**-------------------------------------------------------------------------------------
 @name Mobile App Store Pages
 ---------------------------------------------------------------------------------------
 */

/** Returns the URL to open the mobile app store on the app's page.

 URL construction as described in [QA1629](https://developer.apple.com/library/ios/#qa/qa2008/qa1629.html). Test and found to be opening the app store app directly even without the itms: or itms-apps: scheme. This kind of URL can also be used to forward a link to the app to non-iOS devices.

 @param identifier The application identifier that gets assigned to a new app when you add it to iTunes Connect.
 @return Returns the URL to the direct app store link
 */
+ (NSURL *)appStoreURLForApplicationIdentifier:(NSString *)identifier;


/** Returns the URL to open the mobile app store on the app's review page.

 The reviews page is a sub-page of the normal app landing page you get with appStoreURLforApplicationIdentifier:

 @param identifier The application identifier that gets assigned to a new app when you add it to iTunes Connect.
 @return Returns the URL to the direct app store link
 */
+ (NSURL *)appStoreReviewURLForApplicationIdentifier:(NSString *)identifier;

@end