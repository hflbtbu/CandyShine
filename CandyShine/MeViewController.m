//
//  MeViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "MeViewController.h"
#import "MeSetViewController.h"
#import "SportSetViewController.h"
#import "UMFeedbackViewController.h"
#import "LogInViewController.h"
#import "PickerView.h"
#import "WaterWarmSetViewController.h"
#import "CircleImageView.h"
#import "FriendListViewController.h"

#import "CandyShineAPIKit.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate,PickerViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    CircleImageView *_thumberImage;
}
@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IsIOS7) {
            UIImage *image = [UIImage imageNamed:@"tabBarIcon_me"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *imageSelected = [UIImage imageNamed:@"tabBarIcon_me_selected"];
            imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"我" image:image selectedImage:imageSelected];
        } else {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarIcon_me_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarIcon_me"]];
            self.tabBarItem.title = @"我";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IsIOS7) {
        _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1){
        return 4;
    } else  {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 2) {
//        return 60;
//    }
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 60;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"CellIdentifer";
    static NSString *thumberCellIdentifer = @"CellIdentifer";
    static NSString *newsCellIdentifer = @"CellIdentifer";
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:thumberCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:thumberCellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _thumberImage = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 5, 60, 60) image:@"IMG_0005.JPG"];
            [cell.contentView addSubview:_thumberImage];
        }
        cell.textLabel.text = IsIOS7 ? @"              CandyWearables":@"               CandyWearables";
        cell.textLabel.backgroundColor = [UIColor clearColor];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newsCellIdentifer];
            UISwitch *news = [[UISwitch alloc] init];
            news.on = YES;
            cell.accessoryView = news;
        }
        cell.textLabel.text = @"资讯提醒";
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                cell.textLabel.text = @"好友列表";
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"运动目标";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"睡眠时间";
            } else  if (indexPath.row == 2) {
                cell.textLabel.text = @"喝水设置";
            }
        } else {
            cell.textLabel.text = @"意见反馈";
        }
    }
    cell.textLabel.textColor = kContentNormalColor;
    cell.textLabel.font = kContentFont3;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, self.view.width)];
        bgView.backgroundColor = [UIColor clearColor];
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 160, 44)];
        [logoutButton setTitle: [CSDataManager sharedInstace].isLogin ? @"退出登陆" : @"登陆" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *bgImage = [[UIImage imageNamed:[CSDataManager sharedInstace].isLogin ? @"button_bg_logout" : @"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 4)];
        [logoutButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutButtonClickerHander) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:logoutButton];
        return bgView;
    }
    return nil;
}

- (void)logoutButtonClickerHander {
    if ([[CSDataManager sharedInstace] isLogin]) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"退出后不会删除你的任何数据", @"")
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                          destructiveButtonTitle:NSLocalizedString(@"退出登陆", @"")
                                               otherButtonTitles:nil];
        as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            if (buttonIndex == 0) {
                [CSDataManager sharedInstace].isLogin = NO;
                [_tableView reloadData];
            }
        };
        [as showInView:[UIApplication sharedApplication].keyWindow];

    } else {
        [CSDataManager sharedInstace].isLogin = YES;
        LogInViewController *logInVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        logInVC.hidesBottomBarWhenPushed = YES;
        BaseNavigationController *logIn = [[BaseNavigationController alloc] initWithRootViewController:logInVC];
        [self presentViewController:logIn animated:YES completion:^{
        
                    }];
        //[self.navigationController pushViewController:logInVC animated:YES];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MeSetViewController *meSet = [[MeSetViewController alloc] initWithNibName:@"MeSetViewController" bundle:nil];
            meSet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:meSet animated:YES];
        } else if (indexPath.row == 1) {
            FriendListViewController *friendList = [[FriendListViewController alloc] initWithNibName:@"FriendListViewController" bundle:nil];
            friendList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:friendList animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SportSetViewController *sportSet = [[SportSetViewController alloc] initWithNibName:@"SportSetViewController" bundle:nil];
            sportSet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sportSet animated:YES];
        } else  if (indexPath.row == 1) {
            
            PickerView *pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewTime];
            pickerView.delegate = self;
            [pickerView show];
        } else  if (indexPath.row == 2){
            WaterWarmSetViewController *warm = [[WaterWarmSetViewController alloc] initWithNibName:@"WaterWarmSetViewController" bundle:nil];
            warm.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:warm animated:YES];
        }
    } else {
        [self showNativeFeedbackWithAppkey:UmengAppkey];
    }
    
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.translucent = NO;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)pickerViewDidSelectedWithVlaue:(NSDictionary *)dic {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
