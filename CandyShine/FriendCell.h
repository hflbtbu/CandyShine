//
//  FriendCell.h
//  CandyShine
//
//  Created by huangfulei on 14-2-7.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"



@interface FriendCell : UITableViewCell

@property (nonatomic, retain) DetailTextView *friendRunLB;
@property (nonatomic, retain) UIImageView *frinendThumberImage;
@property (nonatomic, assign) CellPosition cellPosition;

@end
