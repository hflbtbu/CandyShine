//
//  SleepViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepViewController.h"
#import "SleepCell.h"

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
        
        [cell.friendSleepPkLabel setText:[NSString stringWithFormat:@"今天超过的80%%的用户"] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0x787878]];
        [cell.friendSleepPkLabel setKeyWordTextArray:@[[NSString stringWithFormat:@"80%%"]] WithFont:[UIFont systemFontOfSize:15] AndColor:[UIColor convertHexColorToUIColor:0xffaa33]];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIdentifer] ;
//            UIImageView *thumber = [[UIImageView alloc] initWithFrame:CGRectMake(cell.width - 100, 5, 50, 50)];
//            thumber.backgroundColor = [UIColor orangeColor];
//            thumber.layer.cornerRadius = 25;
//            thumber.layer.masksToBounds = YES;
//            thumber.image = [UIImage imageNamed:@"IMG_0005.JPG"];
//            [cell.contentView addSubview:thumber];
            cell.imageView.layer.cornerRadius = 25;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.image =  [UIImage imageNamed:@"TabMeSelected"];
            cell.textLabel.textColor = [UIColor convertHexColorToUIColor:0x787878];
            cell.textLabel.text = @"范冰冰今天的睡眠质量80%";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
