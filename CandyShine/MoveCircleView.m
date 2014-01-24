//
//  MoveCircleView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MoveCircleView.h"

#define CirclePathTextGap 30
#define CirclePathCircleRadius 100


@interface MoveCircleView ()
{
    CGFloat _currentProgress;
    NSTimer *_timer;
    
    UILabel *_runNumberLB;
    UILabel *_gogalLB;
    UILabel *_calorieLB;
    
    BOOL _isSyn;
}

@end

@implementation MoveCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isSyn = NO;
        _currentPattern = DataPatternDay;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addTextLabel];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)addTextLabel {
    _gogalLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CirclePathCircleRadius, 10)];
    _gogalLB.textAlignment = NSTextAlignmentCenter;
    _gogalLB.center = CGPointMake(self.width/2, self.height/2);
    _gogalLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:_gogalLB];
    
    _runNumberLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CirclePathCircleRadius, 10)];
    _runNumberLB.textAlignment = NSTextAlignmentCenter;
    _runNumberLB.center = CGPointMake(self.width/2, self.height/2 - CirclePathTextGap);
    _runNumberLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:_runNumberLB];
    
    _calorieLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CirclePathCircleRadius, 10)];
    _calorieLB.textAlignment = NSTextAlignmentCenter;
    _calorieLB.center = CGPointMake(self.width/2, self.height/2 + CirclePathTextGap);
    _calorieLB.font = [UIFont systemFontOfSize:10];
    [self addSubview:_calorieLB];
}

- (void)updateWithProgress:(CGFloat)progress {
    _progress = progress;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(repeate) userInfo:nil repeats:YES];
}

- (void)setProgress:(CGFloat)progress {
    _currentProgress = progress;
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)repeate {
    [self setNeedsDisplay];
    _currentProgress += 0.02;
    if (_currentProgress > _progress) {
        [_timer invalidate];
        _timer = nil;
        _currentProgress = _progress;
    }
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
    
    
    if (_currentPattern == DataPatternDay) {
        _runNumberLB.text = [NSString stringWithFormat:@"%d步",_runNumbers];
        _gogalLB.text = [NSString stringWithFormat:@"%d步",600];
        _calorieLB.text = [NSString stringWithFormat:@"%d卡路里",700];
    } else {
        
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /** Draw the Background **/
    
    //Create the path
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, 80, 0, M_PI *2, 0);
    
    //Set the stroke color to black
    [[UIColor grayColor]setStroke];
    
    //Define line width and cap
    CGContextSetLineWidth(ctx, 17);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //** Draw the circle (using a clipped gradient) **/
    
    
    /** Create THE MASK Image **/
    UIGraphicsBeginImageContext(self.size);
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    CGContextAddArc(imageCtx, self.frame.size.width/2  , self.frame.size.height/2, 80, M_PI_2,  M_PI_2 - M_PI*2*_currentProgress, 1);
    [[UIColor blackColor]set];
    //define the path
    CGContextSetLineWidth(imageCtx, 17);
    CGContextSetLineCap(imageCtx, kCGLineCapRound);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    //save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    /** Clip Context to the mask **/
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    
    /** THE GRADIENT **/
    
    //list of components
    CGFloat components[12] = {
        1.0, 0.6, 1.0, 1.0,     // Start color - Blue
        0.3, 1.0, 1.0, 0.4,1.0, 1.0, 1.0, 1.0 };   // End color - Violet
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    //Gradient direction
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    //Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    CGContextRestoreGState(ctx);
}


@end
