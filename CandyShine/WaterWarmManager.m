//
//  WaterWarmManager.m
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "WaterWarmManager.h"

@implementation WaterWarmManager

+ (WaterWarmManager *)shared{
    static WaterWarmManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WaterWarmManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        if (_warmTimeDic == nil) {
            _warmTimeDic = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryForKey:kWaterWarmData];
            if (_warmTimeDic == nil) {
                _warmTimeDic = [NSMutableDictionary dictionaryWithCapacity:0];
                _isCustome = NO;
                _isOpenWarm = YES;
                _getupTime = 9*60*60;
                _timeInterval = 4*60*60;
                _timeInterva = _timeInterval;
                [_warmTimeDic setObject:[NSNumber numberWithBool:_isCustome] forKey:kIsCustome];
                [_warmTimeDic setObject:[NSNumber numberWithBool:_isOpenWarm] forKey:kIsOpenWarm];
                [_warmTimeDic setObject:[NSNumber numberWithInteger:_getupTime] forKey:kGetupTime];
                [_warmTimeDic setObject:[NSNumber numberWithInteger:_timeInterval] forKey:kWarmInterval];
                [_warmTimeDic setObject:[NSNumber numberWithInteger:_timeInterva] forKey:kWarmInterva];
                
                _warmTimeArray = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < [self warmTimeCount]; i++) {
                    NSInteger timeInterval = i*_timeInterval + _getupTime;
                    [_warmTimeArray addObject:[NSNumber numberWithInteger:timeInterval]];
                    [self addLocalNotificationWith:timeInterval];
                }
                _customeWarmTimeArray = [NSMutableArray arrayWithCapacity:0];
                _warmTimeStateArray = [NSMutableArray arrayWithCapacity:0];
                [self refreshWarmTimeState];
                [_warmTimeDic setObject:_warmTimeArray forKey:kWaterWarmTime];
                [_warmTimeDic setObject:_customeWarmTimeArray forKey:kCustomeWaterWarmTime];
                [_warmTimeDic setObject:_warmTimeStateArray forKey:[DateHelper getDayStringWith:0]];
                [[NSUserDefaults standardUserDefaults] setObject:_warmTimeDic forKey:kWaterWarmData];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                _isCustome = [[_warmTimeDic objectForKey:kIsCustome] boolValue];
                _isOpenWarm = [[_warmTimeDic objectForKey:kIsOpenWarm] boolValue];
                _warmTimeArray = [NSMutableArray arrayWithArray:[_warmTimeDic objectForKey:kWaterWarmTime]];
                _customeWarmTimeArray = [NSMutableArray arrayWithArray:[_warmTimeDic objectForKey:kCustomeWaterWarmTime]];
                _timeInterval = [[_warmTimeDic objectForKey:kWarmInterval] integerValue];
                _timeInterva = [[_warmTimeDic objectForKey:kWarmInterva] integerValue];
                _getupTime = [[_warmTimeDic objectForKey:kGetupTime] integerValue];
                
                _warmTimeStateArray = [_warmTimeDic objectForKey:[DateHelper getDayStringWith:0]];
                if (_warmTimeStateArray == nil) {
                    [_warmTimeDic removeObjectForKey:[DateHelper getDayStringWith:-1]];
                    [self refreshWarmTimeState];
                    [_warmTimeDic setObject:_warmTimeStateArray forKey:[DateHelper getDayStringWith:0]];
                }
            }
        }
        
    }
    return self;
}

- (NSInteger)warmTimeCount {
    NSInteger count = (24*60*60 - _getupTime)/(_timeInterval == 0 ? 7200 : _timeInterval) + 1;
    return count;
}

- (void)refreshWarmTimeState {
    [_warmTimeStateArray removeAllObjects];
    if (!_isCustome) {
        for (int i = 0; i < [self warmTimeCount]; i++) {
            [_warmTimeStateArray addObject:[NSNumber numberWithInteger:WaterWarmStateBefore]];
        }
    } else {
        for (NSDictionary *dic in _customeWarmTimeArray) {
            BOOL isOn = [[dic objectForKey:kWarmTimeIsOn] boolValue];
            if (isOn) {
                [_warmTimeStateArray addObject:[NSNumber numberWithInteger:WaterWarmStateBefore]];
            }
        }
    }
}

