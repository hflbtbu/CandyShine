//
//  AddFriendCell.h
//  CandyShine
//
//  Created by huangfulei on 14-2-8.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendCell : UITableViewCell

@property (nonatomic, retain) CircleImageView *frinendThumberImage;
@property (nonatomic, retain) UILabel *nameLB;
@property (nonatomic, assign) CellPosition cellPosition;
@property (nonatomic, retain) UIButton *addButton;

@end
