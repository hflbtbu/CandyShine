//
//  CircleTableViewCell.h
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirclePathView.h"
#import "MoveCircleView.h"

@interface CircleTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) DataPattern currentPattern;
@property (nonatomic, assign) NSInteger runNumbers;
@property (nonatomic, assign) CellPosition currentPage;


- (void)refresh;

@end
