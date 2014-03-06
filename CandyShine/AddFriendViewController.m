//
//  AddFriendViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-8.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddFriendCell.h"

@interface AddFriendViewController () <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UISearchBar *_addFriendSearchbar;
    IBOutlet UITableView *_searchResultTableView;
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
        [[_addFriendSearchbar.subviews objectAtIndex:0]removeFromSuperview];  //去掉搜索框背景
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"CircleCellIdentifer";
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        [cell.addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row == 0) {
        [cell setCellPosition:CellPositionTop];
    } else if (indexPath.row == 5 - 1) {
        [cell setCellPosition:CellPositionBottom];
    } else {
        [cell setCellPosition:CellPositionMiddle];
    }

    
    return cell;
}


- (void)searchFriendWithUserName:(NSString *)userName {
    
}

- (void)addFriend {
    
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (IsIOS7) {
        UIButton *cancelButton = [[[_addFriendSearchbar.subviews objectAtIndex:0] subviews] objectAtIndex:2];
        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
    } else {
        UIButton *cancelButton = [_addFriendSearchbar.subviews objectAtIndex:1];
        [cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = kContentFont1;
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setBackgroundImage:nil forState:UIControlStateSelected];
        [cancelButton setBackgroundImage:nil forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
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
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self searchFriendWithUserName:searchBar.text];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
