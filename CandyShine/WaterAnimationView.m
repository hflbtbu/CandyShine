//
//  WaterAnimationView.m
//  CandyShine
//
//  Created by huangfulei on 14-2-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "WaterAnimationView.h"
#import "OLImageView.h"
#import "OLImage.h"
#import "WaterWarmManager.h"

@interface WaterAnimationView ()
{
    UILabel *_timeLB;
    OLImageView *_animationImage;
    NSInteger _warmTime;
}

@property (nonatomic, assign)WaterWarmState waterWarmState;

@end

@implementation WaterAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _timeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
        _timeLB.textAlignment = NSTextAlignmentCenter;
        _timeLB.font =  [UIFont systemFontOfSize:15];
        _timeLB.textColor = kContentNormalColor;
        _timeLB.backgroundColor = [UIColor clearColor];
        [self addSubview:_timeLB];
        
        _animationImage = [[OLImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
        [self addSubview:_animationImage];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHander)]];
    }
    return self;
}

- (void)tapGestureRecognizerHander {
    if (_waterWarmState == WaterWarmStateOff) {
        return;
    } else if (_waterWarmState == WaterWarmStateBefore) {
        self.waterWarmState = WaterWarmStateDrink;
        [[WaterWarmManager shared] replaceWarmTimeState:WaterWarmStateAfter AtIndex:self.tag - kAnimationViewTag];
    } else  {
        self.waterWarmState = WaterWarmStateAfter;
    }
}


- (void)setWarmTime:(NSInteger)warmTime WarmState:(WaterWarmState)warmState {
    _warmTime = warmTime;
    NSInteger minute = warmTime/60%60;
    NSInteger hour = (warmTime/60 - minute)/60;
    _timeLB.text =  [NSString stringWithFormat:@"%02d:%02d",hour,minute];
    NSDate *date = [NSDate dateWithTimeInterval:warmTime sinceDate:[DateHelper getDayBegainWith:0]];
    NSComparisonResult result = [date compare:[NSDate date]];
    if (result == NSOrderedAscending) {
        self.waterWarmState = warmState;
    } else {
        self.waterWarmState = WaterWarmStateOff;
    }
    
}


- (void)setWaterWarmState:(WaterWarmState)waterWarmState {
    _waterWarmState = waterWarmState;
    if (_waterWarmState == WaterWarmStateOff) {
        _animationImage.image = [UIImage imageNamed:@"state1"];
    } else if (_waterWarmState == WaterWarmStateBefore){
        _animationImage.isRepeate = YES;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"warm1" ofType:@"gif"];
        _animationImage.image = [OLImage imageWithContentsOfFile:path];
    } else if (_waterWarmState == WaterWarmStateDrink) {
        _animationImage.isRepeate = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"warm2" ofType:@"gif"];
        _animationImage.image = [OLImage imageWithContentsOfFile:path];
    } else {
        _animationImage.isRepeate = NO;
        _animationImage.image = [OLImage imageNamed:@"warm3.gif"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
