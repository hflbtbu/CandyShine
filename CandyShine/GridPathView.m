//
//  GridPathView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-21.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "GridPathView.h"

#define BorderGap      30
#define TextSpaceY     20
#define PathBorderBap  10
#define LineWidth      1

@interface GridPathView ()
{
    CAShapeLayer *_path;
}

@end

@implementation GridPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat space = (frame.size.width - 2*BorderGap)/8;
        for (int i=0; i< 9; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LineWidth, frame.size.height - TextSpaceY)];
            line.backgroundColor = [UIColor grayColor];
            line.center = CGPointMake(BorderGap + space*i, (frame.size.height - TextSpaceY)/2);
            [self addSubview:line];
            
            UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, space, TextSpaceY)];
            timeLB.backgroundColor =[UIColor clearColor];
            timeLB.font = [UIFont systemFontOfSize:12];
            timeLB.textColor = [UIColor grayColor];
            timeLB.textAlignment = UITextAlignmentCenter;
            timeLB.text = [NSString stringWithFormat:@"%dh",i*3];
            timeLB.center =  CGPointMake(BorderGap + space*i, frame.size.height - TextSpaceY/2);
            [self addSubview:timeLB];
            
            _path = [CAShapeLayer layer];
            _path.contents = nil;
            _path.frame = CGRectMake(BorderGap + LineWidth, PathBorderBap, self.width - 2*(BorderGap + LineWidth), self.height - TextSpaceY - 2*PathBorderBap);
            _path.lineWidth = 2.0;
            //_line.lineDashPattern = @[[NSNumber numberWithFloat:2.0],[NSNumber numberWithFloat:1.0]];
            _path.lineCap = kCALineCapRound;
            _path.fillColor = [[UIColor clearColor] CGColor];
            _path.strokeColor = [[UIColor greenColor] CGColor];
            [self.layer addSublayer:_path];

            
           NSArray *values = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:30],[NSNumber numberWithInt:40],[NSNumber numberWithInt:60],[NSNumber numberWithInt:00],[NSNumber numberWithInt:50],[NSNumber numberWithInt:40],[NSNumber numberWithInt:30],[NSNumber numberWithInt:30],[NSNumber numberWithInt:60],[NSNumber numberWithInt:40],[NSNumber numberWithInt:10],[NSNumber numberWithInt:30],[NSNumber numberWithInt:40],[NSNumber numberWithInt:60],[NSNumber numberWithInt:80]];
            
        }
    }
    return self;
}

- (void)strokeLine {

    if ([_valueArray count] > 0) {
        _path.hidden = NO;

        UIBezierPath *path = [UIBezierPath bezierPath];
        int value = [[_valueArray objectAtIndex:0] intValue];
        [path moveToPoint:CGPointMake(0, self.height - TextSpaceY - 2*PathBorderBap - value)];
        for (int i = 1; i < [_valueArray count]; i++) {
            int value = [[_valueArray objectAtIndex:i] intValue];
            [path addLineToPoint:CGPointMake(BorderGap + LineWidth + 12*i, self.height - TextSpaceY - 2*PathBorderBap - value)];
        }
        UIBezierPath *smoothing = [path smoothedPathWithGranularity:40 minY:self.height - TextSpaceY - 2*PathBorderBap - 80 maxY:self.height - TextSpaceY - 2*PathBorderBap - 0];
        
            _path.path = smoothing.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 1.0;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        //[_path addAnimation:animation forKey:nil];
        
    } else {
        _path.hidden = YES;
    }
}

- (void)refresh {
    [self strokeLine];
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
