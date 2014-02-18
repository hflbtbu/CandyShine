//
//  NewsViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-17.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "NewsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NewsCell.h"

@interface NewsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    UIView *sf ;
}
@end

@implementation NewsViewController

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
    self.view.backgroundColor = [UIColor orangeColor];
    
    sf = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    sf.backgroundColor = [UIColor grayColor];
    [sf.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    sf.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //[self.view addSubview:sf];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"newCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [UIXib cellWithXib:@"NewsCell" style:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    return cell;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
    _tableView.center = CGPointMake(self.view.width/2, self.view.height/2);
    
    sf.width = 200;
    sf.height = 260;
    
    sf.center = CGPointMake(160, 130);
}

- (void)viewDidAppear:(BOOL)animate {
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
