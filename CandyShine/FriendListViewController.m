//
//  FriendListViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-25.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "FriendListViewController.h"
#import "AddFriendCell.h"
#import "CSFreiend.h"

@interface FriendListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    NSMutableArray *_friendArray;
}


@end

@implementation FriendListViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
    [[CandyShineAPIKit sharedAPIKit] requestFriednListSuccess:^(NSMutableArray *result) {
        _friendArray = result;
        [MBProgressHUDManager hideMBProgressInView:self.view];
        [_tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer = @"CircleCellIdentifer";
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        [cell.addButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [cell.addButton addTarget:self action:@selector(addFreindButtonClickedHander:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if (indexPath.row == 0) {
        [cell setCellPosition:CellPositionTop];
    } else if (indexPath.row == 5 - 1) {
        [cell setCellPosition:CellPositionBottom];
    } else {
        [cell setCellPosition:CellPositionMiddle];
    }
    cell.addButton.tag = indexPath.row;
    CSFreiend *friend;
    if (indexPath.row < _friendArray.count) {
        friend = [_friendArray objectAtIndex:indexPath.row];
    }
    cell.nameLB.text = friend.name;
    return cell;
}

- (void)addFreindButtonClickedHander:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"关注"]) {
        [button setTitle:@"取消关注" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"关注" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
