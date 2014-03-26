//
//  SleepViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepViewController.h"
#import "SleepCell.h"
#import "FriendCell.h"
#import "Sleep.h"
#import "AddFriendViewController.h"

@interface SleepViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger _currentPage;
    UILabel *_titleLB;
    
    NSArray *_friendArray;
    
    BOOL _isViewShow;
}
@end

@implementation SleepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IsIOS7) {
            UIImage *image = [UIImage imageNamed:@"tabBarIcon_sleep"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *imageSelected = [UIImage imageNamed:@"tabBarIcon_sleep_selected"];
            imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"睡眠" image:image selectedImage:imageSelected];
        } else {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarIcon_sleep_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarIcon_sleep"]];
            self.tabBarItem.title = @"睡眠";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isViewShow = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width) style:UITableViewStylePlain];
    _tableView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [_tableView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _tableView.rowHeight = self.view.frame.size.width;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = self.view.frame.size.width;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.pagingEnabled = YES;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableView == tableView) {
        return 5;
    } else {
        return _friendArray.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"sleepCell";
    static NSString *friendCellIdentifer = @"friendSleepCell";
    if (tableView == _tableView) {
        SleepCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (cell == nil) {
            cell = [UIXib cellWithXib:@"SleepCell" style:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            cell.tableView.delegate = self;
            cell.tableView.dataSource = self;
        }
        
        if (indexPath.row == 4) {
            [cell setCellPosition:CellPositionTop];
        } else if (indexPath.row == 0) {
            [cell setCellPosition:CellPositionBottom];
        } else {
            [cell setCellPosition:CellPositionMiddle];
        }
        
        [cell.friendSleepPkLabel setText:[NSString stringWithFormat:@"今天超过的80%%的用户"] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0x787878]];
        [cell.friendSleepPkLabel setKeyWordTextArray:@[[NSString stringWithFormat:@"80%%"]] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0xffaa33]];
        
        cell.sleepDataArray = [[CSDataManager sharedInstace] fetchSleepItemsByDay: 4 - indexPath.row];
        cell.day =  4 - indexPath.row;
        [cell refresh];
        
        return cell;
    } else {
        
        if (indexPath.row == _friendArray.count) {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:friendCellIdentifer];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake((cell.width - 304)/2, (kTableViewRowHeith - 44)/2, 304, 44)];
                UIImage *image = [[UIImage imageNamed:@"button_bg_login"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
                [addFriendButton setBackgroundImage:image forState:UIControlStateNormal];
                [addFriendButton setTitle:@"添加好友" forState:UIControlStateNormal];
                [addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [addFriendButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:addFriendButton];
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
            return cell;
        }
        
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifer];
        if (cell == nil) {
            cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentifer] ;
        }
        NSString *str = @"范冰冰今天睡眠质量80%";
        CGSize size =[str sizeWithFont:kTitleFont1];
        cell.friendRunLB.frame = CGRectMake(cell.friendRunLB.x, cell.friendRunLB.y, cell.width, size.height);
        [cell.friendRunLB setText:str WithFont:kContentFont1 AndColor:kContentNormalColor];
        [cell.friendRunLB setKeyWordTextArray:@[@"80%"] WithFont:kContentFont1 AndColor:kContentHighlightColor];
        if (indexPath.row == 0) {
            [cell setCellPosition:CellPositionTop];
        } else if (indexPath.row == 10-1) {
            [cell setCellPosition:CellPositionBottom];
        } else {
            [cell setCellPosition:CellPositionMiddle];
        }
        return cell;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isViewShow) {
        _isViewShow = YES;
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - self.view.frame.size.width);
        _tableView.contentOffset = offset;
    }
}

- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.title = [DateHelper getDayStringWith:0];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_tableView == scrollView) {
        _currentPage = 5 - scrollView.contentOffset.y/self.view.width - 1;
        self.navigationItem.title = [DateHelper getDayStringWith:_currentPage];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
    _tableView.center = CGPointMake(self.view.width/2, self.view.height/2);
    
}

- (void)go {
    if ([CSDataManager sharedInstace].isLogin) {
        AddFriendViewController *vc = [[AddFriendViewController alloc] initWithNibName:@"AddFriendViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUDManager showTextWithTitle:@"请先登录" inView:self.view];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
