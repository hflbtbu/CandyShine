//
//  LogInViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-17.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "LogInViewController.h"
#import "PickerView.h"

@interface LogInViewController () <UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>
{
    IBOutlet UITableView *_tableView;
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
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1){
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 44;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"CellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
//            NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:0];
//            NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
//            UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];
//            
//            //设置分享内容，和回调对象
//            [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
//            snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            if ([UMSocialAccountManager isOauthWithPlatform:UMShareToQzone]) {
                [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                    //NSLog(@"SinaWeibo's user name is %@",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]);
                }];

            }
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                          {
                                              
                                                  [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                                                      //NSLog(@"SinaWeibo's user name is %@",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]);
                                                  }];
                                          });
            
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
