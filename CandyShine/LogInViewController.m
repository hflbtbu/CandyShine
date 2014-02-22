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
    
    IBOutlet UIButton *_loginButton;
    IBOutlet UIButton *_registerButton;
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
    UIImage *logninImage = [[UIImage imageNamed:@"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
    [_loginButton setBackgroundImage:logninImage forState:UIControlStateNormal];
    UIImage *registerImage = [[UIImage imageNamed:@"button_bg_regist"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
    [_registerButton setBackgroundImage:registerImage forState:UIControlStateNormal];
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
