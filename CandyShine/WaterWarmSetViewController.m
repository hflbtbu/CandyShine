
//  WaterWarmViewController.m
//  CandyShine
//
//  Created by huangfulei on 14-2-10.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "WaterWarmSetViewController.h"
#import "EditWarmTimeViewController.h"
#import "WaterWarmManager.h"
#import "SelectedCell.h"
#import "IndexPathCell.h"
#import "PickerView.h"
#import "VerticalLabel.h"

@interface WaterWarmSetViewController () <UITableViewDelegate,UITableViewDataSource, IndexPathCellDelegate, PickerViewDelegate>
{
    NSMutableArray *_warmTimeArray;
    IBOutlet UITableView *_tableView;
    
    UIPickerView *_timePickerView;
    
    EditType _editType;
    int _selectedIndex;
    
    SelectedCell *_selectedCell;
    
    WaterWarmManager *_waterWarmManager;
    BOOL _isReloadData;
    BOOL _isAddWarm;
    NSIndexPath *_selectedIndexPath;
    
    NSInteger _tempTimeInterVal;
    
    BOOL _isSaved;
}
@end

@implementation WaterWarmSetViewController

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
    _isSaved = NO;
    
    
    _tableView.allowsSelectionDuringEditing = YES;
    if (IsIOS7) {
        _tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
    
    _tableView.backgroundColor = [UIColor convertHexColorToUIColor:0xf2f0ed];
    _tableView.backgroundView = nil;
    
    _waterWarmManager = [WaterWarmManager shared];
    
    _tempTimeInterVal = _waterWarmManager.timeInterval;
    
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
    if (!_waterWarmManager.isOpenWarm) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return _waterWarmManager.isOpenWarm ? 1 :1;
    } else if (section == 1) {
        return 3;
    } else {
        return _waterWarmManager.isCustome ? [_waterWarmManager customeWarmTimeArray].count + 1 : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *cellIdentifier = @"CellIdentifier";
    static NSString *selectedCellIdentifier = @"SelectedCellIdentifier";
    static NSString *switchCellIdentifier = @"SwitchCellIdentifier";
    static NSString *accessoryCellIdentifier = @"AccessoryCellIdentifier";
    switch (indexPath.section) {
            case 0: {
                switch (indexPath.row) {
                        case 0: {
                            IndexPathCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
                            if (cell == nil) {
                                cell = [[IndexPathCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
                                cell.timeSwitch.on = _waterWarmManager.isOpenWarm;
                                cell.delegate = self;
                                cell.textLabel.textColor = kContentNormalColor;
                                cell.textLabel.font = kContentFont3;
                            }
                            cell.indexPath = indexPath;
                            cell.textLabel.text = @"喝水提醒";
                            cell.textLabel.textColor = kContentNormalColor;
                            return cell;
                            break;
                        }
                        case 1: {
                            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:accessoryCellIdentifier];
                            if (cell == nil) {
                                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:accessoryCellIdentifier];
                                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                                cell.textLabel.textColor = kContentNormalColor;
                                cell.textLabel.font = kContentFont3;
                                cell.detailTextLabel.textColor = kContentNormalColor;
                                cell.detailTextLabel.font = kContentFont3;
                            }
                            cell.textLabel.text = @"起床时间";
                            cell.textLabel.textColor = kContentNormalColor;
                            cell.detailTextLabel.text = [self getTimeStringWith:_waterWarmManager.getupTime];
                            cell.detailTextLabel.textColor = kContentNormalShallowColorA;
                            return cell;
                            break;
                        }
                        
                    default:
                        break;
                }
            }
            case 1: {
                SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedCellIdentifier];
                if (cell == nil) {
                    cell = [[SelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectedCellIdentifier];
                    cell.textLabel.font = kContentFont3;
                }
                switch (indexPath.row) {
                        case 0:
                        cell.textLabel.text = @"2小时";
                        cell.isSelected = [_waterWarmManager.selectedIndexPath isEqual:indexPath];
                        _selectedCell = cell;
                        break;
                        case 1:
                        cell.textLabel.text = @"4小时";
                        cell.isSelected = [_waterWarmManager.selectedIndexPath isEqual:indexPath];
                        break;
                        case 2:
                        cell.textLabel.text = @"6小时";
                        cell.isSelected = [_waterWarmManager.selectedIndexPath isEqual:indexPath];
                        break;
                    default:
                        break;
                }
                return cell;
                break;
            }
            case 2: {
                switch (indexPath.row) {
                        case 0: {
                            SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedCellIdentifier];
                            if (cell == nil) {
                                cell = [[SelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectedCellIdentifier];
                                cell.textLabel.font = kContentFont3;
                            }
                            cell.textLabel.text = @"自定义喝水提醒";
                            cell.isSelected = [_waterWarmManager.selectedIndexPath isEqual:indexPath];
                            return cell;
                            break;
                        }
                    default:{
                        IndexPathCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
                        if (cell == nil) {
                            cell = [[IndexPathCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
                            cell.delegate = self;
                            cell.textLabel.textColor = kContentNormalColor;
                            cell.textLabel.font = kContentFont3;
                        }
                        cell.indexPath = indexPath;
                        NSDictionary *dic = [[[WaterWarmManager shared] customeWarmTimeArray] objectAtIndex:indexPath.row - 1];
                        cell.timeSwitch.on = [[dic objectForKey:kWarmTimeIsOn] boolValue];
                        NSInteger timeInterval = [[dic objectForKey:kWarmTimeValue] integerValue];
                        cell.textLabel.text = [self getTimeStringWith:timeInterval];
                        return cell;
                        break;
                    }
                }
            }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        VerticalLabel *label = [[VerticalLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"   每隔以下时间提醒我喝水";
        label.font = [UIFont systemFontOfSize:15];
        label.contentMode = UIViewContentModeBottom;
        label.textColor = kContentNormalColor;
        return label;
    }
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 && _waterWarmManager.isCustome) {
        return 60;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2 && _waterWarmManager.isCustome) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, self.view.width)];
        bgView.backgroundColor = [UIColor clearColor];
        UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 304, 44)];
        [addFriendButton setTitle:@"添加时间" forState:UIControlStateNormal];
        [addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *bgImage = [[UIImage imageNamed:@"button_bg_drink"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.5, 0, 4.5)];
        [addFriendButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        [addFriendButton addTarget:self action:@selector(addWarmTime) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:addFriendButton];
        return bgView;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row >= 1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[WaterWarmManager shared] cancelLocalNotificationWith:indexPath.row -1];
    [[WaterWarmManager shared] removeWarmTimeWith:indexPath.row -1];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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
    if (indexPath.section == 2 && indexPath.row >= 1) {
        [self showPickerView];
    } else if (indexPath.section == 1) {
        _tempTimeInterVal = _waterWarmManager.timeInterval;
        _waterWarmManager.timeInterval = (indexPath.row + 1)*2*3600;
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        _waterWarmManager.timeInterval = 0;
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        [self showPickerView];
    }
    _selectedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)saveDrinkTime {
    _isSaved = YES;
    if ([CSDataManager sharedInstace].isConneting) {
        [[CSDataManager sharedInstace] setDrinkWaterInterval:_waterWarmManager.timeInterval block:^{
            _isSaved = NO;
            _tempTimeInterVal = _waterWarmManager.timeInterval;
            [MBProgressHUDManager showTextWithTitle:@"设置喝水提醒成功" inView:[[UIApplication sharedApplication] keyWindow]];
        }];
    } else {
        if (![CSDataManager sharedInstace].isDongingConnect) {
            [MBProgressHUDManager showIndicatorWithTitle:@"正在连接设备" inView:self.view];
            [[CSDataManager sharedInstace] connectDeviceWithBlock:^(CSConnectState state) {
                [MBProgressHUDManager hideMBProgressInView:self.view];
                if (state == CSConnectfound) {
                    [[CSDataManager sharedInstace] setDrinkWaterInterval:_waterWarmManager.timeInterval block:^{
                        _isSaved = NO;
                        _tempTimeInterVal = _waterWarmManager.timeInterval;
                        [MBProgressHUDManager showTextWithTitle:@"设置喝水提醒成功" inView:[[UIApplication sharedApplication] keyWindow]];
                    }];
                } else if (state == CSConnectUnfound) {
                    _isSaved = NO;
                    _waterWarmManager.timeInterval = _tempTimeInterVal;
                    [_tableView reloadData];
                    [MBProgressHUDManager showTextWithTitle:@"未发现设备" inView:[[UIApplication sharedApplication] keyWindow]];
                } else {
                    _isSaved = NO;
                    _waterWarmManager.timeInterval = _tempTimeInterVal;
                    [_tableView reloadData];
                }
            }];

        }
    }
}

