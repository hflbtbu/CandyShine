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
        cell.addButton.hidden = YES;
    }
    
    
    if (_friendArray.count == 1) {
        [cell setCellPosition:CellPositionBottom];
    } else {
        if (indexPath.row == 0) {
            [cell setCellPosition:CellPositionTop];
        } else if (indexPath.row == _friendArray.count - 1) {
            [cell setCellPosition:CellPositionBottom];
        } else {
            [cell setCellPosition:CellPositionMiddle];
        }
        
    }
    
    CSFreiend *item;
    if (indexPath.row < _friendArray.count) {
        item = [_friendArray objectAtIndex:indexPath.row];
    }

    cell.frinendThumberImage.imageView.image = [UIImage imageNamed:@"portrait_holder"];
    if (item.portrait.length != 0) {
        [cell.frinendThumberImage.imageView setImageWithURL:[NSURL URLWithString:item.portrait]];
        cell.nameLB.text = item.name;
    }
    return cell;
}

//- (void)addFreindButtonClickedHander:(UIButton *)button {
//    if ([button.titleLabel.text isEqualToString:@"关注"]) {
//        [button setTitle:@"取消关注" forState:UIControlStateNormal];
//    } else {
//        [button setTitle:@"关注" forState:UIControlStateNormal];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
