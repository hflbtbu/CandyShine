//
//  ModifyCodeViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "ModifyCodeViewController.h"

@interface ModifyCodeViewController () <RETableViewManagerDelegate>
{
    IBOutlet UITableView *_tableView;
    RETableViewManager *_tablerViewManager;
    RETextItem *_oldCodeItem;
    RETextItem *_newCodeItem;
    RETextItem *_sureNewCodeItem;
}
@end

@implementation ModifyCodeViewController

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
    _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);

    _tablerViewManager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    [self addLoginSection];
}

- (void)addLoginSection {
    RETableViewSection *section = [RETableViewSection section];
    [_tablerViewManager addSection:section];
    
    _oldCodeItem = [RETextItem itemWithTitle:NSLocalizedString(@"原始密码:", @"") value:@"" placeholder:nil];
    //_oldCodeItem.detailLabelText
    _oldCodeItem.keyboardType = UIKeyboardTypeNumberPad;
    _newCodeItem = [RETextItem itemWithTitle:NSLocalizedString(@"新密码:", @"") value:@"" placeholder:nil];
    _newCodeItem.keyboardType = UIKeyboardTypeNumberPad;
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:NSLocalizedString(@"提交", @"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:_oldCodeItem];
    [section addItem:_newCodeItem];
    
    
    RETableViewSection *btnSection = [RETableViewSection section];
    [_tablerViewManager addSection:btnSection];
    [btnSection addItem:buttonItem];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
