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

@interface SleepViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger _currentPage;
    UILabel *_titleLB;
}
@end

@implementation SleepViewController

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
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
        
        if (indexPath.row == 9) {
            [cell setCellPosition:CellPositionTop];
        } else if (indexPath.row == 0) {
            [cell setCellPosition:CellPositionBottom];
        } else {
            [cell setCellPosition:CellPositionMiddle];
        }
        
        [cell.friendSleepPkLabel setText:[NSString stringWithFormat:@"今天超过的80%%的用户"] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0x787878]];
        [cell.friendSleepPkLabel setKeyWordTextArray:@[[NSString stringWithFormat:@"80%%"]] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0xffaa33]];
        
        return cell;
    } else {
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
    [super viewWillAppear:animated];
    CGPoint offset = CGPointMake(0, _tableView.contentSize.height - self.view.frame.size.width);
    _tableView.contentOffset = offset;
    
}

- (void)initNavigationItem {
    [super initNavigationItem];
    _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    _titleLB.textColor = [UIColor convertHexColorToUIColor:0x8c8377];
    _titleLB.textAlignment = NSTextAlignmentCenter;
    _titleLB.text = [DateHelper getDayStringWith:0];
    self.navigationItem.titleView = _titleLB;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPage = 10 - scrollView.contentOffset.y/self.view.width - 1;
    _titleLB.text = [DateHelper getDayStringWith:_currentPage];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
    _tableView.center = CGPointMake(self.view.width/2, self.view.height/2);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
