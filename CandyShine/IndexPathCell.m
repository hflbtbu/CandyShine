//
//  IndexPathCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "IndexPathCell.h"

@implementation IndexPathCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeSwitch = [[UISwitch alloc] init];
        [_timeSwitch addTarget:self action:@selector(switchValueChangeHander:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = _timeSwitch;
    }
    return self;
}

- (void)switchValueChangeHander:(UISwitch *)sender;
{
    if ([_delegate respondsToSelector:@selector(switchValueDidChanged::)]) {
        [_delegate switchValueDidChanged:_indexPath :sender.isOn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
