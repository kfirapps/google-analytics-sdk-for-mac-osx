//
//  AnalyticsManager.h
//  ooVooSdk
//
//  Created by Kfir Schindelhaim on 12/8/13.
//
//

#import <Foundation/Foundation.h>

@interface AnalyticsManager : NSObject

@property (strong, nonatomic) NSString *trackingId;
@property (strong, nonatomic) NSString *appName;
@property (assign, nonatomic) BOOL debug;

+ (AnalyticsManager*)sharedManager;

- (void)trackView:(NSString*)view;
- (void)trackEvent:(NSString*)category;
- (void)trackEvent:(NSString*)category action:(NSString*)action label:(NSString*)label value:(NSNumber*)value;


@end
