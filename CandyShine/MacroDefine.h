//
//  MacroDefine.h
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#ifndef CandyShine_MacroDefine_h
#define CandyShine_MacroDefine_h

#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
#define Is_4Inch    ([UIScreen mainScreen].bounds.size.height == 568 ? YES :NO)


//AppKey

#define UmengAppkey         @"5211818556240bc9ee01db2f"

#define kAESKey             @"wearable_devices"

#define kIsFirstLaunch      @"IsFirstLaunch"
#define kFirstLaunchDate    @"FirstLaunchDate"
#define kUserInfoAndState   @"UserInfoAndState"

#define kAddFriendFinishNotification        @"AddFriendFinifishNotification"
#define kLoginFinishNotification            @"LoginFinishNotification"
#define kLogoutFinishNotification           @"LogoutFinishNotification"
#define kReadDeviceDataFinishNotification   @"ReadDeviceDataFinishNotification"
#define kSetGogalFinishNotification         @"SetGogalFinishNotification"


#define kUserIsMale         @"UserSex"
#define kUserHeight         @"UserHeight"
#define kUserWeight         @"UserWeight"
#define kUserGogal          @"UserGogal"
#define kUserBirthDay       @"UserBirthDay"

#define kReadDateDate       @"ReadDateDate"

#define kUserDeviceID       @"UserDeviceID"

#define kAutoSync           @"kAutoSync"


#define kSleepDeepValue     10
#define kSleepMaxValue      50
#define kSleep

#define kSleepAwakeLineHeight       20
#define kSLeepDeepLineHeight        120
#define kSleepAwakeLineHeightCap    10
#define kSLeepDeepLineHeight        30

#endif
