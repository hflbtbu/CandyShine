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
    RETextItem *_repeatItem;
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
    if (IsIOS7) {
        _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }

    _tablerViewManager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    [self addLoginSection];
}

- (void)addLoginSection {
    RETableViewSection *section = [RETableViewSection section];
    [_tablerViewManager addSection:section];
    
    _oldCodeItem = [RETextItem itemWithTitle:NSLocalizedString(@"原始密码:", @"") value:@"" placeholder:nil];
    _oldCodeItem.keyboardType = UIKeyboardTypeASCIICapable;
    _oldCodeItem.secureTextEntry = YES;
    _newCodeItem = [RETextItem itemWithTitle:NSLocalizedString(@"新密码:", @"") value:@"" placeholder:nil];
    _newCodeItem.keyboardType = UIKeyboardTypeASCIICapable;
    _newCodeItem.secureTextEntry = YES;
    _repeatItem = [RETextItem itemWithTitle:NSLocalizedString(@"确认密码:", @"") value:@"" placeholder:nil];
    _repeatItem.keyboardType = UIKeyboardTypeASCIICapable;
    _repeatItem.secureTextEntry = YES;
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:NSLocalizedString(@"提交", @"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        if ([_newCodeItem.value isEqualToString:_repeatItem.value]) {
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            [[CandyShineAPIKit sharedAPIKit] requestModifyPassWordWithNewPsw:_newCodeItem.value oldPsw:_oldCodeItem.value Success:^(NSDictionary *result) {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                CSResponceCode code = [[result objectForKey:@"code"] integerValue];
                if (code == CSResponceCodeSuccess) {
                    [MBProgressHUDManager showTextWithTitle:@"修改成功" inView:self.view];
                } else {
                    [MBProgressHUDManager showTextWithTitle:@"原始密码不正确" inView:self.view];
                }
            } fail:^(NSError *error) {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                [MBProgressHUDManager showTextWithTitle:error.localizedDescription inView:self.view];
            }];
        } else {
            [MBProgressHUDManager showTextWithTitle:@"密码不一致" inView:self.view];
        }
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:_oldCodeItem];
    [section addItem:_newCodeItem];
    [section addItem:_repeatItem];
    
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
