//
//  SelectedCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SelectedCell.h"

@implementation SelectedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabMeSelected"]];
        self.textLabel.textColor = kContentHighlightColor;
    } else {
        self.accessoryView = nil;
        self.textLabel.textColor = kContentNormalColor;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
