//
//  CirclePathView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CirclePathView.h"

#define CirclePathTextGap 30
#define CirclePathCircleRadius 100

@interface CirclePathView ()
{
    CAShapeLayer *_path;
    CAShapeLayer *_leftPath;
    
    UILabel *_runNumberLB;
    UILabel *_gogalLB;
    UILabel *_calorieLB;
    
    BOOL _isSyn;
}

@end

@implementation CirclePathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isSyn = NO;
        _currentPattern = DataPatternDay;
        
        _leftPath = [CAShapeLayer layer];
        _leftPath.frame = self.layer.bounds;
        _leftPath.lineWidth = 10.0;
        _leftPath.lineCap = kCALineCapButt;
        _leftPath.fillColor = [[UIColor clearColor] CGColor];
        _leftPath.strokeColor = [[UIColor grayColor] CGColor];
        [self.layer addSublayer:_leftPath];

        _path = [CAShapeLayer layer];
        _path.frame = self.layer.bounds;
        _path.lineWidth = 10.0;
        _path.lineCap = kCALineCapButt;
        _path.fillColor = [[UIColor clearColor] CGColor];
        _path.strokeColor = [[UIColor greenColor] CGColor];
        [self.layer addSublayer:_path];
        
        [self addTextLabel];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)storkeCircle {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.width/2, self.height/2 - CirclePathCircleRadius)];
    [path addArcWithCenter:CGPointMake(self.width/2, self.height/2) radius:CirclePathCircleRadius startAngle:-M_PI_2 endAngle:M_PI*2*_progress -M_PI_2 clockwise:YES];
    _path.path = path.CGPath;
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(self.width/2, self.height/2 - CirclePathCircleRadius)];
    [leftPath addArcWithCenter:CGPointMake(self.width/2, self.height/2) radius:CirclePathCircleRadius startAngle:-M_PI_2 endAngle:M_PI*2 -M_PI_2 clockwise:YES];
    _leftPath.path = leftPath.CGPath;
    
    
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.duration = 0.6;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.fromValue = [NSNumber numberWithFloat:0.0];
//    animation.toValue = [NSNumber numberWithFloat:1.0];
//    [_path addAnimation:animation forKey:nil];
}


- (void)addTextLabel {
    _gogalLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CirclePathCircleRadius, 10)];
    _gogalLB.textAlignment = NSTextAlignmentCenter;
    _gogalLB.backgroundColor = [UIColor clearColor];
    _gogalLB.center = CGPointMake(self.width/2, self.height/2);
    _gogalLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:_gogalLB];
    
    _runNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CirclePathCircleRadius, 10)];
    _runNumberLB.textAlignment = NSTextAlignmentCenter;
    _runNumberLB.backgroundColor = [UIColor clearColor];
    _runNumberLB.center = CGPointMake(self.width/2, self.height/2 - CirclePathTextGap);
    _runNumberLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:_runNumberLB];
    
    _calorieLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CirclePathCircleRadius, 10)];
    _calorieLB.textAlignment = NSTextAlignmentCenter;
    _calorieLB.backgroundColor = [UIColor clearColor];
    _calorieLB.center = CGPointMake(self.width/2, self.height/2 + CirclePathTextGap);
    _calorieLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:_calorieLB];
}

- (void)receiveTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    if (_isSyn) {
        _isSyn = NO;
        _runNumberLB.hidden = YES;
        _calorieLB.hidden = YES;
        _gogalLB.text = @"同步";
    } else {
        _isSyn = YES;
        _runNumberLB.hidden = NO;
        _calorieLB.hidden = NO;
        _gogalLB.text = @"600步";
        
    }
}

- (void)refrsh {
    [self storkeCircle];
    
    if (_currentPattern == DataPatternDay) {
        _runNumberLB.text = [NSString stringWithFormat:@"%d步",_runNumbers];
        _gogalLB.text = [NSString stringWithFormat:@"%d步",600];
        _calorieLB.text = [NSString stringWithFormat:@"%d卡路里",700];
    } else {
        
    }
}

@end
