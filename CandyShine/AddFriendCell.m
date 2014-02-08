//
//  AddFriendCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-8.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "AddFriendCell.h"

@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _frinendThumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        _frinendThumberImage.layer.cornerRadius = 25;
        _frinendThumberImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_frinendThumberImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
