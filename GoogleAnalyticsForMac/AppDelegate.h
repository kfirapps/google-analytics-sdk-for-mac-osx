//
//  AppDelegate.h
//  GoogleAnalyticsForMac
//
//  Created by Kfir Schindelhaim on 8/26/14.
//  Copyright (c) 2014 Kfir Schindelhaim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)trackEvent:(id)sender;
- (IBAction)trackEventWithParameters:(id)sender;

@end
