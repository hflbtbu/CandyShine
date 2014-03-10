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
    CGFloat offsetY = [view isKindOfClass:[UIWindow class]] ? 94:30;
    [MBProgressHUDManager hideMBProgressInView:view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.yOffset = -view.height/2 + offsetY;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

+ (void)showTextWithTitle:(NSString *)title inView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completion {
    CGFloat offsetY = [view isKindOfClass:[UIWindow class]] ?  94:30;
    [MBProgressHUDManager hideMBProgressInView:view];
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.yOffset = -view.height/2 + offsetY;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES whileExecutingBlock:nil completionBlock:completion];
}

+ (void)showIndicatorWithTitle:(NSString *)title inView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = title;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideMBProgressInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

@end
