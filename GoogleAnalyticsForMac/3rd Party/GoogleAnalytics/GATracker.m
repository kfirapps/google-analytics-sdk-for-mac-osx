//
//  GATracker.m
//  GoogleAnalyticsSDK
//
//  Created by Kfir Schindelhaim on 12/5/13.
//  Copyright (c) 2013 Kfir Schindelhaim. All rights reserved.
//

#import "GATracker.h"
#import "GARequest.h"
#include <sys/sysctl.h>

@interface GATracker()

@property (strong) dispatch_queue_t queue;

@end

@implementation GATracker

-(id)initWithAccountCode:(NSString*)accountCode andAppName:(NSString *)appName
{
    self = [super init];
    if (self)
    {
        _accountCode = accountCode;
        _appName = appName;
        _queue  = dispatch_queue_create("com.kfir.google-analytics", NULL);
    }
    return self;
}

// -------------------------------------------------------------------------------
#pragma mark - Reports
// -------------------------------------------------------------------------------
- (void) sendView:(NSString *)view
{
    GARequest *request = [[GARequest alloc] initViewRequest:view];
    request.tracker = self;
    [self sendRequest:request];
}

- (void) sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString*)label value:(NSNumber*)value
{
    GARequest *request = [[GARequest alloc] initEventRequestWithCategory:category action:action label:label value:value];
    request.tracker = self;
    [self sendRequest:request];
}

// -------------------------------------------------------------------------------
#pragma mark - Send Request
// -------------------------------------------------------------------------------
- (void)sendRequest:(GARequest*)request
{
    dispatch_async(self.queue, ^{
        [request sendRequest];
    });
}

@end
