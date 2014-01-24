//
//  MoveCircleView.h
//  CandyShine
//
//  Created by huangfulei on 14-1-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveCircleView : UIView

@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign) DataPattern currentPattern;
@property (nonatomic, assign) int runNumbers;

- (void)updateWithProgress:(CGFloat)progress;

- (void)refrsh;


@end
