//
//  CandyShineAPIKit.h
//  CandyShine
//
//  Created by huangfulei on 14-2-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CandyShineAPIKit : NSObject

+ (CandyShineAPIKit *)sharedAPIKit;

- (void)registerUser;

@end
