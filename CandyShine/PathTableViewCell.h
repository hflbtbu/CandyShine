//
//  PathTableViewCell.h
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) UITableView *friensTableView;

- (void)refresh;

@end
