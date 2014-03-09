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
    CSLoginType _loginType;
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
                [CandyShineAPIKit sharedAPIKit].loginType = CSLoginWeibo;
                [CandyShineAPIKit sharedAPIKit].userName = username;
                [CandyShineAPIKit sharedAPIKit].passWord = userid;
                [CandyShineAPIKit sharedAPIKit].email = userid;
                _loginType = CSLoginWeibo;
                if (username != nil) {
                    [self registerRequest];
                }
            } else {
                [MBProgressHUDManager showTextWithTitle:@"授权失败" inView:self.view];
            }
        }];
    });
}

- (IBAction)qqButtonClickHander:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                                          if (accountResponse.responseCode == UMSResponseCodeSuccess) {
                                              NSString *username = [[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQzone] objectForKey:@"username"];
                                              NSString *userid = [[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQzone] objectForKey:@"usid"];
                                              [CandyShineAPIKit sharedAPIKit].loginType = CSLoginQQ;
                                              [CandyShineAPIKit sharedAPIKit].userName = username;
                                              [CandyShineAPIKit sharedAPIKit].passWord = userid;
                                              [CandyShineAPIKit sharedAPIKit].email = userid;
                                              _loginType = CSLoginQQ;
                                              if (username != nil) {
                                                  [self registerRequest];
                                              }
                                          }
                                          else {
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
            [CandyShineAPIKit sharedAPIKit].email = _emailTextField.text;
            [CandyShineAPIKit sharedAPIKit].passWord = _codeTextField.text;
            _loginType = CSLoginDefault;
            [self loginRequest];
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
                [CandyShineAPIKit sharedAPIKit].loginType = CSLoginDefault;
                [CandyShineAPIKit sharedAPIKit].userName = _userName.text;
                [CandyShineAPIKit sharedAPIKit].passWord = _codeTextField.text;
                [CandyShineAPIKit sharedAPIKit].email = _emailTextField.text;
                _loginType = CSLoginDefault;
                [self registerRequest];
            }
        }
    } else {
        [self showUsernameTexgtField];
    }
}

- (IBAction)forgetCodeButtonClickHander:(id)sender {
    
}

- (void)registerRequest {
    [MBProgressHUDManager showIndicatorWithTitle:_loginType == CSLoginDefault ? @"正在注册" : @"正在登陆" inView:[[UIApplication sharedApplication] keyWindow]];
    [[CandyShineAPIKit sharedAPIKit] requestRegisterSuccess:^(NSDictionary *result) {
        CSResponceCode code = [[result objectForKey:@"code"] integerValue];
        [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
        if (code == CSResponceCodeSuccess) {
            [self loginRequest];
        } else {
            if (_loginType == CSLoginDefault) {
                [MBProgressHUDManager showTextWithTitle:@"用户名已存在" inView:self.view];
            } else {
                [self loginRequest];
            }
        }
    } fail:^(NSError *error) {
        [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
        [MBProgressHUDManager showTextWithTitle:_loginType == CSLoginDefault ? @"注册失败" : @"登陆失败" inView:self.view];
    }];
}

- (void)loginRequest {
    [MBProgressHUDManager showIndicatorWithTitle:@"正在登陆" inView:[[UIApplication sharedApplication] keyWindow]];
    [[CandyShineAPIKit sharedAPIKit] requestLogInSuccess:^(NSDictionary *result) {
        CSResponceCode code = [[result objectForKey:@"code"] integerValue];
        [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
        if (code == CSResponceCodeSuccess) {
            [MBProgressHUDManager showTextWithTitle:@"登陆成功" inView:self.view];
            [CSDataManager sharedInstace].userName = [[result objectForKey:@"user_info"] objectForKey:@"custom_name"];
            [CSDataManager sharedInstace].userId = [[result objectForKey:@"user_info"] objectForKey:@"uid"];
            NSString *url = [[result objectForKey:@"user_info"] objectForKey:@"portrait"];
            if (![url isKindOfClass:[NSNull class]]) {
                [CSDataManager sharedInstace].portrait = [NSString stringWithFormat:@"%@%@",kBaseURL,url];
            }
            [CSDataManager sharedInstace].isLogin = YES;
            CSLoginType loginType = [[[result objectForKey:@"user_info"] objectForKey:@"type"] integerValue];
            [CSDataManager sharedInstace].loginType = loginType;
            if ([url isKindOfClass:[NSNull class]] && loginType != CSLoginDefault) {
                NSDictionary *dic = [[[UMSocialDataService defaultDataService] socialData] socialAccount];
                NSString *type = loginType == CSLoginQQ ? UMShareToQzone:UMShareToSina;
                UMSocialAccountEntity *info = [dic objectForKey:type];
                [CSDataManager sharedInstace].portrait = info.iconURL;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.iconURL]];
                    [[CandyShineAPIKit sharedAPIKit] requestModifyPortraitWithImage:data Success:^(NSDictionary *result) {
                        
                    } fail:^(NSError *error) {
                        
                    }];
                });
            }
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kLoginFinishNotification object:nil]];
            [self dismiss];
        } else {
            [MBProgressHUDManager showTextWithTitle:@"用户名或密码错误" inView:self.view];
        }
    } fail:^(NSError *error) {
        [MBProgressHUDManager hideMBProgressInView:[[UIApplication sharedApplication] keyWindow]];
        [MBProgressHUDManager showTextWithTitle:@"登陆失败" inView:self.view];
    }];
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
