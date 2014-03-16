//
//  IntroduceViewController.h
//  CandyShine
//
//  Created by huangfulei on 14-3-15.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "BaseViewController.h"

@protocol IntroduceViewControllerDelegate <NSObject>

- (void)introduceViewDidFinish;

@end

@interface IntroduceViewController : BaseViewController

@property (nonatomic, assign) id <IntroduceViewControllerDelegate> delegate;

@end
