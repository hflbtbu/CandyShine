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
        
        _friensTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.contentView.width, 455 - 160) style:UITableViewStylePlain];
        [self.contentView addSubview:_friensTableView];
        
    }
    return self;
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
