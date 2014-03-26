//
//  LookDataViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-3-26.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "LookDataViewController.h"
#import "Sleep.h"

@interface LookDataViewController ()
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
    NSArray *data = [[CSDataManager sharedInstace] fetchSleepItemsByDay:1];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
