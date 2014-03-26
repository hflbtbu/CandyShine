//
//  SportSetViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kSportSetStepper 100
#define KSportMin        100
#define KSportMax        9000


#import "SportSetViewController.h"
#import "CWScrollNumView.h"

@interface SportSetViewController ()
{
    IBOutlet UIButton *_addButton;
    IBOutlet UIButton *_plusButton;
    
    IBOutlet CWScrollNumView *_scrollNumView;
    
    IBOutlet UILabel *_methodLB1;
    IBOutlet UILabel *_methodLB2;
    IBOutlet UILabel *_methodLB3;
    
    IBOutlet UIImageView *_bgImageView;
    
    IBOutlet UILabel *_goalLB;

    
    NSInteger _currentSportGoal;
}
@end

@implementation SportSetViewController

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
    self.navigationController.hidesBottomBarWhenPushed = YES;
    _currentSportGoal = [[NSUserDefaults standardUserDefaults] integerForKey:kUserGogal];
    _goalLB.text = [NSString stringWithFormat:@"当前状况: %d步/天",_currentSportGoal];
    [_scrollNumView setNumber:_currentSportGoal];
    UIImage *image  = [[UIImage imageNamed:@"intro_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    _bgImageView.image = image;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_isView && IsIOS7) {
        _addButton.y += 20;
        _plusButton.y += 20;
        _scrollNumView.y += 20;
        _goalLB.y += 20;
    }
}

- (IBAction)addButtonClickHander:(id)sender {
    [_scrollNumView add];
}

- (IBAction)plusButtonClickHander:(id)sender {
    [_scrollNumView plus];
}

- (void)saveUserGogalData {
    if ([CSDataManager sharedInstace].isConneting) {
        [self setSportPlan];
    } else {
        [[CSDataManager sharedInstace] connectDeviceWithBlock:^(CSConnectState state) {
            if (state == CSConnectfound) {
                [self setSportPlan];
            } else {
                [MBProgressHUDManager showTextWithTitle:@"未发现设备" inView:[[UIApplication sharedApplication] keyWindow]];
            }
        }];
    }
}

- (void)setSportPlan {
    [[CSDataManager sharedInstace] setSetSportsPlanWithType:BleSportsPlanTypeSteps andGogal:_scrollNumView.number block:^{
        [[NSUserDefaults standardUserDefaults] setInteger:_scrollNumView.number forKey:kUserGogal];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [CSDataManager sharedInstace].userGogal = _scrollNumView.number;
        [MBProgressHUDManager showTextWithTitle:@"设置运动计划成功" inView:[[UIApplication sharedApplication] keyWindow]];
        _goalLB.text = [NSString stringWithFormat:@"当前状况: %dbu/天",_scrollNumView.number];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSetGogalFinishNotification object:nil];
    }];
}

- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveUserGogalData)];
    
    self.navigationItem.title = @"运动计划";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self saveUserGogalData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
