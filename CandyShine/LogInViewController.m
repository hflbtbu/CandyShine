//
//  LogInViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-17.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "LogInViewController.h"
#import "PickerView.h"
#import "RegistMHTextField.h"

@interface LogInViewController ()
{
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet RegistMHTextField *_emailTextField;
    
    IBOutlet RegistMHTextField *_codeTextField;
}
@end

@implementation LogInViewController

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
    [_emailTextField setEmailField:YES];
    [_codeTextField setRequired:YES];
}

- (IBAction)loginButtonClickHander:(id)sender {
}

- (IBAction)registerButtonClickHander:(id)sender {
}

- (IBAction)forgetCodeButtonClickHander:(id)sender {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
