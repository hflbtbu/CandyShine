//
//  CircleTableViewCell.m
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CircleTableViewCell.h"

#define CircleTableViewCellCircleRadius 230

@interface CircleTableViewCell ()
{
    MoveCircleView *_circlePathView;
    UIImageView *_left;
    UIImageView *_right;
}
@end

@implementation CircleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        _circlePathView = [[MoveCircleView alloc] initWithFrame:CGRectMake((self.contentView.width - CircleTableViewCellCircleRadius)/2, 40, CircleTableViewCellCircleRadius, CircleTableViewCellCircleRadius)];
        _circlePathView.progress = 0.8f;
        _circlePathView.runNumbers = 300;
        [self.contentView addSubview:_circlePathView];
        
        _left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_left"]];
        _left.center = CGPointMake(20, 40 + CircleTableViewCellCircleRadius/2);
        _left.hidden = YES;
        [self.contentView addSubview:_left];
        
        _right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_right"]];
        _right.center = CGPointMake(300, 40 + CircleTableViewCellCircleRadius/2);
        _right.hidden = YES;
        [self.contentView addSubview:_right];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setCurrentPage:(CellPosition)currentPage {
    if (currentPage == CellPositionTop) {
        _left.hidden = NO;
        _right.hidden = YES;
    } else if (currentPage == CellPositionMiddle) {
        _left.hidden = NO;
        _right.hidden = NO;
    } else {
        _left.hidden = YES;
        _right.hidden = NO;
    }
}

- (void)refresh {
    _circlePathView.isToday = _isToday;
    _circlePathView.runNumbers = _runNumbers;
    [_circlePathView refrsh];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
