//
//  WeekTableViewCell.m
//  CandyShine
//
//  Created by huangfulei on 14-3-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kWeekCellCap    33
#define kWeekCellWidth  24

#import "WeekTableViewCell.h"

@interface WeekTableViewCell ()
{
    NSMutableArray *_weekDataArray;
    CAShapeLayer *_gogalLine;
    UITableView *_friendTableView;
}
@end

@implementation WeekTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addWeekDataView];
    }
    return self;
}

- (void) addWeekDataView {
    _gogalLine = [CAShapeLayer layer];
    _gogalLine.frame = CGRectMake(16.5, 40, 320 - kWeekCellCap, 0.5);
    _gogalLine.lineWidth = 0.5;
    _gogalLine.lineDashPattern =  @[[NSNumber numberWithFloat:4.0],[NSNumber numberWithFloat:4.0]];
    _gogalLine.lineCap = kCALineCapButt;
    _gogalLine.strokeColor = [[UIColor convertHexColorToUIColor:0xe6e1da] CGColor];
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:_gogalLine.frame.origin];
    [line addLineToPoint:CGPointMake(_gogalLine.frame.size.width - kWeekCellCap, _gogalLine.frame.origin.y)];
    _gogalLine.path = line.CGPath;
    [self.contentView.layer addSublayer:_gogalLine];
    
    if (_weekDataArray == nil) {
        _weekDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSArray *weekStrings = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    
    CGFloat space = (320 - 2*kWeekCellCap - 7*kWeekCellWidth)/6;
    
    for (int i = 0; i < 7; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kWeekCellCap + i*(kWeekCellWidth + space), 160 + 35 - 20*i - 10, kWeekCellWidth, 20*i + 10)];
        view.backgroundColor = kContentNormalShallowColorA;
        [self.contentView addSubview:view];
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        dayLabel.center = CGPointMake(kWeekCellCap + kWeekCellWidth/2 + i*(kWeekCellWidth + space), 195 + 16);
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.textColor = kContentNormalShallowColorA;
        dayLabel.text = (NSString *)weekStrings[i];
        [self.contentView addSubview:dayLabel];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kWeekCellCap, 194, 318 - 2*kWeekCellCap, 1)];
    lineView.backgroundColor = kContentHighlightColor;
    [self.contentView addSubview:lineView];
    
    _friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 225, 320, 200) style:UITableViewStylePlain];
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_friendTableView];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
