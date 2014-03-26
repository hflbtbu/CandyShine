//
//  MoveCircleView.m
//  CandyShine
//
//  Created by huangfulei on 14-1-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MoveCircleView.h"
#import "DetailTextView.h"

#define CircleWidth 20
#define CirclePathCircleRadius 100


@interface MoveCircleView ()
{
    CGFloat _currentProgress;
    NSTimer *_timer;
    
    UILabel *_runNumberLB;
    UILabel *_gogalLB;
    UIView *_lineView;
    DetailTextView *_calorieLB;
    UILabel *_freshLB;
    
    BOOL _isSyn;
    BOOL _isAdd;
}

@end

@implementation MoveCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isSyn = NO;
        _isAdd = YES;
        _isToday = NO;
        _currentPattern = DataPatternDay;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addTextLabel];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapGestureRecognizer:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)addTextLabel {
    CGSize size;
    
    _gogalLB = [[UILabel alloc] init];
    _gogalLB.textAlignment = NSTextAlignmentCenter;
    _gogalLB.backgroundColor = [UIColor clearColor];
    _gogalLB.font = [UIFont systemFontOfSize:15];
    _gogalLB.textColor = [UIColor convertHexColorToUIColor:0x333333];
    _gogalLB.text = @"12";
    size = [_gogalLB.text sizeWithFont:_gogalLB.font];
    _gogalLB.frame = CGRectMake(0, self.height/2 - 10 - size.height, self.width, size.height);
    [self addSubview:_gogalLB];
    
    _runNumberLB = [[UILabel alloc] init];
    _runNumberLB.textAlignment = NSTextAlignmentCenter;
    _runNumberLB.backgroundColor = [UIColor clearColor];
    _runNumberLB.text = @"12";
    _runNumberLB.font = [UIFont systemFontOfSize:38];
    _runNumberLB.textColor = [UIColor convertHexColorToUIColor:0xfeaa00];
    size = [_runNumberLB.text sizeWithFont:_runNumberLB.font];
    _runNumberLB.frame = CGRectMake(0, _gogalLB.y  - size.height, self.width, size.height);
    [self addSubview:_runNumberLB];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 160)/2, (self.height - 1)/2, 160, 0.5)];
    _lineView.backgroundColor = [UIColor convertHexColorToUIColor:0xe5e4e1];
    [self addSubview:_lineView];
    
    _calorieLB = [[DetailTextView alloc] init];
    _calorieLB.backgroundColor = [UIColor clearColor];
    [_calorieLB setText:@"已消耗 25克 脂肪" WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0x333333]];
    [_calorieLB setKeyWordTextArray:@[@"25克"] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0xff7f00]];
    size = [@"已消耗 25克 脂肪" sizeWithFont:[UIFont systemFontOfSize:15]];
    _calorieLB.frame = CGRectMake((self.width - size.width)/2, self.height/2 + 10, self.width, size.height);
    [self addSubview:_calorieLB];
    
    _freshLB = [[UILabel alloc] init];
    _freshLB.textAlignment = NSTextAlignmentCenter;
    _freshLB.backgroundColor = [UIColor clearColor];
    _freshLB.text = @"点击更新数据";
    _freshLB.font = [UIFont systemFontOfSize:12];
    _freshLB.textColor = [UIColor convertHexColorToUIColor:0xccc8c2];
    size = [_freshLB.text sizeWithFont:_freshLB.font];
    _freshLB.frame = CGRectMake(0, _calorieLB.y + _calorieLB.height + 20, self.width, size.height);
    [self addSubview:_freshLB];
}

- (void)updateWithProgress:(CGFloat)progress {
    _progress = progress;
    _isAdd = _progress >= _currentProgress ? YES:NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(repeate) userInfo:nil repeats:YES];
}

