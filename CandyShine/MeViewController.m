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
#import "PickerView.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate,PickerViewDelegate>
{
    IBOutlet UITableView *_tableView;
    
    UIImageView *_thumberImage;
}
@end

@implementation MeViewController

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
    _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thumberCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:thumberCellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _thumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
            _thumberImage.backgroundColor = [UIColor orangeColor];
            _thumberImage.layer.cornerRadius = 30;
            _thumberImage.layer.masksToBounds = YES;
            _thumberImage.image = [UIImage imageNamed:@"IMG_0005.JPG"];
            [cell.contentView addSubview:_thumberImage];
        }
        cell.textLabel.text = @"             CandyWearables";
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newsCellIdentifer];
            UISwitch *news = [[UISwitch alloc] init];
            news.on = YES;
            cell.accessoryView = news;
        }
        cell.textLabel.text = @"资讯提醒";
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
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
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 0, 60, 40)];
        [addFriendButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [addFriendButton setTitleColor:[UIColor convertHexColorToUIColor:0xfeaa00] forState:UIControlStateNormal];
        [addFriendButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        return addFriendButton;
    }
    return nil;
}

- (void)logout {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"退出后不会删除你的任何数据", @"")
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                      destructiveButtonTitle:NSLocalizedString(@"退出登陆", @"")
                                           otherButtonTitles:nil];
    as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){

    };
    [as showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MeSetViewController *meSet = [[MeSetViewController alloc] initWithNibName:@"MeSetViewController" bundle:nil];
            [self.navigationController pushViewController:meSet animated:YES];
        } else if (indexPath.row == 1) {
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SportSetViewController *sportSet = [[SportSetViewController alloc] initWithNibName:@"SportSetViewController" bundle:nil];
            [self.navigationController pushViewController:sportSet animated:YES];
        } else  if (indexPath.row == 1) {
            
            PickerView *pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewTime];
            pickerView.delegate = self;
            [pickerView show];
        } else {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
