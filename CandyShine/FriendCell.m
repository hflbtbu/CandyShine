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
        
//        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 1)];
//        _topLine.backgroundColor = [UIColor convertHexColorToUIColor:0xccc8c2];
//        [self.contentView addSubview:_topLine];
//        
//        _middleLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60 - 1, self.contentView.width, 1)];
//        _middleLine.backgroundColor = [UIColor grayColor];
//        [self.contentView addSubview:_middleLine];
//        
//        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,60 - 1, self.contentView.width, 1)];
//        _bottomLine.backgroundColor = [UIColor convertHexColorToUIColor:0xccc8c2];
//        [self.contentView addSubview:_bottomLine];
        
//        _frinendThumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
//        _frinendThumberImage.layer.cornerRadius = 25;
//        _frinendThumberImage.layer.masksToBounds = YES;
//        _frinendThumberImage.image = [UIImage imageNamed:@"IMG_0005.JPG"];
//        [self.contentView addSubview:_frinendThumberImage];
        
    
        self.imageView.layer.cornerRadius = 25;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.image = [UIImage imageNamed:@"IMG_0005.JPG"];
        
        _friendRunLB = [[DetailTextView alloc] initWithFrame:CGRectMake(80, 20, self.width - 80, 40)];
        //_friendRunLB.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_friendRunLB];
        
    }
    return self;
}

- (void)setCellPosition:(CellPosition)cellPosition {
//    if (cellPosition == CellPositionTop) {
//        _topLine.hidden = YES;
//        _middleLine.hidden = NO;
//        _bottomLine.hidden = YES;
//    } else if (cellPosition == CellPositionMiddle) {
//        _topLine.hidden = YES;
//        _middleLine.hidden = NO;
//        _bottomLine.hidden = YES;
//    }  else if (cellPosition == CellPositionBottom) {
//        _topLine.hidden = YES;
//        _middleLine.hidden = YES;
//        _bottomLine.hidden = NO;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = CGSizeMake(50, 50);
    self.imageView.center = CGPointMake(self.imageView.center.x, 30);
}

@end
