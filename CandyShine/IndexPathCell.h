//
//  IndexPathCell.h
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndexPathCellDelegate <NSObject>

- (void)switchValueDidChanged:(NSIndexPath *)indexPath :(BOOL)isOn;

@end

@interface IndexPathCell : UITableViewCell

@property (nonatomic, assign) id<IndexPathCellDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) UISwitch *timeSwitch;
@end
