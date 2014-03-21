//
//  ConnectDeviceViewController.h
//  CandyShine
//
//  Created by huangfulei on 14-3-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "BaseViewController.h"
@class CSIndicatorView;

@protocol ConnectDeviceViewControllerDelegate <NSObject>

- (void) connectDeviceViewWithState:(CSConnectState)state;

@end

@interface ConnectDeviceViewController : BaseViewController

@property (nonatomic, assign) id<ConnectDeviceViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet CSIndicatorView *indicatorView;

-(void)scanningWithTimeout:(NSInteger)timeout;

@end
