//
//  SleepCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepCell.h"

@implementation SleepCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 255, self.width,568 - 255 - 49 - 60-1) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(-27, 0, -35, 0);
        [self.contentView addSubview:_tableView];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [_friendSleepPkLabel.text sizeWithFont:_friendSleepPkLabel.font];
    _friendSleepPkLabel.size = size;
    _friendSleepPkLabel.center = CGPointMake(self.height/2, size.height/2 + 5);
}

@end
