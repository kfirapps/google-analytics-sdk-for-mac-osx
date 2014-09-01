//
//  GARequest.m
//  GoogleAnalyticsSDK
//
//  Created by Kfir Schindelhaim on 12/12/13.
//  Copyright (c) 2013 Kfir Schindelhaim. All rights reserved.
//

#import "GARequest.h"
#import "GAUtils.h"
#import "GATracker.h"

#define GOOGLE_ANALITYCS_URL     @"http://www.google-analytics.com/collect"  //Not Secured
#define GOOGLE_ANALITYCS_URL_SSL @"https://ssl.google-analytics.com/collect" //Secured

@interface GARequest ()

@property (strong) NSString *cid;
@property (strong) NSString *language;
@property (strong) NSString *appVersion;
@property (strong) NSString *type;
@property (strong) NSString *customDimension;
@property (strong) NSString *customDimension2;
@property (strong) NSString *view;
@property (strong) NSString *eventCategory;
@property (strong) NSString *eventAction;
@property (strong) NSString *eventLabel;
@property (strong) NSNumber *eventValue;

@end

@implementation GARequest

- (void)commonInit
{
    _cid = [GAUtils userUUID];
    _language = [GAUtils userLanguage];
    _appVersion = [GAUtils appVersion];
    _customDimension = [GAUtils operatingSystem];
    _customDimension2 = [GAUtils machine];
}

- (id) initViewRequest:(NSString *)view
{
    self = [super init];
    if (self)
    {
        /*
         v=1             // Version.
         &tid=UA-XXXX-Y  // Tracking ID / Web property / Property ID.
         &cid=555        // Anonymous Client ID.
         
         &t=appview      // Appview hit type.
         &an=funTimes    // App name.
         &av=4.2.0       // App version.
         
         &cd=Home        // Screen name / content description.
         */
        
        [self commonInit];
        _type = @"appview";
        _requestType = GARequest_View;
        _view = view;
    }
    return self;
}

- (id) initEventRequestWithCategory:(NSString *)category action:(NSString *)action label:(NSString*)label value:(NSNumber*)value
{
    self = [super init];
    if (self)
    {
        /*
         v=1             // Version.
         &tid=UA-XXXX-Y  // Tracking ID / Web property / Property ID.
         &cid=555        // Anonymous Client ID.
         
         &t=event        // Event hit type
         &ec=video       // Event Category. Required.
         &ea=play        // Event Action. Required.
         &el=holiday     // Event label.
         &ev=300         // Event value.
         */

        
        [self commonInit];
        _type = @"event";
        _requestType = GARequest_Event;
        _eventCategory = (category ?: nil);
        _eventAction = (action ?: nil);
        _eventLabel = (label ?: nil);
        _eventValue = (value ?: nil);
    }
    return self;
}

// -------------------------------------------------------------------------------
#pragma mark - Post Strings
// -------------------------------------------------------------------------------
- (NSString*)postUrl
{
    if (self.tracker.useSSL)
    {
        return [GOOGLE_ANALITYCS_URL_SSL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        return [GOOGLE_ANALITYCS_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

- (NSString*)postBody
{
    if (self.requestType == GARequest_Event)
    {
        return [self eventPostString];
    }
    else if (self.requestType == GARequest_View)
    {
        return [self viewPostString];
    }
    return nil;
}

- (NSString*)viewPostString
{
    NSString *postString = [NSString stringWithFormat:@"v=1&tid=%@&cid=%@&t=%@&an=%@&av=%@&cd=%@&ul=%@&cd1=%@&cd2=%@", self.tracker.accountCode, self.cid,
                            self.type, self.tracker.appName, self.appVersion, self.view, self.language, self.customDimension, self.customDimension2];
    return postString;
}

- (NSString*)eventPostString
{
    NSString *postString = [NSString stringWithFormat:@"v=1&tid=%@&cid=%@&t=%@&an=%@&av=%@&ul=%@&ec=%@&ea=%@&cd1=%@&cd2=%@",
                            self.tracker.accountCode, self.cid, self.type, self.tracker.appName, self.appVersion, self.language,
                            self.eventCategory, self.eventAction, self.customDimension, self.customDimension2];
    
    if (self.eventLabel)
    {
        postString = [postString stringByAppendingFormat:@"&el=%@", self.eventLabel];
    }
    
    if (self.eventValue)
    {
        postString = [postString stringByAppendingFormat:@"&ev=%@", self.eventValue];
    }
    
    return postString;
}

// -------------------------------------------------------------------------------
#pragma mark - Send Request
// -------------------------------------------------------------------------------
- (NSURLRequest*)postRequest
{
    NSURL *url = [NSURL URLWithString:self.postUrl];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [self.postBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPShouldUsePipelining:YES];
    
    return theRequest;
}

- (void)sendRequest
{
    NSError *error = nil;
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:self.postRequest returningResponse:&response error:&error];
    if (error)
    {
        if (self.tracker.debug)
        {
            NSLog(@"Did fail with error %@" , [error localizedDescription]);
        }
    }
    else
    {
        if (self.tracker.debug)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            long statusCode = [httpResponse statusCode];
            NSLog(@"Status code was %lu, response: %@", statusCode, httpResponse);
        }
    }
}

@end
