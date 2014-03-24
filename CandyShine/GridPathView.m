//
//  GridPathView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-21.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "GridPathView.h"
#import "Sport.h"

#define BorderGap      30
#define TextSpaceY     8
#define PathBorderBap  10
#define LineWidth      0.5

@interface GridPathView ()
{
    CAShapeLayer *_path;
    CAShapeLayer *_gogalLine;
}

@end

@implementation GridPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat space = (frame.size.width - 2*BorderGap)/4;
        CGSize size;
        for (int i=0; i< 5; i++) {
            if (i != 2) {
                UILabel *timeLB = [[UILabel alloc] init];
                timeLB.backgroundColor = [UIColor clearColor];
                timeLB.font = [UIFont systemFontOfSize:13];
                timeLB.textColor = [UIColor convertHexColorToUIColor:0xccc7c2];
                timeLB.textAlignment = NSTextAlignmentCenter;
                timeLB.text = [NSString stringWithFormat:@"%dh",i*6];
                size =  [timeLB.text sizeWithFont:timeLB.font];
                timeLB.frame = CGRectMake(0, 0, size.width, size.height);
                timeLB.center =  CGPointMake(BorderGap + space*i, size.height/2);
                [self addSubview:timeLB];
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(BorderGap +space*i, size.height + TextSpaceY, LineWidth, self.height - size.height - TextSpaceY)];
            line.backgroundColor = [UIColor convertHexColorToUIColor:0xe6e1da];
            [self addSubview:line];
        }
        
        _path = [CAShapeLayer layer];
        _path.contents = nil;
        _path.frame = CGRectMake(BorderGap + LineWidth, PathBorderBap + TextSpaceY + size.height, self.width - 2*(BorderGap + LineWidth), self.height - TextSpaceY - 2*PathBorderBap - size.height);
        _path.lineWidth = 1.5;
        //_line.lineDashPattern = @[[NSNumber numberWithFloat:2.0],[NSNumber numberWithFloat:1.0]];
        _path.lineCap = kCALineCapRound;
        _path.fillColor = [[UIColor clearColor] CGColor];
        _path.strokeColor = [[UIColor convertHexColorToUIColor:0xffaa33] CGColor];
        [self.layer addSublayer:_path];
        
        _gogalLine = [CAShapeLayer layer];
        _gogalLine.frame = CGRectMake(0, (PathBorderBap + TextSpaceY + size.height + 30)/2, self.width, 0.5);
        _gogalLine.lineWidth = 0.5;
        _gogalLine.lineDashPattern =  @[[NSNumber numberWithFloat:4.0],[NSNumber numberWithFloat:4.0]];
        _gogalLine.lineCap = kCALineCapButt;
        _gogalLine.strokeColor = [[UIColor convertHexColorToUIColor:0xe6e1da] CGColor];
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:_gogalLine.frame.origin];
        [line addLineToPoint:CGPointMake(_gogalLine.frame.size.width, _gogalLine.frame.origin.y)];
        _gogalLine.path = line.CGPath;
        [self.layer addSublayer:_gogalLine];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)strokeLine {

    if ([_valueArray count] > 0) {
        _path.hidden = NO;

        UIBezierPath *path = [UIBezierPath bezierPath];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        Sport *item = [_valueArray objectAtIndex:0];
        
        NSDate *startDate = [item.date dateByAddingTimeInterval:0];
        NSDate *begain = [DateHelper getDayBegainWith:[DateHelper getDayWithDate:item.date]];
        while ([startDate timeIntervalSinceDate:begain] >= 300) {
            [tempArray addObject:[NSNumber numberWithInteger:0]];
            startDate = [startDate dateByAddingTimeInterval:-300];
        }
        
        NSInteger temp = 0;
        for (Sport *item in _valueArray) {
            temp += [item.value integerValue];
            [array addObject:[NSNumber numberWithInteger:temp]];
        }
        //NSInteger maxValue = [[array lastObject] integerValue];
        
        for (int i = 0; i < tempArray.count; i++) {
            [array insertObject:[tempArray objectAtIndex:i] atIndex:i];
        }
        
        NSInteger minValue = [[array objectAtIndex:0] integerValue];
        
        CGFloat height = _path.frame.size.height;
        CGFloat width = _path.frame.size.width;
        NSInteger gogal = [CSDataManager sharedInstace].userGogal;
        [path moveToPoint:CGPointMake(0,height - minValue)];
        NSInteger time = [DateHelper getTimeIntervalWithDate:[CSDataManager sharedInstace].readDataDate];
        CGFloat hasDataWidth = _isToday ? (time/(24*60*60*1.0))*width : width;
        CGFloat step = hasDataWidth/(array.count*1.0);
        for (int i = 1; i < [array count]; i++) {
            NSInteger value = [[array objectAtIndex:i] integerValue];
            if (value <= gogal) {
                [path addLineToPoint:CGPointMake(i*step,height - (value/(gogal*1.0))*(height - 30))];
            } else {
                CGFloat index;
                if (value - gogal > 9900) {
                    index = 1.0;
                } else {
                    index = (value - gogal)/9900.0f;
                }
                [path addLineToPoint:CGPointMake(i*step,height - ((height - 30) + index*30))];
            }
        }
//        UIBezierPath *smoothing = [path smoothedPathWithGranularity:1 minY:self.height - TextSpaceY - 2*PathBorderBap - 110 maxY:self.height - TextSpaceY - 2*PathBorderBap - 0];
        
            _path.path = path.CGPath;
        
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.duration = 1.0;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.fromValue = [NSNumber numberWithFloat:0.0];
//        animation.toValue = [NSNumber numberWithFloat:1.0];
//        [_path addAnimation:animation forKey:nil];
        
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
