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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _waterWarmManager = [WaterWarmManager shared];
    //[self initNavigationItem];
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
        int count = 0;
        for (int i = 0; i <states.count/3 + 1; i++) {
            for (int j = 0; j < 3; j++) {
                if (count < times.count) {
                    WaterAnimationView *animation = [[WaterAnimationView alloc] initWithFrame:CGRectMake(10 + j*90, 10 + i*90, 80, 80)];
                    animation.tag = count + kAnimationViewTag;
                    [animation setWarmTime:[[times objectAtIndex:count] integerValue] WarmState:[[states objectAtIndex:count] integerValue]];
                    [self.view addSubview:animation];
                    count++;
                } else {
                    break;
                }
            }
        }

    }
}


- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(go)];
}

- (void)go {
    WaterWarmSetViewController *waterWarmSet =[[WaterWarmSetViewController alloc] initWithNibName:@"WaterWarmSetViewController" bundle:nil];
    self.navigationController.hidesBottomBarWhenPushed = YES;
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
