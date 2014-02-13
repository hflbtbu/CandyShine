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
        _frinendThumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
        _frinendThumberImage.layer.cornerRadius = 25;
        _frinendThumberImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_frinendThumberImage];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = [UIColor clearColor];
        _addButton.frame = CGRectMake(0, 0, 50, 20);
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor grayColor ] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_addButton];
    }
    return self;
}

- (void)layoutSubviews {
    _frinendThumberImage.frame = CGRectMake(_frinendThumberImage.x, (self.height - _frinendThumberImage.height)/2, _frinendThumberImage.width, _frinendThumberImage.height);
    _addButton.frame = CGRectMake(self.width - _addButton.width - 20, (self.height - _addButton.height)/2, _addButton.width, _addButton.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