- (void)replaceWarmTimeState:(WaterWarmState)state AtIndex:(NSInteger)index {
    [_warmTimeStateArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:state]];
}

- (NSIndexPath *)selectedIndexPath {
    NSInteger section = _timeInterva == 0 ? 2 : 1;
    NSInteger row;
    if (section == 2) {
        row = 0;
    } else {
        row = _timeInterva/3600/2 - 1;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)removeWarmTimeWith:(NSInteger)index{
    NSInteger timeInterVal = [[[_customeWarmTimeArray objectAtIndex:index] objectForKey:kWarmTimeValue] integerValue];
    [self cancelLocalNotificationWith:timeInterVal];
    [_customeWarmTimeArray removeObjectAtIndex:index];
    [self refreshWarmTimeState];
}

- (void)addLocalNotificationWith:(NSInteger)timeInterval{
    if (timeInterval <= 24*60*60) {
        NSDate *fireDate = [NSDate dateWithTimeInterval:timeInterval sinceDate:[DateHelper getDayBegainWith:0]];
        UILocalNotification *newNotification = [[UILocalNotification alloc] init];
        if (newNotification) {
            //时区
            newNotification.timeZone=[NSTimeZone defaultTimeZone];
            newNotification.fireDate= fireDate;
            //推送内容
            newNotification.alertBody = @"该喝水了";
            //设置按钮
            newNotification.alertAction = @"喝水";
            //判断重复与否
            newNotification.repeatInterval = NSDayCalendarUnit;
            //存入的字典，用于传入数据，区分多个通知
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval], kWaterWarmTime, nil];
            newNotification.userInfo = dic;
            [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
        }

    }
}

- (void)cancelLocalNotificationWith:(NSInteger)timeInterval {
    for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[notification.userInfo objectForKey:kWaterWarmTime] integerValue] == timeInterval) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }

}

- (void)saveData {
    [_warmTimeDic setValue:[NSNumber numberWithBool:_isCustome] forKey:kIsCustome];
    [_warmTimeDic setValue:[NSNumber numberWithBool:_isOpenWarm] forKey:kIsOpenWarm];
    [_warmTimeDic setValue:[NSNumber numberWithInteger:_timeInterval] forKey:kWarmInterval];
    [_warmTimeDic setValue:[NSNumber numberWithInteger:_timeInterva] forKey:kWarmInterva];
    [_warmTimeDic setValue:[NSNumber numberWithInteger:_getupTime] forKey:kGetupTime];
    [_warmTimeDic setValue:_warmTimeArray forKey:kWaterWarmTime];
    [_warmTimeDic setValue:_customeWarmTimeArray forKey:kCustomeWaterWarmTime];
    [_warmTimeDic setValue:_warmTimeStateArray forKey:[DateHelper getDayStringWith:0]];
    
    [[NSUserDefaults standardUserDefaults] setValue:_warmTimeDic forKey:kWaterWarmData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sortWarmTimeArray {
    _customeWarmTimeArray = [NSMutableArray arrayWithArray:[_customeWarmTimeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[obj1 objectForKey:kWarmTimeValue] integerValue] > [[obj2 objectForKey:kWarmTimeValue] integerValue]) {
            return NSOrderedDescending;
        }
        if ([[obj1 objectForKey:kWarmTimeValue] integerValue] < [[obj2 objectForKey:kWarmTimeValue] integerValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }]];
}


- (void)addWarmTimeWith:(NSInteger)timeInterval {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval],kWarmTimeValue,[NSNumber numberWithBool:YES],kWarmTimeIsOn, nil];
    [_customeWarmTimeArray addObject:dic];
    [self addLocalNotificationWith:timeInterval];
    [self sortWarmTimeArray];
    [self refreshWarmTimeState];
}

