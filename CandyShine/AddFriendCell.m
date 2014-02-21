//
//  AddFriendCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-8.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "AddFriendCell.h"

@interface AddFriendCell ()
{
    UIImageView *_topLine;
    UIImageView *_middleLine;
    UIImageView *_bottomLine;
}
@end

@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        _topLine.y = 0;
        [self.contentView addSubview:_topLine];
        
        _middleLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_gradual"]];
        [self.contentView addSubview:_middleLine];
        
        _bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        [self.contentView addSubview:_bottomLine];
        
        _frinendThumberImage = [[CircleImageView alloc] initWithFrame:CGRectMake(15, 0, kCircleImageViewLineCap + kCircleImageViewLineWidth + kCircleImageViewWidth, kCircleImageViewLineCap + kCircleImageViewLineWidth + kCircleImageViewWidth) image:@"IMG_0005.JPG"];
        [self.contentView addSubview:_frinendThumberImage];

        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.backgroundColor = [UIColor clearColor];
        _addButton.frame = CGRectMake(self.width - 20 - 50, 0, 50, 40);
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor grayColor ] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_addButton];
    }
    return self;
}

- (void)setCellPosition:(CellPosition)cellPosition {
    if (cellPosition == CellPositionTop) {
        _topLine.hidden = YES;
        _middleLine.hidden = NO;
        _bottomLine.hidden = YES;
    } else if (cellPosition == CellPositionMiddle) {
        _topLine.hidden = YES;
        _middleLine.hidden = NO;
        _bottomLine.hidden = YES;
    }  else if (cellPosition == CellPositionBottom) {
        _topLine.hidden = YES;
        _middleLine.hidden = YES;
        _bottomLine.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _frinendThumberImage.y = (self.contentView.height - _frinendThumberImage.height)/2;
    _middleLine.y = self.contentView.height - _middleLine.height;
    _bottomLine.y = self.contentView.height - _bottomLine.height;
    _addButton.y = (self.contentView.height - _addButton.height)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
