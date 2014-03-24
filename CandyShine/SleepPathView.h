//
//  SleepPathView.h
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SleepPathView : UIView

@property (nonatomic, retain) NSArray *sleepDataArray;

@property (nonatomic, assign) NSInteger sleepPosition;

- (void)refresh;

@end
