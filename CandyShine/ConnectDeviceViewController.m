//
//  ConnectDeviceViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-3-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "ConnectDeviceViewController.h"
#import "CSIndicatorView.h"

@interface ConnectDeviceViewController ()
{
    IBOutlet UILabel *_connectStateLB;
    IBOutlet UILabel *_connectTipLB;
    IBOutlet UILabel *_connectIndicatorLB;
    
    NSTimer *_timer;
    BOOL _isScaningDevice;
}
@end

@implementation ConnectDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _connectStateLB.text = @"连接设备";
    _connectTipLB.text = @"连接前请打开蓝牙哦";
    _connectIndicatorLB.text = @"将卡米放置此处";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHander)];
    [_indicatorView addGestureRecognizer:tapGestureRecognizer];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self scanningDevice];
}


- (void)tapGestureRecognizerHander {
    if (!_isScaningDevice) {
        [self scanningDevice];
    }
}


-(void)scanningDevice
{
    _isScaningDevice = YES;
    _connectIndicatorLB.text = @"将卡米放置此处";
    [_indicatorView startAnimating];
    [[CSDataManager sharedInstace] connectDeviceWithBlock:^(CSConnectState state) {
        _isScaningDevice = NO;
        [_indicatorView stopAnimating];
        if (state == CSConnectfound) {
            _connectIndicatorLB.text = @"连接成功";
            if ([_delegate respondsToSelector:@selector(connectDeviceViewWithState:)]) {
                [_delegate connectDeviceViewWithState:CSConnectfound];
            }
        } else {
            _connectIndicatorLB.text = @"点击重新连接";
            if ([_delegate respondsToSelector:@selector(connectDeviceViewWithState:)]) {
                [_delegate connectDeviceViewWithState:CSConnectUnfound];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
