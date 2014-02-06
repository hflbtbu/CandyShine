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
    UIView *_topLine;
    UIImageView *_middleLine;
    UIView *_bottomLine;
}
@end

@implementation FriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 1)];
        _topLine.backgroundColor = [UIColor convertHexColorToUIColor:0xccc8c2];
        [self.contentView addSubview:_topLine];
        
        _middleLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60 - 1, self.contentView.width, 1)];
        _middleLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_middleLine];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,60 - 1, self.contentView.width, 1)];
        _bottomLine.backgroundColor = [UIColor convertHexColorToUIColor:0xccc8c2];
        [self.contentView addSubview:_bottomLine];
        
        _frinendThumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        _frinendThumberImage.layer.cornerRadius = 25;
        _frinendThumberImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_frinendThumberImage];
        
        _friendRunLB = [[DetailTextView alloc] initWithFrame:CGRectMake(_frinendThumberImage.x + _frinendThumberImage.width + 20, 20, 200, 40)];
        //_friendRunLB.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_friendRunLB];
        
    }
    return self;
}

- (void)setCellPosition:(CellPosition)cellPosition {
    if (cellPosition == CellPositionTop) {
        _topLine.hidden = NO;
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

@end
