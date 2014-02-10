//
//  EditWarmTimeViewController.h
//  CandyShine
//
//  Created by huangfulei on 14-2-10.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol EditWarmTimeViewControllerDelegate <NSObject>

- (void)didSelectedWarmTime:(NSInteger)timeInterval;

@end

@interface EditWarmTimeViewController : BaseViewController

@property (nonatomic, assign) id<EditWarmTimeViewControllerDelegate> delegate;

@end
