//
//  GAUtils.m
//  GoogleAnalyticsSDK
//
//  Created by Kfir Schindelhaim on 12/12/13.
//  Copyright (c) 2013 Kfir Schindelhaim. All rights reserved.
//

#import "GAUtils.h"
#include <sys/sysctl.h>

@implementation GAUtils

// -------------------------------------------------------------------------------
#pragma mark - Helper
// -------------------------------------------------------------------------------
+(NSString*)UUIDString
{
    CFUUIDRef  uuidObj = CFUUIDCreate(nil);
    NSString  *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

+ (NSString*)userUUID
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        NSString* userUUID = [standardUserDefaults stringForKey:@"UserUUID"];
        if ([userUUID length] == 0)
        { // generate one for the first time
            userUUID = [self UUIDString];
            [standardUserDefaults setObject:userUUID forKey:@"UserUUID"];
            [standardUserDefaults synchronize];
        }
        return userUUID;
    }
    return [self UUIDString];
}

+ (NSString*)userLanguage
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    return language;
}

+ (NSString*)appVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *shortVersionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@.%@",shortVersionNum,versionNum];
}

+ (NSString*)machine
{
    size_t size;
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.model", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+(NSString*)operatingSystem
{
    NSString * operatingSystemVersionString = [[NSProcessInfo processInfo] operatingSystemVersionString];
    return operatingSystemVersionString;
    
}

@end
