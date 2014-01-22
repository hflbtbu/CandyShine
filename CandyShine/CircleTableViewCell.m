//
//  CircleTableViewCell.m
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CircleTableViewCell.h"

@interface CircleTableViewCell ()
{
    CirclePathView *_circlePathView;
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
        _circlePathView = [[CirclePathView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
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
