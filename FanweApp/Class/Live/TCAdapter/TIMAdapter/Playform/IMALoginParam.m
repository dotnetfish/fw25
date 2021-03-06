//
//  IMALoginParam.m
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "IMALoginParam.h"

@implementation TIMLoginParam (PlatformConfig)

- (IMAPlatformConfig *)config
{
    return nil;
}
- (void)saveToLocal
{
    // do nothing
}

@end

@implementation IMALoginParam

#define kDictUserKey                @"kDictUserKey"
#define kDaysInSeconds(x)           (x * 24 * 60 * 60)  // 过期时间

- (instancetype)init
{
    if (self = [super init])
    {
        
        NSString *sdkAppIdStr = TXYSdkAppId;
        self.appidAt3rd = sdkAppIdStr;
//        self.sdkAppId = [sdkAppIdStr intValue];
//        self.accountType = TXYSdkAccountType;
        self.config = [[IMAPlatformConfig alloc] init];
    }
    return self;
}

+ (instancetype)loadFromLocal
{
    NSString *userloginKey = [[NSUserDefaults standardUserDefaults] objectForKey:kIMALoginParamUserKey];
    if (userloginKey)
    {
        // 说明本地有存储
        IMALoginParam *param = [IMALoginParam loadInfo:[IMALoginParam class] withKey:userloginKey];
        return param;
    }
    else
    {
        return [[IMALoginParam alloc] init];
    }
}

- (void)saveToLocal
{
    if (self.tokenTime == 0)
    {
        self.tokenTime = [[NSDate date] timeIntervalSince1970];
    }
    
    if ([self isVailed])
    {
        NSString *useridKey = [NSString stringWithFormat:@"%@_LoginParam", self.identifier];
        [[NSUserDefaults standardUserDefaults] setObject:useridKey forKey:kIMALoginParamUserKey];
        [IMALoginParam saveInfo:self withKey:useridKey];
    }
}

- (BOOL)isExpired
{
    time_t curTime = [[NSDate date] timeIntervalSince1970];
    BOOL expired = curTime - self.tokenTime > kDaysInSeconds(30);
    return expired;
}

- (BOOL)isVailed
{
    return ![NSString isEmpty:self.identifier] && ![NSString isEmpty:self.userSig] && ![self isExpired];
}

@end
