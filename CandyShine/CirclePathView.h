//
//  CirclePathView.h
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CirclePathView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) DataPattern currentPattern;
@property (nonatomic, assign) int runNumbers;

- (void)storkeCircle;

- (void)refrsh;

@end
