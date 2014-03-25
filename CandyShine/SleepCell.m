//
//  SleepCell.m
//  CandyShine
//
//  Created by huangfulei on 14-2-13.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "SleepCell.h"
#import "SleepPathView.h"
#import "WaterWarmManager.h"
#import "SleepShow.h"

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

        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line.y + line.height, 320,(Is_4Inch?455:367) - line.y - line.height) style:UITableViewStylePlain];
        _tableView.rowHeight = kTableViewRowHeith;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_tableView];
        
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

- (void)refresh {
    [self analayzesleepData];
    [_sleepPathView refresh];
}

- (void)analayzesleepData {
    if (_sleepDataArray.count >= 4) {
        Sleep *firstItem = [_sleepDataArray objectAtIndex:0];
        Sleep *lastItem = [_sleepDataArray lastObject];
        _sleepLB.text = [NSString stringWithFormat:@"入睡:%@",[DateHelper getTimeStringWithDate:firstItem.date]];
        _getUpLB.text = [NSString stringWithFormat:@"起床:%@",[DateHelper getTimeStringWithDate:lastItem.date]];
        _sleepTimeLB.text = [NSString stringWithFormat:@"睡眠时间:%@",[DateHelper getTimeStringWithFromDate:firstItem.date to:lastItem.date]];
        
        NSDate *fromeDate = [NSDate dateWithTimeInterval:[WaterWarmManager shared].sleepTime sinceDate:[DateHelper getDayBegainWith:_day + 1]];
        NSDate *toDate = [NSDate dateWithTimeInterval:[WaterWarmManager shared].sleepTime sinceDate:firstItem.date];
        NSArray *soprtArray = [[CSDataManager sharedInstace] fetchSportItemsFromeDate:fromeDate  toDate:toDate];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        int i;
        for (i = 0; i< soprtArray.count; i++) {
            Sport *sport = [soprtArray objectAtIndex:i];
            SleepShow *sleep = [[SleepShow alloc] init];
            sleep.value = sport.value;
            [array addObject:sleep];
        }
        
        NSInteger deepSleep = 0;
        NSInteger lightSleep = 0;
        NSInteger awake = 0;
        for (Sleep *sleep in _sleepDataArray) {
            SleepShow *sleepShow = [[SleepShow alloc] init];
            sleepShow.value = sleep.value;
            [array addObject:sleepShow];
            
            if ([sleep.value integerValue] < 40) {
                deepSleep++;
            } else if ([sleep.value integerValue] > 80) {
                awake++;
            } else {
                lightSleep++;
            }
        }
        
        NSTimeInterval timeInterVal = [lastItem.date timeIntervalSinceDate:firstItem.date];
        
        NSInteger deepTime = deepSleep/(deepSleep + awake +lightSleep)*timeInterVal;
        
        NSTimeInterval lightTime = lightSleep/(deepSleep + awake +lightSleep)*timeInterVal;
        
        _sleepEffectLB.text = [NSString stringWithFormat:@"睡眠质量:%d%%",(deepSleep+lightSleep)/(deepSleep+lightSleep+awake)*100];
        
        NSInteger hour = deepTime/3600;
        NSInteger minute = (deepTime - hour*3600)/60;
        _depthSleepLB.text = [NSString stringWithFormat:@"深度睡眠:%d小时%d分钟",hour,minute];
        hour = lightTime/3600;
        minute = (lightTime - hour*3600)/60;
        _lightSleepTimeLB.text = [NSString stringWithFormat:@"浅度睡眠:%d小时%d分钟",hour,minute];;
        
        _sleepPathView.sleepDataArray = array;
        _sleepPathView.sleepPosition = i;
    } else {
        _sleepPathView.sleepDataArray = _sleepDataArray;
        _sleepLB.text = @"入睡:XX";
        _getUpLB.text = @"起床:XX";
        _sleepTimeLB.text = @"睡眠时间:XX";
        _sleepEffectLB.text = @"睡眠质量:XX";
        _depthSleepLB.text = @"深度睡眠:XX";
        _lightSleepTimeLB.text = @"浅度睡眠:XX";
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