- (void)setProgress:(CGFloat)progress {
    _currentProgress = progress;
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)repeate {
    [self setNeedsDisplay];
    
    _currentProgress += _isAdd ? 0.02 : -0.02;
    
    if ((_currentProgress >= _progress && _isAdd) || (_currentProgress < _progress && !_isAdd)) {
        [_timer invalidate];
        _timer = nil;
        _currentProgress = _progress;
    }
}

- (void)receiveTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
//    if (_isSyn) {
//        _isSyn = NO;
//        _runNumberLB.hidden = YES;
//        _calorieLB.hidden = YES;
//        _gogalLB.text = @"同步";
//    } else {
//        _isSyn = YES;
//        _runNumberLB.hidden = NO;
//        _calorieLB.hidden = NO;
//        _gogalLB.text = @"目标 : 9900卡路里";
//        
//    }
    if (![CSDataManager sharedInstace].isReading) {
        if ([CSDataManager sharedInstace].isConneting) {
            [self synchronizationDeviceData];
        } else {
            if (![CSDataManager sharedInstace].isDongingConnect) {
                [MBProgressHUDManager showIndicatorWithTitle:@"正在连接设备" inView:self];
                [[CSDataManager sharedInstace] connectDeviceWithBlock:^(CSConnectState state) {
                    [MBProgressHUDManager hideMBProgressInView:self];
                    if (state == CSConnectfound) {
                        [self synchronizationDeviceData];
                    } else {
                        [MBProgressHUDManager showTextWithTitle:@"未发现设备" inView:[[UIApplication sharedApplication] keyWindow]];
                    }
                }];
            }
        }
    }
}

- (void)synchronizationDeviceData {
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUDManager showIndicatorWithTitle:@"正在同步" inView:self];
    [[CSDataManager sharedInstace] synchronizationDeviceDataWithBlock:^{
        [MBProgressHUDManager hideMBProgressInView:self];
    }];
}

- (void)refrsh {
    if (_currentPattern == DataPatternDay) {
        NSInteger gogal = [CSDataManager sharedInstace].userGogal;
        NSString *finishPersent;
        CGFloat percent = _runNumbers/(gogal*1.0)*100;
        finishPersent = [NSString stringWithFormat:@"%d",_runNumbers];
        _runNumberLB.text = finishPersent;
        //[self updateWithProgress:_runNumbers/(gogal*1.0)];
        self.progress = _runNumbers/(gogal*1.0);
        _gogalLB.text = [NSString stringWithFormat:@"目标 : %d步",gogal];
        NSInteger calory = _runNumbers/30000.0 * 130;
        [_calorieLB setText:[NSString stringWithFormat:@"已消耗 %d克 脂肪",calory] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0x333333]];
        [_calorieLB setKeyWordTextArray:@[[NSString stringWithFormat:@"%d克",calory]] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0xff7f00]];
        CGSize size = [[NSString stringWithFormat:@"已消耗 %d克 脂肪",calory] sizeWithFont:[UIFont systemFontOfSize:15]];
        _calorieLB.frame = CGRectMake((self.width - size.width)/2, self.height/2 + 10, self.width, size.height);
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
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2 - CircleWidth/2, 0, M_PI *2, 0);
    
    //Set the stroke color to black
    [[UIColor convertHexColorToUIColor:0xf2f0ed]setStroke];
    
    //Define line width and cap
    CGContextSetLineWidth(ctx, CircleWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //** Draw the circle (using a clipped gradient) **/
    
    
    /** Create THE MASK Image **/
    UIGraphicsBeginImageContext(self.size);
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    CGContextAddArc(imageCtx, self.frame.size.width/2  , self.frame.size.height/2, self.frame.size.width/2 - CircleWidth/2, M_PI_2,  M_PI_2 - M_PI*2*_currentProgress, 1);
    [[UIColor blackColor]set];
    //define the path
    CGContextSetLineWidth(imageCtx, CircleWidth);
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
    CGFloat components[8] = {
        1.0, 0xaa/255.0, 0.0, 1.0,     // Start color - Blue
        1.0, 0x6a/255.0, 0.0, 1.0};   // End color - Violet
    
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
