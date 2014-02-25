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
    
    IBOutlet RegistMHTextField *_userName;
    
    IBOutlet UIButton *_loginButton;
    IBOutlet UIButton *_registerButton;
    IBOutlet UIButton *_forgerPassword;
    
    BOOL _isOpen;
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
    //[_codeTextField setRequired:YES];
    UIImage *logninImage = [[UIImage imageNamed:@"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
    [_loginButton setBackgroundImage:logninImage forState:UIControlStateNormal];
    UIImage *registerImage = [[UIImage imageNamed:@"button_bg_regist"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
    [_registerButton setBackgroundImage:registerImage forState:UIControlStateNormal];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.y = -204;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.y = 0;
    }];
}

- (IBAction)weiboButtonClickHander:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
    {
        [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
            if (accountResponse.responseCode == UMSResponseCodeSuccess) {
                NSString *username = [[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"];
                NSString *userid = [[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"usid"];
                [MBProgressHUDManager showIndicatorWithTitle:@"正在登陆" inView:[[UIApplication sharedApplication] keyWindow]];
                [[CandyShineAPIKit sharedAPIKit] requestRegisterWithUserName:userid passWord:username type:CSLoginDefault success:^(NSDictionary *result) {
                    [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
                    [MBProgressHUDManager showTextWithTitle:@"登陆成功" inView:self.view];
                    [CSDataManager sharedInstace].isLogin = YES;
                } fail:^(NSError *error) {
                    [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
                    [MBProgressHUDManager showTextWithTitle:@"登陆失败" inView:self.view];
                }];
                
            } else {
                [MBProgressHUDManager showTextWithTitle:@"授权失败" inView:self.view];
            }
        }];
    });
}

- (void)showUsernameTexgtField {
    if (_isOpen) {
        UIImage *logninImage = [[UIImage imageNamed:@"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
        [_loginButton setBackgroundImage:logninImage forState:UIControlStateNormal];
        UIImage *registerImage = [[UIImage imageNamed:@"button_bg_regist"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
        [_registerButton setBackgroundImage:registerImage forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            _userName.hidden = YES;
            _loginButton.y = 294;
            _registerButton.y = 294;
            _forgerPassword.y = 373;
        } completion:^(BOOL finished) {
            _isOpen = NO;
            _forgerPassword.hidden = NO;
        }];
    } else {
        UIImage *logninImage = [[UIImage imageNamed:@"button_bg_regist"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
        [_loginButton setBackgroundImage:logninImage forState:UIControlStateNormal];
        UIImage *registerImage = [[UIImage imageNamed:@"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
        [_registerButton setBackgroundImage:registerImage forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            _userName.hidden = NO;
            _loginButton.y = 342;
            _registerButton.y = 342;
            _forgerPassword.y = 421;
        } completion:^(BOOL finished) {
            _isOpen = YES;
            _forgerPassword.hidden = YES;
        }];
    }
}

- (IBAction)loginButtonClickHander:(id)sender {
    if (_isOpen) {
        [self showUsernameTexgtField];
    } else {
        if (![_emailTextField validate]) {
            [MBProgressHUDManager showTextWithTitle:@"请输入正确的邮箱" inView:[[UIApplication sharedApplication] keyWindow]];
        } else {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            [MBProgressHUDManager showIndicatorWithTitle:@"正在登陆" inView:[[UIApplication sharedApplication] keyWindow]];
            [[CandyShineAPIKit sharedAPIKit] requestRegisterWithUserName:_emailTextField.text passWord:_codeTextField.text type:CSLoginDefault success:^(NSDictionary *result) {
                [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
                [MBProgressHUDManager showTextWithTitle:@"登陆成功" inView:self.view];
                [CSDataManager sharedInstace].isLogin = YES;
            } fail:^(NSError *error) {
                [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
                [MBProgressHUDManager showTextWithTitle:@"登陆失败" inView:self.view];
            }];
        }

    }
}

- (IBAction)registerButtonClickHander:(id)sender {
    if (_isOpen) {
        if (![_emailTextField validate]) {
            [MBProgressHUDManager showTextWithTitle:@"请输入正确的邮箱" inView:[[UIApplication sharedApplication] keyWindow]];
        } else {
            if (_codeTextField.text.length == 0) {
                [MBProgressHUDManager showTextWithTitle:@"密码不能为空" inView:self.view];
            } else if (_codeTextField.text.length < 6) {
                [MBProgressHUDManager showTextWithTitle:@"密码不能少于6位" inView:self.view];
            } else {
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                [MBProgressHUDManager showIndicatorWithTitle:@"正在注册" inView:[[UIApplication sharedApplication] keyWindow]];
                [[CandyShineAPIKit sharedAPIKit] requestRegisterWithUserName:_emailTextField.text passWord:_codeTextField.text type:CSLoginDefault success:^(NSDictionary *result) {
                    [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
                    [MBProgressHUDManager showTextWithTitle:@"注册成功" inView:self.view];
                    [CSDataManager sharedInstace].isLogin = YES;
                } fail:^(NSError *error) {
                    [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
                    [MBProgressHUDManager showTextWithTitle:@"注册失败" inView:self.view];
                }];
            }
        }
    } else {
        [self showUsernameTexgtField];
    }
}



- (IBAction)forgetCodeButtonClickHander:(id)sender {
}


- (void)initNavigationItem {
    [self.navigationItem  setCustomeLeftBarButtonItem:@"navagation_back" target:self action:@selector(dismiss)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
