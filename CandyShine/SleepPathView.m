//
//  SleepPathView.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepPathView.h"

#define SleepPathViewLeftCap 48
#define SleepPathViewRightCap 28
#define SleepPathViewBottomCap 20
#define PathHeight 45
#define StateTextPathCap 5

@interface SleepPathView ()
{
    IBOutlet UILabel *_sleepStateLB1;
    IBOutlet UILabel *_sleepStateLB2;
    IBOutlet UILabel *_sleepStateLB3;
    
    IBOutlet UILabel *_timeLB1;
    IBOutlet UILabel *_timeLB2;
    IBOutlet UILabel *_timeLB3;
    IBOutlet UILabel *_timeLB4;
    IBOutlet UILabel *_timeLB5;
}
@end

@implementation SleepPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, SleepPathViewLeftCap, self.height - SleepPathViewBottomCap);
    
    CGFloat width = self.width - SleepPathViewLeftCap - SleepPathViewRightCap;
    CGFloat height = self.height - SleepPathViewBottomCap;
    for (NSInteger i = 0; i<width; i+=1) {
        CGFloat valueY = sin(i/width * M_PI*4)*PathHeight + PathHeight+2;
        CGContextAddLineToPoint(context, i + SleepPathViewLeftCap, valueY);
    }
    CGContextAddLineToPoint(context, self.width - SleepPathViewRightCap, self.height - SleepPathViewBottomCap);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor convertHexColorToUIColor:0xe5e1da alpha:1.0] CGColor]);
    CGContextFillPath(context);
    
    CGPoint point1;
    CGPoint point2;
    CGContextMoveToPoint(context, SleepPathViewLeftCap, PathHeight+2);
    for (NSInteger i = 1; i<width; i+=1) {
        CGFloat valueY = sin(i/width * M_PI*4)*PathHeight + PathHeight+2;
        CGContextAddLineToPoint(context, i + SleepPathViewLeftCap, valueY);
        if (i == 40) {
            point1.x = i + SleepPathViewLeftCap;
            point1.y = valueY;
        }
        if (i == 200) {
            point2.x = i + SleepPathViewLeftCap;
            point2.y = valueY;
        }
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
    CGContextSetLineWidth(context, 1.5);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, point1.x, point1.y, 3.5, 0, M_2_PI, YES);
    CGContextSetFillColorWithColor(context, [[UIColor orangeColor] CGColor]);
    CGContextEOFillPath(context);
    
    CGContextAddArc(context, point2.x, point2.y, 3.5, 0, M_2_PI, YES);
    CGContextSetFillColorWithColor(context, [[UIColor orangeColor] CGColor]);
    CGContextEOFillPath(context);
    
    
    
    CGContextSetLineCap(context, kCGLineCapButt);
    CGFloat dash[2] = {7.0,7.0};
    CGContextSetLineDash(context, 0, dash, 2);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);

    CGContextMoveToPoint(context, SleepPathViewLeftCap, height/4);
    CGContextAddLineToPoint(context, self.width - SleepPathViewRightCap, height/4);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, SleepPathViewLeftCap, height*2/4);
    CGContextAddLineToPoint(context, self.width - SleepPathViewRightCap, height*2/4);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, SleepPathViewLeftCap, height*3/4);
    CGContextAddLineToPoint(context, self.width - SleepPathViewRightCap, height*3/4);
    CGContextStrokePath(context);
    
    
    

}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width - SleepPathViewLeftCap - SleepPathViewRightCap;
    CGFloat height = self.height - SleepPathViewBottomCap;
    _sleepStateLB1.center = CGPointMake(SleepPathViewLeftCap - _sleepStateLB1.width/2 - StateTextPathCap, height/4);
    _sleepStateLB2.center = CGPointMake(SleepPathViewLeftCap - _sleepStateLB2.width/2 - StateTextPathCap, height*2/4);
    _sleepStateLB3.center = CGPointMake(SleepPathViewLeftCap - _sleepStateLB3.width/2 - StateTextPathCap, height*3/4);
    
    _timeLB1.center = CGPointMake(SleepPathViewLeftCap, self.height - _timeLB1.height/2);
    _timeLB2.center = CGPointMake(SleepPathViewLeftCap + width/4, self.height - _timeLB2.height/2);
    _timeLB3.center = CGPointMake(SleepPathViewLeftCap + width*2/4, self.height - _timeLB3.height/2);
    _timeLB4.center = CGPointMake(SleepPathViewLeftCap + width*3/4, self.height - _timeLB4.height/2);
    _timeLB5.center = CGPointMake(SleepPathViewLeftCap + width, self.height - _timeLB5.height/2);
}

@end
