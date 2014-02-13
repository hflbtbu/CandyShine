//
//  SleepPathView.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepPathView.h"

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
    
    CGContextMoveToPoint(context, 10, self.height - 10);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 200, 60);
    CGContextAddLineToPoint(context, 310, 40);
    CGContextAddLineToPoint(context, self.width - 10, self.height - 10);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [[UIColor convertHexColorToUIColor:0x234571 alpha:0.1] CGColor]);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, 10, 10);
    CGContextAddLineToPoint(context, 200, 60);
    CGContextAddLineToPoint(context, 310, 40);
    CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
    CGContextSetLineWidth(context, 1.5);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, 200, 60, 3.5, 0, M_2_PI, YES);
    CGContextSetFillColorWithColor(context, [[UIColor orangeColor] CGColor]);
    CGContextEOFillPath(context);

    
}


@end
