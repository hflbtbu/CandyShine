//
//  WaterAnimationView.h
//  CandyShine
//
//  Created by huangfulei on 14-2-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kAnimationViewTag 9999

#import <UIKit/UIKit.h>

@interface WaterAnimationView : UIView

- (void)setWarmTime:(NSInteger)warmTime WarmState:(WaterWarmState)warmState;

@end
