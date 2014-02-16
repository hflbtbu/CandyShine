//
//  SleepCell.h
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@interface SleepCell : UITableViewCell

@property (nonatomic, retain) IBOutlet DetailTextView *friendSleepPkLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@end
