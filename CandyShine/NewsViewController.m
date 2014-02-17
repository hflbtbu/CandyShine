//
//  NewsViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-17.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "NewsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface NewsViewController ()
{
    UIImageView *_image;
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
    
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    [_image setImageWithURL:[NSURL URLWithString:@"http://qzapp.qlogo.cn/qzapp/101008197/5341B5C7474D687ABDC55F58BCD70B7B/100"]];
    [self.view addSubview:_image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
