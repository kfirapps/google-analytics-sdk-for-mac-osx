//
//  GAUtils.h
//  GoogleAnalyticsSDK
//
//  Created by Kfir Schindelhaim on 12/12/13.
//  Copyright (c) 2013 Kfir Schindelhaim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAUtils : NSObject

+ (NSString*)userUUID;
+ (NSString*)userLanguage;
+ (NSString*)appVersion;
+ (NSString*)machine;
+ (NSString*)operatingSystem;

@end
