//
//  BaseNavigationController.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()  <UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    CGFloat _startBackViewX;
    CGPoint _startTouch;
    UIImageView *_lastScreenShotView;
    UIView *_blackMask;
    UIView *_backgroundView;
     NSMutableArray *_screenShotsList;
     BOOL _isMoving;
}


@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!IsIOS7) {
            _screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        }
        _canDragBack = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (IsIOS7) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
//    else {
//        UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//        shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//        [self.view addSubview:shadowImageView];
//        
//        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
//                                                                                    action:@selector(paningGestureReceive:)];
//        [self.view addGestureRecognizer:recognizer];
//
//    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (IsIOS7) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
//    else {
//        [_screenShotsList addObject:[self capture]];
//    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (!IsIOS7) {
        [_screenShotsList removeLastObject];
    }
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/800);
    
    _blackMask.alpha = alpha;
    
    CGFloat aa = abs(_startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;
    
    CGFloat lastScreenShotViewHeight = kkBackViewHeight;
    
    //TODO: FIX self.edgesForExtendedLayout = UIRectEdgeNone  SHOW BUG
    /**
     *  if u use self.edgesForExtendedLayout = UIRectEdgeNone; pls add
     
     if (!iOS7) {
     lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
     }
     *
     */
    
    if (!iOS7) {
        //lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
    }

    [_lastScreenShotView setFrame:CGRectMake(_startBackViewX+y,
                                            0,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];
    
}


- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        _startTouch = touchPoint;
        
        if (!_backgroundView)
        {
            CGRect frame = self.view.frame;
            
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:_backgroundView belowSubview:self.view];
            
            _blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            _blackMask.backgroundColor = [UIColor blackColor];
            [_backgroundView addSubview:_blackMask];
        }
        
        _backgroundView.hidden = NO;
        
        if (_lastScreenShotView) [_lastScreenShotView removeFromSuperview];
        
        
        UIImage *lastScreenShot = [_screenShotsList lastObject];
        
        _lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        _startBackViewX = startX;
        [_lastScreenShotView setFrame:CGRectMake(_startBackViewX,
                                                _lastScreenShotView.frame.origin.y,
                                                _lastScreenShotView.frame.size.height,
                                                _lastScreenShotView.frame.size.width)];
        
        [_backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - _startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                _backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            _backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - _startTouch.x];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

