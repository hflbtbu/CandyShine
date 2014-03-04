//
//  SleepCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepCell.h"

@interface SleepCell ()
{
    UIImageView *_left;
    UIImageView *_right;
}
@end

@implementation SleepCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        [self commenInit];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        line.y = _sleepLB.y - 5;
        [self.contentView addSubview:line];
        line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        line.y = _depthSleepLB.y + _depthSleepLB.height + 5;
        [self.contentView addSubview:line];

        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line.y + line.height, self.width,(Is_4Inch?455:367) - line.y - line.height) style:UITableViewStylePlain];
        _tableView.rowHeight = kTableViewRowHeith;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        
        _left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_left"]];
        _left.center = CGPointMake(7, _sleepPathView.height/2 + 20);
        _left.hidden = YES;
        [self.contentView addSubview:_left];
        
        _right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_right"]];
        _right.center = CGPointMake(320 - 7, _sleepPathView.height/2 + 20);
        _right.hidden = YES;
        [self.contentView addSubview:_right];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)commenInit {
    [self.contentView addSubview:_sleepPathView];
    [self.contentView addSubview:_sleepLB];
    [self.contentView addSubview:_getUpLB];
    [self.contentView addSubview:_sleepEffectLB];
    [self.contentView addSubview:_sleepTimeLB];
    [self.contentView addSubview:_depthSleepLB];
    [self.contentView addSubview:_lightSleepTimeLB];
}

- (void)setCellPosition:(CellPosition)cellPosition {
    if (cellPosition == CellPositionTop) {
        _left.hidden = NO;
        _right.hidden = YES;
    } else if (cellPosition == CellPositionMiddle) {
        _left.hidden = NO;
        _right.hidden = NO;
    } else {
        _left.hidden = YES;
        _right.hidden = NO;
    }
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
