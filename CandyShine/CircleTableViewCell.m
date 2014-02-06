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
    }
    return self;
}

- (void)refresh {
    _circlePathView.runNumbers = _runNumbers;
    [_circlePathView refrsh];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
