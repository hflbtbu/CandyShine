//
//  LookDataViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-3-26.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "LookDataViewController.h"
#import "Sleep.h"
#import <MessageUI/MessageUI.h>

@interface LookDataViewController () <MFMailComposeViewControllerDelegate>
{
    IBOutlet UITextView *_dataView;
}
@end

@implementation LookDataViewController

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *data = [[CSDataManager sharedInstace] fetchSleepItemsByDay:_currentPage];
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    int i = 0;
    for (Sleep *sleep in data) {
        i++;
        //NSDateFormatter *dateformatrer = [[NSDateFormatter alloc] init];
        //NSString *holder;

        NSString *date =[DateHelper getTimeStringWithDate:sleep.date];
        [string appendString:[NSString stringWithFormat:@"%@=%03d",date,[sleep.value intValue]]];
        if (i == 4) {
            [string appendString:@"\n"];
            i = 0;
            //holder = @"  ";
        } else {
            [string appendString:@"  "];
            //holder = @"  ";
        }
    }
    _dataView.text = string;
}


- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(go)];
}

- (void)go {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    //设置主题
    [mailPicker setSubject: @"睡眠数据收集"];
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"hflbtbu@sina.cn"];
    [mailPicker setToRecipients: toRecipients];
    NSString *emailBody = _dataView.text;
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:^{
        
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
            [self back];
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
