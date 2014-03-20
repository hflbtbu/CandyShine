//
//  WaterWarmViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-19.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "WaterWarmViewController.h"
#import "WaterAnimationView.h"
#import "WaterWarmManager.h"
#import "WaterWarmSetViewController.h"

@interface WaterWarmViewController ()
{
    WaterWarmManager *_waterWarmManager;
}
@end

@implementation WaterWarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IsIOS7) {
            UIImage *image = [UIImage imageNamed:@"tabBarIcon_water"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *imageSelected = [UIImage imageNamed:@"tabBarIcon_water_selected"];
            imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"喝水" image:image selectedImage:imageSelected];
        } else {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarIcon_water_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarIcon_water"]];
            self.tabBarItem.title = @"喝水";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _waterWarmManager = [WaterWarmManager shared];
    //[self initNavigationItem];
    self.view.backgroundColor = [UIColor convertHexColorToUIColor:0xf2f0ed];
}

- (void)refresh {
    for (UIView *view in [self.view subviews]) {
        if (view.tag >= kAnimationViewTag) {
            [view removeFromSuperview];
        }
    }
    if (_waterWarmManager.isOpenWarm) {
        NSArray *times = [_waterWarmManager getWarmTimes];
        NSArray *states = [_waterWarmManager warmTimeStateArray];
        int number = MIN(times.count, states.count);
        
        self.navigationItem.title = [NSString stringWithFormat:@"%d杯水",number];
        
        int count = 0;
        for (int i = 0; i <number/3 + 1; i++) {
            for (int j = 0; j < 3; j++) {
                if (count < number) {
                    WaterAnimationView *animation = [[WaterAnimationView alloc] initWithFrame:CGRectMake(16 + j*100, 15 + i*118, 88, 108)];
                    animation.tag = count + kAnimationViewTag;
                    [animation setWarmTime:[[times objectAtIndex:count] integerValue] WarmState:[[states objectAtIndex:count] integerValue]];
                    [self.view addSubview:animation];
                    count++;
                } else {
                    break;
                }
            }
        }

    } else {
        [MBProgressHUDManager showTextWithTitle:@"赶紧去添加喝水提醒吧😜" inView:self.view];
    }
}


- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(go)];
}

- (void)go {
    WaterWarmSetViewController *waterWarmSet =[[WaterWarmSetViewController alloc] initWithNibName:@"WaterWarmSetViewController" bundle:nil];
    waterWarmSet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:waterWarmSet animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
