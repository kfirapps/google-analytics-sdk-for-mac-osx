//
//  AnalyticsManager.m
//  ooVooSdk
//
//  Created by Kfir Schindelhaim on 12/8/13.
//
//

#import "AnalyticsManager.h"
#import "GATracker.h"
#import "GAUtils.h"

@interface AnalyticsManager ()

@property (strong, nonatomic) GATracker *tracker;

@end

@implementation AnalyticsManager

+ (AnalyticsManager*)sharedManager
{
    static AnalyticsManager* analyticsManager = nil ;
    static dispatch_once_t done = 0;
    
    dispatch_once(&done,^{
        analyticsManager = [[AnalyticsManager alloc] init];
    });
    
    return analyticsManager;
}

- (GATracker*)tracker
{
    if (!_tracker)
    {
        NSAssert(self.trackingId, @"Please set your \"trackingId\" first");
        NSAssert(self.appName, @"Please set your \"appName\" first");
        
        _tracker = [[GATracker alloc] initWithAccountCode:self.trackingId andAppName:self.appName];
        _tracker.useSSL = YES;
        _tracker.debug = self.debug;
    }
    return _tracker;
}

// -------------------------------------------------------------------------------
#pragma mark - Reprot Methods
// -------------------------------------------------------------------------------
- (void)trackView:(NSString*)view
{
    if (self.debug)
        LOG(@"trackView: %@",view);
    
    [self.tracker sendView:view];
}

- (void)trackEvent:(NSString*)category
{
    NSString *action = [GAUtils machine];
    NSString *label = [GAUtils operatingSystem];
    
    if (self.debug)
        LOG(@"trackEvent: %@ %@ %@", action, category, label);
    
    [self trackEvent:category action:action label:label value:nil];
}

- (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label value:(NSNumber*)value
{
    if (self.debug)
        LOG(@"trackEvent: %@ %@ %@ %@", action, category, label, value);
    
    [self.tracker sendEventWithCategory:category action:action label:label value:value];
}

@end
