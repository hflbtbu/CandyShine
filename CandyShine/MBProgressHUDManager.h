//
//  MBProgressHUDManager.h
//  CandyShine
//
//  Created by huangfulei on 14-2-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBProgressHUDManager : NSObject

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view;

+ (void)showIndicatorWithTitle:(NSString *)title inView:(UIView *)view;

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completion;

+ (void)hideMBProgressInView:(UIView *)view;

@end
