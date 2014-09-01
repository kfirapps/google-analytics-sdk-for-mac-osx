//
//  AppDelegate.m
//  GoogleAnalyticsForMac
//
//  Created by Kfir Schindelhaim on 8/26/14.
//  Copyright (c) 2014 Kfir Schindelhaim. All rights reserved.
//

#import "AppDelegate.h"
#import "AnalyticsManager.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [AnalyticsManager sharedManager].trackingId = @"UA-XXXXXXXX-4";
    [AnalyticsManager sharedManager].appName = @"YourAppName";
    [AnalyticsManager sharedManager].debug = YES;
    
    [[AnalyticsManager sharedManager] trackView:@"Main View"];
}

- (IBAction)trackEvent:(id)sender
{
    [[AnalyticsManager sharedManager] trackEvent:@"Track Event"];
}

- (IBAction)trackEventWithParameters:(id)sender
{
    [[AnalyticsManager sharedManager] trackEvent:@"Track Event" action:@"Action" label:@"Label" value:@1];
}

@end
