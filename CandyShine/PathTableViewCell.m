//
//  PathTableViewCell.m
//  CandyShine
//
//  Created by huangfulei on 14-1-22.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "PathTableViewCell.h"
#import "GridPathView.h"


@interface PathTableViewCell ()
{
    GridPathView *_gridPathView;
    UIImageView *_upDownImage;
    UIImageView *_left;
    UIImageView *_right;
}
@end

@implementation PathTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0.5)];
        lineView.backgroundColor = [UIColor convertHexColorToUIColor:0xccc8c2];
        [self.contentView addSubview:lineView];
        
        _gridPathView = [[GridPathView alloc] initWithFrame:CGRectMake(0, 8, self.contentView.width, 160)];
        [self.contentView addSubview:_gridPathView];
        
        _friensTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, self.contentView.width, 455 - 160) style:UITableViewStyleGrouped];
        _friensTableView.rowHeight = 60;
        _friensTableView.backgroundColor = [UIColor clearColor];
        _friensTableView.contentInset = UIEdgeInsetsMake(-27, 0, 0, 0);
        //_friensTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:_friensTableView];
        
        _upDownImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up"]];
        _upDownImage.center = CGPointMake(160, 12);
        [self.contentView addSubview:_upDownImage];
        
        _left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_left"]];
        _left.center = CGPointMake(20, 8 + 160/2);
        _left.hidden = YES;
        [self.contentView addSubview:_left];
        
        _right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_right"]];
        _right.center = CGPointMake(300, 8 + 160/2);
        _right.hidden = YES;
        [self.contentView addSubview:_right];
    }
    return self;
}


- (void)setMoveType:(PageMoveType)moveType {
    _moveType = moveType;
    if (_moveType == PageMoveUp) {
        _upDownImage.image = [UIImage imageNamed:@"arrow_down"];
    } else {
        _upDownImage.image = [UIImage imageNamed:@"arrow_up"];
    }
}

- (void)setCellPosition:(CellPosition)cellPosition {
    if (_moveType == PageMoveDown) {
        _left.hidden = YES;
        _right.hidden = YES;
    } else {
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
}

- (void)refresh {
    _gridPathView.valueArray = _valueArray;
    [_gridPathView refresh];
    [_friensTableView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
