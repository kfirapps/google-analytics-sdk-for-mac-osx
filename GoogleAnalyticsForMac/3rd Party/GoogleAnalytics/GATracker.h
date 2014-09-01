//
//  GATracker.h
//  GoogleAnalyticsSDK
//
//  Created by Kfir Schindelhaim on 12/5/13.
//  Copyright (c) 2013 Kfir Schindelhaim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GATracker : NSObject

@property (strong) NSString *accountCode;
@property (strong) NSString *appName;
@property (assign) BOOL debug;
@property (assign) BOOL useSSL;

- (id)initWithAccountCode:(NSString*)accountCode andAppName:(NSString*)appName;

- (void) sendView:(NSString *)view;
- (void) sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString*)label value:(NSNumber*)value;

@end
