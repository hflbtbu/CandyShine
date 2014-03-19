//
//  CSIndicatorView.h
//  CandyShine
//
//  Created by huangfulei on 14-3-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSIndicatorView : UIView

@property (nonatomic,assign) NSUInteger numOfObjects;
@property (nonatomic,assign) CGSize objectSize;
@property (nonatomic,retain) UIColor *color;

-(void)startAnimating;
-(void)stopAnimating;

@end
