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

@interface SportSetViewController ()
{
    IBOutlet UIButton *_addButton;
    IBOutlet UIButton *_plusButton;
    
    IBOutlet UIButton *_number1Button;
    IBOutlet UIButton *_number2Button;
    IBOutlet UIButton *_number3Button;
    IBOutlet UIButton *_number4Button;
    
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
    _currentSportGoal = 600;
    [self freshNumberButtonTitle];
}

- (IBAction)addButtonClickHander:(id)sender {
    _currentSportGoal += kSportSetStepper;
    if (_currentSportGoal <= KSportMax) {
        [self freshNumberButtonTitle];
    } else {
        _currentSportGoal -= kSportSetStepper;
    }
}

- (IBAction)plusButtonClickHander:(id)sender {
    _currentSportGoal -= kSportSetStepper;
    if (_currentSportGoal >= KSportMin) {
        [self freshNumberButtonTitle];
    } else {
        _currentSportGoal += kSportSetStepper;
    }
}

- (void)freshNumberButtonTitle {
    NSInteger number1 = _currentSportGoal/1000;
    NSInteger number2 = (_currentSportGoal - number1*1000)/100;
    NSInteger number3 = (_currentSportGoal - number1*1000 - number2*100)/10;
    NSInteger number4 = (_currentSportGoal - number1*1000 - number2*100 - number3*10);
    [_number1Button setTitle:[NSString stringWithFormat:@"%d",number1] forState:UIControlStateNormal];
    [_number2Button setTitle:[NSString stringWithFormat:@"%d",number2] forState:UIControlStateNormal];
    [_number3Button setTitle:[NSString stringWithFormat:@"%d",number3] forState:UIControlStateNormal];
    [_number4Button setTitle:[NSString stringWithFormat:@"%d",number4] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
