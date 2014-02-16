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
@property (nonatomic, assign) PageMoveType moveType;
@property (nonatomic, assign) CellPosition cellPosition;

- (void)refresh;

@end
