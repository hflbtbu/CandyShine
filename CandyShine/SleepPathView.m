//
//  SleepPathView.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepPathView.h"
#import "SleepShow.h"

#define SleepPathViewLeftCap 48
#define SleepPathViewRightCap 17
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
    if (_sleepDataArray.count >= 4) {
        CGContextRef context = UIGraphicsGetCurrentContext();

        
        //CGContextMoveToPoint(context, SleepPathViewLeftCap, self.height - SleepPathViewBottomCap);
        
        CGFloat width = self.width - SleepPathViewLeftCap - SleepPathViewRightCap;
        CGFloat height = self.height - SleepPathViewBottomCap;
        
        CGFloat granularity = width/_sleepDataArray.count;
        //    for (NSInteger i = 0; i<width; i+=1) {
        //        CGFloat valueY = sin(i/width * M_PI*4)*PathHeight + PathHeight+2;
        //        CGContextAddLineToPoint(context, i + SleepPathViewLeftCap, valueY);
        //    }
        //
        
        CGFloat minY = 0;
        CGFloat maxY = 0;
        
        CGFloat offset = height*0.125;
        
        for (SleepShow *item in _sleepDataArray) {
            NSInteger value = [item.value integerValue];
            minY = value < minY ? value : minY;
            maxY = value > maxY ? value : maxY;
            NSLog(@"%d",value);
        }

        if (maxY <= 0) {
            maxY = 1;
        }
        CGFloat maxIndex = height*0.75/maxY;
        CGFloat temp = minY;
        minY =  self.height -SleepPathViewBottomCap - offset - maxY*maxIndex ;
        maxY = self.height -SleepPathViewBottomCap - offset - temp*maxIndex ;
        
        
        CGContextMoveToPoint(context,  SleepPathViewLeftCap, self.height - SleepPathViewBottomCap);
        SleepShow *item = [_sleepDataArray objectAtIndex:0];
        CGContextAddLineToPoint(context, SleepPathViewLeftCap, self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
        
        
        
        CGFloat step = width/(CGFloat)(_sleepDataArray.count - 1);
        
        for (NSUInteger index = 1; index < _sleepDataArray.count - 2; index++)
        {
            item = [_sleepDataArray objectAtIndex:index - 1];
            CGPoint p0 = CGPointMake((index - 1)*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset- [item.value integerValue]*maxIndex);
            item  = [_sleepDataArray objectAtIndex:index];
            CGPoint p1 = CGPointMake(index*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset- [item.value integerValue]*maxIndex);
            item  = [_sleepDataArray objectAtIndex:index + 1];
            CGPoint p2 =CGPointMake((index + 1)*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset- [item.value integerValue]*maxIndex);
            item  = [_sleepDataArray objectAtIndex:index + 2];
            CGPoint p3 = CGPointMake((index + 2)*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset- [item.value integerValue]*maxIndex);
            
            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < granularity; i++)
            {
                float t = (float) i * (1.0f / granularity);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                
                if(pi.y > maxY){
                    
                    pi.y = maxY;
                }
                else if(pi.y < minY){
                    
                    pi.y = minY;
                }
                
                if(pi.x > p0.x){
                    
                    CGContextAddLineToPoint(context, pi.x, pi.y);
                }
            }
            
            // Now add p2
            CGContextAddLineToPoint(context, p2.x, p2.y);
        }
        
        // finish by adding the last point
        item = [_sleepDataArray lastObject];
        CGPoint point = CGPointMake((_sleepDataArray.count - 1)*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset- [item.value integerValue]*maxIndex);
        CGContextAddLineToPoint(context, point.x, point.y);
        //
        
        CGContextAddLineToPoint(context, self.width - SleepPathViewRightCap, self.height - SleepPathViewBottomCap);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [[UIColor convertHexColorToUIColor:0xe5e1da alpha:1.0] CGColor]);
        CGContextFillPath(context);
        
        item = [_sleepDataArray objectAtIndex:0];
        CGContextMoveToPoint(context,  SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
        for (NSUInteger index = 1; index < _sleepDataArray.count - 2; index++)
        {
            item = [_sleepDataArray objectAtIndex:index - 1];
            CGPoint p0 = CGPointMake((index - 1)*step + SleepPathViewLeftCap, self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
            item  = [_sleepDataArray objectAtIndex:index];
            CGPoint p1 = CGPointMake(index*step + SleepPathViewLeftCap, self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
            item  = [_sleepDataArray objectAtIndex:index + 1];
            CGPoint p2 =CGPointMake((index + 1)*step + SleepPathViewLeftCap,   self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
            item  = [_sleepDataArray objectAtIndex:index + 2];
            CGPoint p3 = CGPointMake((index + 2)*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
            
            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < granularity; i++)
            {
                float t = (float) i * (1.0f / granularity);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                
                if(pi.y > maxY){
                    
                    pi.y = maxY;
                }
                else if(pi.y < minY){
                    
                    pi.y = minY;
                }
                
                if(pi.x > p0.x){
                    
                    CGContextAddLineToPoint(context, pi.x, pi.y);
                }
            }
            
            // Now add p2
            CGContextAddLineToPoint(context, p2.x, p2.y);
        }
        
        // finish by adding the last point
        item = [_sleepDataArray lastObject];
        point = CGPointMake((_sleepDataArray.count - 1)*step + SleepPathViewLeftCap,  self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex);
        CGContextAddLineToPoint(context, point.x, point.y);
        CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor] CGColor]);
        CGContextSetLineWidth(context, 1);
        CGContextStrokePath(context);
        
        
        item = [_sleepDataArray objectAtIndex:_sleepPosition];
        CGContextAddArc(context, _sleepPosition*step + SleepPathViewLeftCap, self.height -SleepPathViewBottomCap - offset-[item.value integerValue]*maxIndex, 3.5, 0, M_2_PI, YES);
        CGContextSetFillColorWithColor(context, [[UIColor orangeColor] CGColor]);
        CGContextEOFillPath(context);
        //
        //    CGContextAddArc(context, point2.x, point2.y, 3.5, 0, M_2_PI, YES);
        //    CGContextSetFillColorWithColor(context, [[UIColor orangeColor] CGColor]);
        //    CGContextEOFillPath(context);
        
        
        
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
}


- (void)refresh {
    //Sleep *item = [_sleepDataArray objectAtIndex:0];
    [self setNeedsDisplay];
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