- (void)setDrinkTimeWith:(NSInteger)timeInterval {
    [[CSDataManager sharedInstace] setDrinkWaterInterval:timeInterval block:^{
        
    }];
}


- (void)reloadData {
    [_tableView reloadData];
}

- (void)pickerViewDidSelectedWithVlaue:(NSDictionary *)dic {
    NSInteger hour = [[dic objectForKey:kPickerHuor] integerValue];
    NSInteger minute = [[dic objectForKey:kPickerMinute] integerValue];
    NSInteger timeInterval = hour*3600 + minute*60;
    if (_isAddWarm) {
        _isAddWarm = NO;
        [_waterWarmManager addWarmTimeWith:timeInterval];
    } else {
        if (_selectedIndexPath.section == 0) {
            _waterWarmManager.getupTime =timeInterval;
        } else {
            [_waterWarmManager replaceWarmTimeWith:timeInterval atIndex:_selectedIndexPath.row - 1];
        }
    }
    [_tableView reloadData];
}

- (void)switchValueDidChanged:(NSIndexPath *)indexPath :(BOOL)isOn {
    if (indexPath.section == 0 && indexPath.row == 0) {
        _waterWarmManager.isOpenWarm = isOn;
    } else if (indexPath.section == 2 && indexPath.row >= 1) {
        [_waterWarmManager replaceWarmTimeOnWith:isOn atIndex:indexPath.row - 1];
    }
    [_tableView reloadData];
}

- (void)addWarmTime {
    _isAddWarm = YES;
    [self showPickerView];
}

- (void)showPickerView {
    PickerView *pickerView = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) :PickerViewTime];
    pickerView.delegate = self;
    [pickerView show];
}

- (NSString *)getTimeStringWith:(NSInteger)timeInterval {
    NSInteger minute = timeInterval/60%60;
    NSInteger hour = (timeInterval/60 - minute)/60;
    return  [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    if (!_isSaved) {
        _waterWarmManager.timeInterval = _tempTimeInterVal;
    }
}

- (void)initNavigationItem {
    [super initNavigationItem];
    self.navigationItem.title = @"喝水设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDrinkTime)];
}

@end
