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
