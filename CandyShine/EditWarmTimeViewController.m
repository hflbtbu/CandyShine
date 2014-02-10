//
//  EditWarmTimeViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-10.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "EditWarmTimeViewController.h"

@interface EditWarmTimeViewController () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIPickerView *_timePickerView;
    
    NSInteger _selectedMinute;
    NSInteger _selectedHour;
}
@end

@implementation EditWarmTimeViewController

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

- (void)initNavigationItem {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = edit;
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addWarmTime)];
    self.navigationItem.rightBarButtonItem = add;
}


- (void)addWarmTime {
    [self dismiss];
    if ([_delegate respondsToSelector:@selector(didSelectedWarmTime:)]) {
        [_delegate didSelectedWarmTime:_selectedHour*3600 + _selectedMinute*60];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    } else {
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%02ld",row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedHour = row;
    } else {
        _selectedMinute = row;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    
    [_timePickerView selectRow:components.hour inComponent:0 animated:NO];
    [_timePickerView selectRow:components.minute inComponent:1 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
