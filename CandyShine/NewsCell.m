//
//  NewsCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()
{
    
}
@end

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        UIView *view = [self viewWithTag:9999];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        line.y = _pageLB.y - 5;
        [view addSubview:line];
        line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        line.y = _pageLB.y + _pageLB.height + 5;
        [view addSubview:line];
    
        _contentLB.numberOfLines = 0;
        
        [self.contentView addSubview:view];
        [self willRemoveSubview:view];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    UIView *view = [self viewWithTag:9999];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
    line.y = _pageLB.y - 5;
    [view addSubview:line];
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
    line.y = _pageLB.y + _pageLB.height + 5;
    [view addSubview:line];

    if (IsIOS7) {
        [self.contentView addSubview:view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = CGSizeMake(_contentLB.width,2000);
    
    CGSize labelSize = [_contentLB.text sizeWithFont:_contentLB.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    _contentLB.height = labelSize.height;
    _authorLB.y = _contentLB.y + _contentLB.height + 15;
    _scrollView.contentSize = CGSizeMake(_scrollView.width,_authorLB.y + _authorLB.height + 20);
}

@end
