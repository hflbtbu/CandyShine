//
//  AddFriendViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-8.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddFriendCell.h"
#import "CSFreiend.h"

@interface AddFriendViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UISearchBar *_addFriendSearchbar;
    IBOutlet UITableView *_searchResultTableView;
    UIButton *_selectedButton;
    NSArray *_frendArray;
}

@end

@implementation AddFriendViewController

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
    [self initialSearchBar];
    _searchResultTableView.rowHeight = kTableViewRowHeith;
    
}


- (void)initialSearchBar {
    _addFriendSearchbar.placeholder = @"输入用户名搜索";
    //_addFriendSearchbar.backgroundImage = [UIImage imageNamed:@""];
   //_addFriendSearchbar.backgroundColor = [UIColor grayColor];
    if (IsIOS7) {
        //[[[[_addFriendSearchbar.subviews objectAtIndex:0] subviews] objectAtIndex:0]removeFromSuperview];  //去掉搜索框背景
    } else {
        //[[_addFriendSearchbar.subviews objectAtIndex:0]removeFromSuperview];  //去掉搜索框背景
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _frendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"CircleCellIdentifer";
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    [cell.addButton setTitle:@"关注" forState:UIControlStateNormal];
    [cell.addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.addButton.tag = indexPath.row;
    
    if (_frendArray.count == 1) {
        [cell setCellPosition:CellPositionBottom];
    } else {
        if (indexPath.row == 0) {
            [cell setCellPosition:CellPositionTop];
        } else if (indexPath.row == _frendArray.count - 1) {
            [cell setCellPosition:CellPositionBottom];
        } else {
            [cell setCellPosition:CellPositionMiddle];
        }

    }

    CSFreiend *item;
    if (indexPath.row < _frendArray.count) {
        item = [_frendArray objectAtIndex:indexPath.row];
    }
    cell.frinendThumberImage.imageView.image = [UIImage imageNamed:@"portrait_holder"];
    if (item.portrait.length != 0) {
        [cell.frinendThumberImage.imageView setImageWithURL:[NSURL URLWithString:item.portrait]];
        cell.nameLB.text = item.name;
    }
    
    cell.nameLB.text = item.name;
    return cell;
}


- (void)searchFriendWithUserName:(NSString *)userName {
    [MBProgressHUDManager showIndicatorWithTitle:@"正在请求" inView:self.view];
    [[CandyShineAPIKit sharedAPIKit] requestSearchFriednListWithKeyword:userName Success:^(NSMutableArray *result) {
        [MBProgressHUDManager hideMBProgressInView:self.view];
        if (result == nil || result.count == 0) {
            [MBProgressHUDManager showTextWithTitle:@"未搜到好友" inView:self.view];
        } else {
            _frendArray = result;
            [_searchResultTableView reloadData];
        }
    } fail:^(NSError *error) {
        [MBProgressHUDManager hideMBProgressInView:self.view];
        [MBProgressHUDManager showTextWithTitle:@"请求失败" inView:self.view];
    }];
}

- (void)addFriend:(UIButton *)sender {
    _selectedButton = sender;
    if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        [MBProgressHUDManager showIndicatorWithTitle:@"正在请求" inView:self.view];
        CSFreiend *item = [_frendArray objectAtIndex:sender.tag];
        [[CandyShineAPIKit sharedAPIKit] requestAddFeiendWithUserID:item.uid Success:^(NSDictionary *result) {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            CSResponceCode code = [[result objectForKey:@"code"] integerValue];
            if (code == CSResponceCodeSuccess) {
                [MBProgressHUDManager showTextWithTitle:@"关注成功" inView:self.view];
                [_selectedButton setTitle:@"已关注" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kAddFriendFinishNotification object:nil]];
            } else {
                [MBProgressHUDManager showTextWithTitle:@"已关注过该好友" inView:self.view];
                [_selectedButton setTitle:@"已关注" forState:UIControlStateNormal];
            }
        } fail:^(NSError *error) {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            [MBProgressHUDManager showTextWithTitle:@"请求失败" inView:self.view];
        }];
    }
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (IsIOS7) {
        UIButton *cancelButton = [[[_addFriendSearchbar.subviews objectAtIndex:0] subviews] objectAtIndex:2];
        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
    } else {
//        UIButton *cancelButton = [_addFriendSearchbar.subviews objectAtIndex:1];
//        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        cancelButton.titleLabel.font = kContentFont1;
//        cancelButton.backgroundColor = [UIColor clearColor];
//        [cancelButton setBackgroundImage:nil forState:UIControlStateSelected];
//        [cancelButton setBackgroundImage:nil forState:UIControlStateNormal];
//        [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchFriendWithUserName:searchBar.text];
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_addFriendSearchbar becomeFirstResponder];
}

- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.title = @"添加好友";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