- (void)replaceWarmTimeWith:(NSInteger)timeInterval atIndex:(NSInteger)index {
    BOOL isOn = [[[_customeWarmTimeArray objectAtIndex:index] objectForKey:kWarmTimeIsOn] boolValue];
    NSInteger oldTimeInterval = [[[_customeWarmTimeArray objectAtIndex:index] objectForKey:kWarmTimeValue] integerValue];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval],kWarmTimeValue,[NSNumber numberWithBool:isOn],kWarmTimeIsOn, nil];
    if (isOn) {
        [self cancelLocalNotificationWith:oldTimeInterval];
    }
    [_customeWarmTimeArray replaceObjectAtIndex:index withObject:dic];
    if (isOn) {
        [self addLocalNotificationWith:timeInterval];
    }
    [self sortWarmTimeArray];
}

- (void)replaceWarmTimeOnWith:(BOOL)isOn atIndex:(NSInteger)index {
    NSInteger timeInterval =  [[[_customeWarmTimeArray objectAtIndex:index] objectForKey:kWarmTimeValue] integerValue];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval],kWarmTimeValue,[NSNumber numberWithBool:isOn],kWarmTimeIsOn, nil];
    [_customeWarmTimeArray replaceObjectAtIndex:index withObject:dic];
    if (isOn) {
        [self addLocalNotificationWith:timeInterval];
    } else {
        [self cancelLocalNotificationWith:timeInterval];
    }
    [self refreshWarmTimeState];
}

- (void)setGetupTime:(NSInteger)getupTime {
    _getupTime = getupTime;
    [_warmTimeArray removeAllObjects];
    if (!_isCustome) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    for (int i = 0; i < [self warmTimeCount]; i++) {
        NSInteger timeInterval = i*_timeInterval + _getupTime;
        [_warmTimeArray addObject:[NSNumber numberWithInteger:timeInterval]];
        if (!_isCustome) {
            [self addLocalNotificationWith:timeInterval];
        }
    }
    if (!_isCustome) {
        [self refreshWarmTimeState];
    }
}

- (void)setTimeInterval:(NSInteger)timeInterval {
    _timeInterva = timeInterval;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (timeInterval == 0) {
        _isCustome = YES;
        for (NSInteger i = 0; i < [_customeWarmTimeArray count]; i++) {
            NSInteger timeInterval =  [[[_customeWarmTimeArray objectAtIndex:i] objectForKey:kWarmTimeValue] integerValue];
            [self addLocalNotificationWith:timeInterval];
        }
    } else {
        _timeInterval = timeInterval;
        _isCustome = NO;
        [_warmTimeArray removeAllObjects];
        for (int i = 0; i < [self warmTimeCount]; i++) {
            NSInteger timeInterval = i*_timeInterval + _getupTime;
            [_warmTimeArray addObject:[NSNumber numberWithInteger:timeInterval]];
            [self addLocalNotificationWith:timeInterval];
        }
    }
    [self refreshWarmTimeState];
}

- (void)setIsOpenWarm:(BOOL)isOpenWarm {
    _isOpenWarm = isOpenWarm;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (_isOpenWarm) {
        if (!_isCustome) {
            for (int i = 0; i < [self warmTimeCount]; i++) {
                [self addLocalNotificationWith:_getupTime + i*_timeInterval];
            }
        } else {
            for (NSInteger i = 0; i < [_customeWarmTimeArray count]; i++) {
                NSInteger timeInterval =  [[[_customeWarmTimeArray objectAtIndex:i] objectForKey:kWarmTimeValue] integerValue];
                [self addLocalNotificationWith:timeInterval];
            }
        }
    }
}

- (NSArray *)getWarmTimes {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (!_isCustome) {
        return _warmTimeArray;
    } else {
        for (NSDictionary *dic in _customeWarmTimeArray) {
            BOOL isOn = [[dic objectForKey:kWarmTimeIsOn] boolValue];
            if (isOn) {
                [array addObject:[NSNumber numberWithInteger:[[dic objectForKey:kWarmTimeValue] integerValue]]];
            }
        }
    }
    return array;
}

@end
