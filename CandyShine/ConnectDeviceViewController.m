//
//  ConnectDeviceViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-3-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "ConnectDeviceViewController.h"
#import "CSIndicatorView.h"

@interface ConnectDeviceViewController () <Ble4UtilDelegate,Ble4PeripheralDelegate>
{
    IBOutlet UILabel *_connectStateLB;
    IBOutlet UILabel *_connectTipLB;
    IBOutlet UILabel *_connectIndicatorLB;
    IBOutlet CSIndicatorView *_indicatorView;
    
    Ble4Util *_ble4Util;
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
    [_indicatorView startAnimating];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHander)];
    [_indicatorView addGestureRecognizer:tapGestureRecognizer];
    
    //_ble4Util = [Ble4Util shareBleUtilWithTarget:self];
    
    //[self scanningWithTimeout:20];
}

- (void)tapGestureRecognizerHander {
    [_indicatorView stopAnimating];
}

-(void)scanningWithTimeout:(NSInteger)timeout
{
    if([self startConnectionHead])
    {
        [_ble4Util stopScanBle];
        
        [_ble4Util startScanBle];
    }
}

/** 判断手机蓝牙状态 */
-(BOOL)startConnectionHead
{
    NSArray *stateArray = [NSArray arrayWithObjects:@"未发现蓝牙4.0设备"
                           ,@"请重设蓝牙设备"
                           ,@"硬件不支持蓝牙4.0"
                           ,@"app未被授权使用BLE4.0"
                           ,@"请在设置中开启蓝牙功能", nil];
    
    if ([_ble4Util cbCentralManagerState] == CBCentralManagerStatePoweredOn)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)ble4Util:(id)ble4Util didDiscoverPeripheralWithUUID:(NSString *)uuid {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
