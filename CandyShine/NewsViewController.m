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
#import "News.h"

@interface NewsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    CSDataManager *_dataManager;
    NSArray *_images;
    NSArray *_contents;
    NSArray *_authors;
    NSIndexPath *_currentIndexPath;
}
@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IsIOS7) {
            UIImage *image = [UIImage imageNamed:@"tabBarIcon_news"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *imageSelected = [UIImage imageNamed:@"tabBarIcon_news_selected"];
            imageSelected = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"资讯" image:image selectedImage:imageSelected];
        } else {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBarIcon_news_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBarIcon_news"]];
            self.tabBarItem.title = @"资讯";
        }
        
        self.navigationItem.title = @"资讯";
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    [_tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil ] forCellReuseIdentifier:@"NewsCellIdentifer"];
    [self.view addSubview:_tableView];
    
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    _dataManager = [CSDataManager sharedInstace];
    _images = @[@"http://image03.u69cn.com/2013/contentinfo/08/109813_zi.jpg",@"http://d06.res.meilishuo.net/pic/_o/24/4c/345a6cfa2469959d18b873160df2_310_302.c6.jpg",@"http://img.ea3w.com/267/266328.jpg"];
    _contents = @[@"马来西亚民航局称，2人持偷来的护照登机，包括意大利人Luigi Maraldi和奥地利人KOZEL CHRISTIAN，二人票号相连。",@"奥巴马表示，自从去年我们在安纳伯格庄园会晤以来，美中关系取得了积极进展，今年是美中建交35周年，美方希望两国在一系列重大问题上的合作取得新成果。",@"巡视组组长徐光春指出，云南省党风廉政建设形势严峻，反映领导干部问题较"];
    
//    NSArray *author = @[@"Candy1",@"Candy2",@"Candy3"];
//    for (int i=0; i<3; i++) {
//        [_dataManager insertNewsWithBlock:^(News *news) {
//            news.date = [DateHelper getDayBegainWith:i];
//            news.content = [contents objectAtIndex:i];
//            news.image = [images objectAtIndex:i];
//            news.author = [author objectAtIndex:i];
//        }];
//    }
//    [_dataManager saveCoreData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"NewsCellIdentifer";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.scrollView.contentOffset = CGPointMake(0, 0);
    NSString *date = [DateHelper getYYMMDDString:indexPath.row];
    News *news = [_dataManager fetchNewsByDate:date];
    if (news == nil) {
        [self requestNewsWithDateIndex:indexPath.row];
    } else {
        
        [cell.pictureImageView setImageWithURL:[NSURL URLWithString:news.image] placeholderImage:[UIImage imageNamed:@"news_placeholderImage"]];
        cell.contentLB.text = news.content;
        cell.dayLB.text = [DateHelper getDayWithIndex:indexPath.row];
        cell.motheLB.text = [DateHelper getMothWithIndex:indexPath.row];
        cell.authorLB.text = news.author;
    }
    cell.pageLB.text = [NSString stringWithFormat:@"VOL.%d",indexPath.row];
    return cell;
}

- (void)requestNewsWithDateIndex:(NSInteger)index {
    [MBProgressHUDManager showIndicatorWithTitle:@"正在请求" inView:self.view];
    [[CandyShineAPIKit sharedAPIKit] requestNewsWithDate:[DateHelper getYYMMDDString:index] Success:^(NSDictionary *result) {
        [MBProgressHUDManager hideMBProgressInView:self.view];
        CSResponceCode code = [[result objectForKey:@"code"] integerValue];
        if (code == CSResponceCodeSuccess) {
            NSArray *messages = [result objectForKey:@"message"];
            NSDictionary *message;
            NSString *image;
            NSString *content;
            if (messages.count >= 2) {
                message = [messages objectAtIndex:0];
                image = [NSString stringWithFormat:@"%@%@",kBaseURL,[message objectForKey:@"text"]];
                message = [messages objectAtIndex:1];
                content = [message objectForKey:@"url"];
            }
            [_dataManager insertNewsWithBlock:^(News *new) {
                new.date = [DateHelper getYYMMDDString:index];
                new.image = [_images objectAtIndex:index];
                new.content = [_contents objectAtIndex:index];
                new.author = @"CandyWearables";
            }];
            [_dataManager saveCoreData];
            [_tableView reloadData];
        } else {
            [MBProgressHUDManager showTextWithTitle:@"请求失败" inView:self.view];
        }
    } fail:^(NSError *error) {
        [MBProgressHUDManager hideMBProgressInView:self.view];
        [MBProgressHUDManager showTextWithTitle:error.localizedDescription inView:self.view];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.y/self.view.width;
    _currentIndexPath = [NSIndexPath indexPathForRow:page inSection:0];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
    _tableView.center = CGPointMake(self.view.width/2, self.view.height/2);
}

- (void)initNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(shareHandler)];
}

- (void)shareHandler {
    News *news = [_dataManager fetchNewsByDate:[DateHelper getYYMMDDString:_currentIndexPath.row]];
    NewsCell *cell = (NewsCell *)[_tableView cellForRowAtIndexPath:_currentIndexPath];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:news.content
                                     shareImage:cell.pictureImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
