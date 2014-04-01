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

#define kSleepStep 3

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
        line.y = _sleepLB.y - 10;
        [self.contentView addSubview:line];
        line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_normal"]];
        line.y = _depthSleepLB.y + _depthSleepLB.height + 10;
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
    if ([self verifyData]){
        Sleep *firstItem = [_sleepDataArray objectAtIndex:0];
        Sleep *lastItem = [_sleepDataArray lastObject];
        _sleepLB.text = [NSString stringWithFormat:@"入睡:%@",[DateHelper getTimeStringWithDate:firstItem.date]];
        _getUpLB.text = [NSString stringWithFormat:@"起床:%@",[DateHelper getTimeStringWithDate:lastItem.date]];
        _sleepTimeLB.text = [NSString stringWithFormat:@"睡眠时间:%@",[DateHelper getTimeStringWithFromDate:firstItem.date to:lastItem.date]];
        
        NSMutableArray *addStepArray = [NSMutableArray arrayWithCapacity:0];
        NSInteger hour = [lastItem.date timeIntervalSinceDate:firstItem.date]/3600;
        NSInteger addStep = [self getAddStepWith:hour];
        NSInteger count = _sleepDataArray.count%addStep == 0 ? _sleepDataArray.count/addStep : _sleepDataArray.count/addStep + 1;
        for (int i = 0; i < count; i++) {
            NSInteger totalValue = 0;
            for (int j = 0; j < addStep; j++) {
                if (i*addStep + j < _sleepDataArray.count) {
                    Sleep *sleep = [_sleepDataArray objectAtIndex:i*addStep + j];
                    totalValue += [sleep.value integerValue];
                }
            }
            SleepShow *sleepShow = [[SleepShow alloc] init];
            sleepShow.value = [NSNumber numberWithInteger:totalValue];
            [addStepArray addObject:sleepShow];
        }
        
        NSInteger deepCount = 0;
        
        CGFloat height = 250;
        CGFloat top = 10;
        CGFloat bottom = 45;
        CGFloat deepValue0 = 0;
        CGFloat deepValue1 = bottom - top;
        CGFloat lightValue0 = bottom + top;
        CGFloat lightValue1 = lightValue0 + (height - 3*top -bottom)/3;
        CGFloat lightValue2 = lightValue0 + (height - 3*top -bottom)*2/3;
        CGFloat lightValue3 = lightValue0 + (height - 3*top -bottom);
// 修改档位
        CGFloat deepY0 = 1;
        CGFloat deepY1 = 3;
        CGFloat lightY0 = 4;
        CGFloat lightY1 = 5;
        CGFloat lightY2 = 20;
        
        for (int i = 0; i < addStepArray.count; i++) {
            SleepShow *item = [addStepArray objectAtIndex:i];
            NSInteger value = [item.value integerValue];
            
            if (value <= deepY0) {
                item.value = [NSNumber numberWithInteger:deepValue0];
                deepCount++;
            } else if (value > deepY0 && value <= deepY1) {
                item.value = [NSNumber numberWithInteger:deepValue1];
                deepCount ++;
            } else if (value > deepY1 && value <= lightY0) {
                item.value = [NSNumber numberWithInteger:lightValue0];
            } else if (value > lightY0 && value <= lightY1) {
                item.value = [NSNumber numberWithInteger:lightValue1];
            } else if (value > lightY1 && value <= lightY2) {
                item.value = [NSNumber numberWithInteger:lightValue2];
            } else {
                item.value = [NSNumber numberWithInteger:lightValue3];
            }

        }
        SleepShow *sleepShow = [[SleepShow alloc] init];
        sleepShow.value = [NSNumber numberWithInteger:height];
        [addStepArray insertObject:sleepShow atIndex:0];
        sleepShow = [[SleepShow alloc] init];
        sleepShow.value = [NSNumber numberWithInteger:height];
        [addStepArray insertObject:sleepShow atIndex:0];
        
        sleepShow = [[SleepShow alloc] init];
        sleepShow.value = [NSNumber numberWithInteger:height];
        [addStepArray addObject:sleepShow];
        sleepShow = [[SleepShow alloc] init];
        sleepShow.value = [NSNumber numberWithInteger:height];
        [addStepArray addObject:sleepShow];
        
        
        _sleepPathView.top = height - top;
        _sleepPathView.bottom = bottom;
        _sleepPathView.sleepDataArray = addStepArray;
        
        NSTimeInterval totalTime = [lastItem.date timeIntervalSinceDate:firstItem.date];
        NSTimeInterval deepTime = deepCount/(CGFloat)(addStepArray.count - 4)*totalTime;
        hour = deepTime/3600;
        NSInteger minure = (deepTime - hour*3600)/60;
        _depthSleepLB.text = [NSString stringWithFormat:@"深度睡眠:%d小时%d分钟",hour,minure];
        
        hour = (totalTime - deepTime)/3600;
        minure = (totalTime - deepTime - hour*3600)/60;
        _lightSleepTimeLB.text = [NSString stringWithFormat:@"浅度睡眠:%d小时%d分钟",hour,minure];
        
        NSInteger effect = deepCount/(CGFloat)(addStepArray.count - 4)*100;
        _sleepEffectLB.text = [NSString stringWithFormat:@"睡眠质量:%d%%",effect];
        
//        NSDate *fromeDate = [DateHelper getDateBeforDate:firstItem.date hour:4];
//        NSDate *toDate = [DateHelper getDateAfterDate:lastItem.date hour:5];
//        NSArray *soprtBeforeArray = [[CSDataManager sharedInstace] fetchSportItemsFromeDate:fromeDate  toDate:firstItem.date];
//        NSArray *soprtAfterArray = [[CSDataManager sharedInstace] fetchSportItemsFromeDate:lastItem.date  toDate:toDate];
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//        int i;
//        for (i = 0; i< soprtBeforeArray.count; i++) {
//            Sport *sport = [soprtBeforeArray objectAtIndex:i];
//            SleepShow *sleep = [[SleepShow alloc] init];
//            sleep.value = sport.value;
//            [array addObject:sleep];
//        }
//        
//        NSInteger deepSleep = 0;
//        NSInteger lightSleep = 0;
//        NSInteger awake = 0;
//        for (Sleep *sleep in _sleepDataArray) {
//            SleepShow *sleepShow = [[SleepShow alloc] init];
//            sleepShow.value = sleep.value;
//            [array addObject:sleepShow];
//            
//            if ([sleep.value integerValue] < 4) {
//                deepSleep++;
//            } else if ([sleep.value integerValue] > 30) {
//                awake++;
//            } else {
//                lightSleep++;
//            }
//        }
//        
//        int j;
//        for (j = 0; i< soprtAfterArray.count; i++) {
//            Sport *sport = [soprtAfterArray objectAtIndex:j];
//            SleepShow *sleep = [[SleepShow alloc] init];
//            sleep.value = sport.value;
//            [array addObject:sleep];
//        }
//        
//        NSDate *lastDate;
//        if (soprtAfterArray.count == 0) {
//            Sleep *sleep = [_sleepDataArray lastObject];
//            lastDate = sleep.date;
//        } else {
//            Sport *sport = [soprtAfterArray lastObject];
//            lastDate = sport.date;
//        }
//        
//        CGFloat widthIndex;
//        if ([toDate timeIntervalSinceDate:lastDate] <= 0) {
//            widthIndex = 1.0;
//        } else {
//            widthIndex = [lastDate timeIntervalSinceDate:fromeDate]/[toDate timeIntervalSinceDate:fromeDate];
//        }
//        
//        NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:0];
//        for (int i = 0; i < array.count/4 ; i++) {
//            SleepShow *sleep = [[SleepShow alloc] init];
//            NSInteger toalValue = 0;
//            for (int j = 0; j< 4; j++) {
//                SleepShow *item = [array objectAtIndex:i*4 + j];
//                toalValue += [item.value integerValue];
//            }
//            sleep.value = [NSNumber numberWithInteger:toalValue];
//            [newArray addObject:sleep];
//        }
//        
//        
//        
//        //
//        NSTimeInterval timeInterVal = [lastItem.date timeIntervalSinceDate:firstItem.date];
//        
//        NSInteger deepTime = deepSleep/(deepSleep + awake +lightSleep)*timeInterVal;
//        
//        NSTimeInterval lightTime = lightSleep/(deepSleep + awake +lightSleep)*timeInterVal;
//        
//        _sleepEffectLB.text = [NSString stringWithFormat:@"睡眠质量:%d%%",(deepSleep+lightSleep)/(deepSleep+lightSleep+awake)*100];
//        
//        NSInteger hour = deepTime/3600;
//        NSInteger minute = (deepTime - hour*3600)/60;
//        _depthSleepLB.text = [NSString stringWithFormat:@"深度睡眠:%d小时%d分钟",hour,minute];
//        hour = lightTime/3600;
//        minute = (lightTime - hour*3600)/60;
//        _lightSleepTimeLB.text = [NSString stringWithFormat:@"浅度睡眠:%d小时%d分钟",hour,minute];;
//        //
//        
//        _sleepPathView.sleepDataArray = newArray;
//        _sleepPathView.sleepPosition = soprtBeforeArray.count/(CGFloat)(soprtBeforeArray.count + _sleepDataArray.count + soprtAfterArray.count) * newArray.count;
//        
//        NSInteger sleepEndPosition =  (soprtBeforeArray.count + _sleepDataArray.count)/(CGFloat)(soprtBeforeArray.count + _sleepDataArray.count + soprtAfterArray.count) * newArray.count;
//        if (sleepEndPosition >= newArray.count) {
//            sleepEndPosition = newArray.count - 1;
//        }
//        _sleepPathView.sleepEndPosition = sleepEndPosition;
        
        _sleepPathView.timeLB1.hidden = NO;
        _sleepPathView.timeLB5.hidden = NO;
        _sleepPathView.timeLB1.text = [NSString stringWithFormat:@"%02dh",[DateHelper getHourWithDate:firstItem.date isBefor:YES]];
        _sleepPathView.timeLB5.text = [NSString stringWithFormat:@"%02dh",[DateHelper getHourWithDate:lastItem.date isBefor:NO]];
        
    } else {
        _sleepPathView.timeLB1.hidden = YES;
        _sleepPathView.timeLB5.hidden = YES;
        _sleepPathView.sleepDataArray = nil;
        _sleepLB.text = @"入睡:XX";
        _getUpLB.text = @"起床:XX";
        _sleepTimeLB.text = @"睡眠时间:XX";
        _sleepEffectLB.text = @"睡眠质量:XX";
        _depthSleepLB.text = @"深度睡眠:XX";
        _lightSleepTimeLB.text = @"浅度睡眠:XX";
    }
}

- (BOOL) verifyData {
    if (_sleepDataArray.count < 12) {
        return NO;
    } else {
        NSInteger totalValue = 0;
        for (int i = 0; i < _sleepDataArray.count - 10; i++) {
            Sleep *sleep = [_sleepDataArray objectAtIndex:i];
            totalValue += [sleep.value integerValue];
        }
        if (totalValue <= 2) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)getAddStepWith:(NSInteger)hour {
    NSInteger addStep;
    switch (hour) {
        case 0:
        case 1:
        case 2:
        case 3:
            addStep = 1;
            break;
        case 4:
            addStep = 2;
            break;
        case 5:
        case 6:
            addStep = 3;
            break;
        case 7:
        case 8:
            addStep = 4;
            break;
        case 9:
            addStep = 5;
            break;
        case 10:
            addStep = 5;
            break;
        default:
            addStep = 6;
            break;
    }
    return addStep;
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
