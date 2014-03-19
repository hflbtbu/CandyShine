//
//  CSIndicatorView.m
//  CandyShine
//
//  Created by huangfulei on 14-3-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CSIndicatorView.h"

@interface CSIndicatorView()
{
    NSTimer *animateTimer;
    
    NSMutableArray *sviews;
}

@end


@implementation CSIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        sviews = [NSMutableArray array];
        _numOfObjects = 15;
        for (int i=0; i<_numOfObjects; ++i) {//row
            UIView *sview = [[UIView alloc] init];
            sview.tag = i;
            sview.layer.cornerRadius = 5;
            [sviews addObject:sview];
            [self addSubview:sview];
            
        }
        self.objectSize = CGSizeMake(10, 10);
        self.backgroundColor = [UIColor clearColor];
        
        animateTimer = nil;
        _color = [UIColor orangeColor];
        CAShapeLayer *circleLine = [CAShapeLayer layer];
        circleLine.frame  = CGRectMake(0, 0,self.frame.size.width,  self.frame.size.height);
        circleLine.lineWidth = 2;
        circleLine.strokeColor = [[UIColor orangeColor] CGColor];
        circleLine.fillColor = [[UIColor clearColor] CGColor];
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:MIN(self.frame.size.width/2,  self.frame.size.height/2) - 17 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        circleLine.path = [circlePath CGPath];
        [self.layer addSublayer:circleLine];
        
    }
    return self;
}

- (void)awakeFromNib {
    sviews = [NSMutableArray array];
    _numOfObjects = 15;
    for (int i=0; i<_numOfObjects; ++i) {//row
        UIView *sview = [[UIView alloc] init];
        sview.tag = i;
        sview.layer.cornerRadius = 5;
        [sviews addObject:sview];
        [self addSubview:sview];
        
    }
    self.objectSize = CGSizeMake(10, 10);
    self.backgroundColor = [UIColor clearColor];
    
    animateTimer = nil;
    _color = [UIColor orangeColor];
    CAShapeLayer *circleLine = [CAShapeLayer layer];
    circleLine.frame  = CGRectMake(0, 0,self.frame.size.width,  self.frame.size.height);
    circleLine.lineWidth = 2;
    circleLine.strokeColor = [[UIColor orangeColor] CGColor];
    circleLine.fillColor = [[UIColor clearColor] CGColor];
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:MIN(self.frame.size.width/2,  self.frame.size.height/2) - 17 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    circleLine.path = [circlePath CGPath];
    [self.layer addSublayer:circleLine];
}

-(void)setNumOfObjects:(NSUInteger)numOfObjects1
{
    _numOfObjects = numOfObjects1;
    [sviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [sviews removeAllObjects];
    for (int i=0; i<_numOfObjects; ++i) {//row
        UIView *sview = [[UIView alloc] init];
        sview.tag = i;
        [sviews addObject:sview];
        [self addSubview:sview];
        
    }
    
    self.objectSize = _objectSize;
    
}

-(void)setObjectSize:(CGSize)objectSize1
{
    _objectSize = objectSize1;
    float r = MIN(self.frame.size.width, self.frame.size.height)/2;
    float wh = MAX(_objectSize.width, _objectSize.height);
    
    for (int i=0; i<sviews.count; ++i) {
        UIView *subview = sviews[i];
        subview.frame = CGRectMake(0, 0, _objectSize.width, _objectSize.height);
        subview.center = [self pointWithDistance:(r-wh/2) Angel:M_PI*2/_numOfObjects * i];
        
    }
}
-(CGPoint)pointWithDistance:(float)r  Angel:(float)angel
{
    CGPoint c = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    float dy = r*sin(angel);
    float dx = r*cos(angel);
    
    return CGPointMake(c.x+dx, c.y+dy);
}

-(void)startAnimating
{
    if (animateTimer==nil) {
        animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5/(_numOfObjects/2.) target:self selector:@selector(next) userInfo:nil repeats:YES];
    }
    self.hidden = NO;
}

-(void)stopAnimating
{
    [animateTimer invalidate];
    animateTimer = nil;
    self.hidden = YES;
}

-(void)next
{
    for (int i=0; i<sviews.count; ++i) {
        UIView *subview = sviews[i];
        subview.tag = subview.tag-1;
        if (subview.tag<0) {
            subview.tag = _numOfObjects-1;
        }
        
        float alpha = (subview.tag + 1)/((float)_numOfObjects);
        if (alpha<0) {
            alpha = 0;
        }
        subview.alpha = alpha;
        subview.backgroundColor = _color;
    }
    
}

@end
