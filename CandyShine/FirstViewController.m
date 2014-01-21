//
//  FirstViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "FirstViewController.h"
#import "DragView.h"

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation FirstViewController

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
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGPoint offset = CGPointMake(0, _tableView.contentSize.height - self.view.frame.size.width);
    _tableView.contentOffset = offset;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"CellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10000];
    label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UILabel *labe = (UILabel *)[[cell.contentView viewWithTag:1000] viewWithTag:100];
    labe.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}


- (void)initNavigationItem {
    [self.navigationItem setCustomeLeftBarButtonItem:@"TabMeSelected" target:self action:@selector(back)];
}

- (IBAction)go {
    FirstViewController *vc = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
