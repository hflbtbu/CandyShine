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

#define UmengAppkey         @"5289a8fb56240be0de2a15d8"

#define kAESKey             @"wearable_devices"

#define kIsFirstLaunch      @"IsFirstLaunch"
#define kFirstLaunchDate    @"FirstLaunchDate"

#endif
