//
//  BaseViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
	// Do any additional setup after loading the view.
    if (self.navigationController) {
        [self initNavigationItem];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    if (IsIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)go {
    
}

- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)initNavigationItem {
    if (self.navigationController.viewControllers.count >= 2) {
        [self.navigationItem  setCustomeLeftBarButtonItem:@"navagation_back" target:self action:@selector(back)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
