//
//  WeekTableViewCell.h
//  CandyShine
//
//  Created by huangfulei on 14-3-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekTableViewCell : UITableViewCell

@property (nonatomic, retain) NSArray *weekDataArray;

- (void)refresh;

@end
