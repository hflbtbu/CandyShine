//
//  MBProgressHUDManager.m
//  CandyShine
//
//  Created by huangfulei on 14-2-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MBProgressHUDManager.h"

@implementation MBProgressHUDManager

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view {
    CGFloat offsetY = [view isKindOfClass:[UIWindow class]] ? 110:50;
    [MBProgressHUDManager hideMBProgressInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.yOffset = -view.height/2 + offsetY;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

+ (void)showIndicatorWithTitle:(NSString *)title inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideMBProgressInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
