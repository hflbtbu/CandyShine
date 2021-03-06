//
//  SleepCell.h
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"
#import "SleepPathView.h"

@interface SleepCell : UITableViewCell

@property (nonatomic, retain) IBOutlet DetailTextView *friendSleepPkLabel;
@property (nonatomic, retain) IBOutlet SleepPathView *sleepPathView;
@property (nonatomic, retain) IBOutlet UILabel *sleepLB;
@property (nonatomic, retain) IBOutlet UILabel *getUpLB;
@property (nonatomic, retain) IBOutlet UILabel *sleepEffectLB;
@property (nonatomic, retain) IBOutlet UILabel *sleepTimeLB;
@property (nonatomic, retain) IBOutlet UILabel *depthSleepLB;
@property (nonatomic, retain) IBOutlet UILabel *lightSleepTimeLB;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CellPosition cellPosition;
@property (nonatomic, retain) NSArray *sleepDataArray;
@property (nonatomic, assign) NSInteger day;

- (void)refresh;

@end
