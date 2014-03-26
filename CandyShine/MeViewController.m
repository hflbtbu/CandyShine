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
#import "FriendListViewController.h"
#import "WaterWarmManager.h"

#import "CandyShineAPIKit.h"

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate,PickerViewDelegate>
{
    IBOutlet UITableView *_tableView;
    CSDataManager *_dataManager;
    WaterWarmManager *_waterWarmManager;
    NSIndexPath *_selectedIndexPath;
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
        self.navigationItem.title = @"我";
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
    
    _tableView.backgroundColor = [UIColor convertHexColorToUIColor:0xf2f0ed];
    _tableView.backgroundView = nil;    _dataManager = [CSDataManager sharedInstace];
    
    _waterWarmManager = [WaterWarmManager shared];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 4;
    } else  {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 82;
    }
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 2) {
//        return 60;
//    }
//    return 0;
//}


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
            _thumberImage = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 11, 60, 60) image:nil];
            [cell.contentView addSubview:_thumberImage];
        }
        _thumberImage.imageView.image = [UIImage imageNamed:@"portrait_holder"];
        if (_dataManager.isLogin && _dataManager.portrait.length != 0) {
            [_thumberImage.imageView setImageWithURL:[NSURL URLWithString:_dataManager.portrait]];
        }
        NSString *username = _dataManager.isLogin ? _dataManager.userName : @"游客";
        NSString *placeString = IsIOS7 ? @"              " : @"               ";
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",placeString,username];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:newsCellIdentifer];
            UISwitch *news = [[UISwitch alloc] init];
            news.on = YES;
            cell.accessoryView = news;
        }
        cell.textLabel.text = @"资讯提醒";
        cell.imageView.image = [UIImage imageNamed:@"me_news"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"好友列表";
                cell.imageView.image = [UIImage imageNamed:@"me_friendlist"];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"运动目标";
                cell.imageView.image = [UIImage imageNamed:@"me_aportgogal"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"睡眠时间";
                cell.imageView.image = [UIImage imageNamed:@"me_sleeptime"];
                cell.detailTextLabel.text = [self getTimeStringWith:_waterWarmManager.sleepTime];
            } else  if (indexPath.row == 2) {
                cell.textLabel.text = @"喝水设置";
                cell.detailTextLabel.text = _waterWarmManager.isOpenWarm ? @"已打开" : @"已关闭";
                cell.imageView.image = [UIImage imageNamed:@"me_watertime"];;\
            }
        } else {
            cell.textLabel.text = @"意见反馈";
            cell.imageView.image = [UIImage imageNamed:@"me_feedbace"];
        }
    }
    cell.textLabel.textColor = kContentNormalColor;
    cell.textLabel.font = kContentFont3;
    cell.detailTextLabel.textColor = kContentNormalShallowColorA;
    cell.detailTextLabel.font = kContentFont3;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        MeSetViewController *meSet = [[MeSetViewController alloc] initWithNibName:@"MeSetViewController" bundle:nil];
        meSet.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:meSet animated:YES];
    } else if (indexPath.section == 1) {
        if (_dataManager.isLogin) {
            FriendListViewController *friendList = [[FriendListViewController alloc] initWithNibName:@"FriendListViewController" bundle:nil];
            friendList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:friendList animated:YES];
        } else {
            [MBProgressHUDManager showTextWithTitle:@"请先登录" inView:self.view];
        }
    } else if (indexPath.section == 2) {
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
    NSInteger hour = [[dic objectForKey:@"kPickerHuor"] integerValue];
    NSInteger minute = [[dic objectForKey:@"kPickerMinute"] integerValue];
    
    if ([CSDataManager sharedInstace].isConneting) {
        [self setSleepTimeWithHour:hour minute:minute];
    } else {
        if (![CSDataManager sharedInstace].isDongingConnect) {
            [MBProgressHUDManager showIndicatorWithTitle:@"正在连接设备" inView:self.view];
            [[CSDataManager sharedInstace] connectDeviceWithBlock:^(CSConnectState state) {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                if (state == CSConnectfound) {
                    [self setSleepTimeWithHour:hour minute:minute];
                } else if (state == CSConnectUnfound) {
                    [MBProgressHUDManager showTextWithTitle:@"未发现设备" inView:[[UIApplication sharedApplication] keyWindow]];
                }
            }];
        }
    }
}

- (void)setSleepTimeWithHour:(NSInteger)hour minute:(NSInteger)minute {
    [_dataManager setSleepTimeWithHour:hour andMin:minute block:^{
        NSInteger timeInterval = hour*3600 + minute*60;
        _waterWarmManager.sleepTime = timeInterval;
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
        cell.detailTextLabel.text = [self getTimeStringWith:timeInterval];
        [MBProgressHUDManager showTextWithTitle:@"设置睡眠时间成功" inView:self.view];
    }];

}

- (NSString *)getTimeStringWith:(NSInteger)timeInterval {
    NSInteger minute = timeInterval/60%60;
    NSInteger hour = (timeInterval/60 - minute)/60;
    return  [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidFinishHander) name:kLoginFinishNotification object:nil];
}

- (void)loginDidFinishHander {
    [CSDataManager sharedInstace].isLogin = YES;
    [_tableView reloadData];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
