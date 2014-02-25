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
    _currentSportGoal = 1000;
    [_scrollNumView setNumber:1000];
}

- (IBAction)addButtonClickHander:(id)sender {
    [_scrollNumView add];
}

- (IBAction)plusButtonClickHander:(id)sender {
    [_scrollNumView plus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
