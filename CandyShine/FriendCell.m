//
//  FriendCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-7.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell ()
{
    UIImageView *_topLine;
    UIImageView *_middleLine;
    UIImageView *_bottomLine;
}
@end

@implementation FriendCell

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
        
        _friendRunLB = [[DetailTextView alloc] initWithFrame:CGRectMake(10 + _frinendThumberImage.x + _frinendThumberImage.width, 20, self.width - _frinendThumberImage.x - _frinendThumberImage.width, 40)];
    
        [self.contentView addSubview:_friendRunLB];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _frinendThumberImage.y = (self.contentView.height - _frinendThumberImage.height)/2;
    _friendRunLB.y = (self.contentView.height - _friendRunLB.height)/2;
    _friendRunLB.width = 220;
    _middleLine.y = self.contentView.height - _middleLine.height;
    _bottomLine.y = self.contentView.height - _bottomLine.height;
    
    
}

@end
