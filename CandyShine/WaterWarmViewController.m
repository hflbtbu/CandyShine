//
//  WaterWarmViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-10.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "WaterWarmViewController.h"
#import "EditWarmTimeViewController.h"

#define WaterWarmTime   @"WaterWarmTime"

@interface WaterWarmViewController () <UITableViewDelegate,UITableViewDataSource,EditWarmTimeViewControllerDelegate>
{
    NSMutableArray *_warmTimeArray;
    IBOutlet UITableView *_tableView;
    
    UIPickerView *_timePickerView;
    
    EditType _editType;
    int _selectedIndex;
}
@end

@implementation WaterWarmViewController

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

    // Uncomment the following line to preserve selection between presentations.
     //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self deleteLocalNotificationWith:0];
    [self initialWarmTime];
    
    _tableView.rowHeight = 80;
    _tableView.allowsSelectionDuringEditing = YES;
    _tableView.allowsSelection = NO;
    _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
}

- (void)initNavigationItem {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView)];
    self.navigationItem.leftBarButtonItem = edit;
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWarmTime)];
    self.navigationItem.rightBarButtonItem = add;
}

- (void)editTableView {
    [_tableView setEditing:!_tableView.editing animated:YES];
}

- (void)addWarmTime {
    _editType = EditTypeAdd;
    EditWarmTimeViewController *editVC = [[EditWarmTimeViewController alloc] initWithNibName:@"EditWarmTimeViewController" bundle:nil];
    editVC.delegate = self;
    BaseNavigationController *baseVC = [[BaseNavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:baseVC animated:YES completion:^{
        
    }];
   
}

- (void)initialWarmTime {
    _warmTimeArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] arrayForKey:WaterWarmTime];
    if (_warmTimeArray == nil) {
        _warmTimeArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 3; i++) {
            NSTimeInterval timeInterval = i*30*60;
            [_warmTimeArray addObject:[NSNumber numberWithDouble:timeInterval]];
            [self addNewLocalNotificationWith:timeInterval];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:_warmTimeArray forKey:WaterWarmTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)cancleLocalNotificationWith:(int)timeInterval {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[notification.userInfo objectForKey:WaterWarmTime] intValue] == timeInterval) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (void)addNewLocalNotificationWith:(int)timeInterval {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:date];
    UILocalNotification *newNotification = [[UILocalNotification alloc] init];
    if (newNotification) {
        //时区
        newNotification.timeZone=[NSTimeZone defaultTimeZone];
        newNotification.fireDate= fireDate;
        //推送内容
        newNotification.alertBody = @"该喝水了";
        //设置按钮
        newNotification.alertAction = @"喝水";
        //判断重复与否
        newNotification.repeatInterval = NSDayCalendarUnit;
        
        //存入的字典，用于传入数据，区分多个通知
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:timeInterval], WaterWarmTime, nil];
        newNotification.userInfo = dic;
        [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    }

}

- (void)didSelectedWarmTime:(int)timeInterval {
    if (_editType == EditTypeAdd) {
        [_warmTimeArray addObject:[NSNumber numberWithInt:timeInterval]];
        [self addNewLocalNotificationWith:timeInterval];
    } else {
        [_warmTimeArray setObject:[NSNumber numberWithInt:timeInterval] atIndexedSubscript:_selectedIndex];
        [self cancleLocalNotificationWith:timeInterval];
        [self addNewLocalNotificationWith:timeInterval];
    }
    _warmTimeArray = [NSMutableArray arrayWithArray:[_warmTimeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;
        }
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }]];
    
    [[NSUserDefaults standardUserDefaults] setValue:_warmTimeArray forKey:WaterWarmTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_warmTimeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UISwitch *warmSwitch = [[UISwitch alloc] init];
        warmSwitch.on = YES;
        cell.accessoryView  = warmSwitch;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:50];
    }
    
    // Configure the cell...
    int timeInterval = [[_warmTimeArray objectAtIndex:indexPath.row] doubleValue];
    int minute = timeInterval/60%60;
    int hour = (timeInterval/60 - minute)/60;
    cell.textLabel.text = [NSString stringWithFormat:@"%02d:%02d",hour,minute];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self cancleLocalNotificationWith:[[_warmTimeArray objectAtIndex:indexPath.row] intValue]];
    [_warmTimeArray removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WaterWarmTime];
    [[NSUserDefaults standardUserDefaults] setValue:_warmTimeArray forKey:WaterWarmTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
 
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _editType = EditTypeModify;
    _selectedIndex = (int)indexPath.row;
    EditWarmTimeViewController *editVC = [[EditWarmTimeViewController alloc] initWithNibName:@"EditWarmTimeViewController" bundle:nil];
    editVC.delegate = self;
    BaseNavigationController *baseVC = [[BaseNavigationController alloc] initWithRootViewController:editVC];
    [self presentViewController:baseVC animated:YES completion:^{
        
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView setEditing:NO animated:NO];
}

@end
