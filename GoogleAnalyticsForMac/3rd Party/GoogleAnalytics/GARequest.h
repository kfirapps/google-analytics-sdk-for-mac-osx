//
//  GARequest.h
//  GoogleAnalyticsSDK
//
//  Created by Kfir Schindelhaim on 12/12/13.
//  Copyright (c) 2013 Kfir Schindelhaim. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GARequest_View = 0,
    GARequest_Event
}GARequest_Type;

@class GATracker;

@interface GARequest : NSObject

@property (weak) GATracker *tracker;
@property (assign) GARequest_Type requestType;

- (id) initViewRequest:(NSString *)view;
- (id) initEventRequestWithCategory:(NSString *)category action:(NSString *)action label:(NSString*)label value:(NSNumber*)value;

- (void)sendRequest;

@end
