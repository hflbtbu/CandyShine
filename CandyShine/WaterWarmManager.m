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
                _getupTime = 8*60*60;
                _timeInterval = 4*60*60;
                [_warmTimeDic setObject:[NSNumber numberWithBool:_isCustome] forKey:kIsCustome];
                [_warmTimeDic setObject:[NSNumber numberWithBool:_isOpenWarm] forKey:kIsOpenWarm];
                [_warmTimeDic setObject:[NSNumber numberWithInteger:_getupTime] forKey:kGetupTime];
                [_warmTimeDic setObject:[NSNumber numberWithInteger:_timeInterval] forKey:kWarmInterval];
                
                _warmTimeArray = [NSMutableArray arrayWithCapacity:0];
                _warmTimeStateArray= [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < kWarmCount; i++) {
                    NSInteger timeInterval = i*30*60;
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval],kWarmTimeValue,[NSNumber numberWithBool:YES],kWarmTimeIsOn, nil];
                    [_warmTimeArray addObject:dic];
                    [self addLocalNotificationWith:timeInterval];
                }
                [self refreshWarmTimeState];
                [_warmTimeDic setObject:_warmTimeArray forKey:kWaterWarmTime];
                [_warmTimeDic setObject:_warmTimeStateArray forKey:[DateHelper getDayStringWith:0]];
                [[NSUserDefaults standardUserDefaults] setObject:_warmTimeDic forKey:kWaterWarmData];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                _isCustome = [[_warmTimeDic objectForKey:kIsCustome] boolValue];
                _isOpenWarm = [[_warmTimeDic objectForKey:kIsOpenWarm] boolValue];
                _warmTimeArray = [_warmTimeDic objectForKey:kWaterWarmTime];
                _timeInterval = [[_warmTimeDic objectForKey:kWarmInterval] integerValue];
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

- (void)refreshWarmTimeState {
    [_warmTimeStateArray removeAllObjects];
    if (!_isCustome) {
        for (int i = 0; i < kWarmCount; i++) {
            [_warmTimeStateArray addObject:[NSNumber numberWithInteger:WaterWarmStateBefore]];
        }

    } else {
        for (NSDictionary *dic in _warmTimeArray) {
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
    NSInteger section = _timeInterval == 0 ? 2 : 1;
    NSInteger row;
    if (section == 2) {
        row = 0;
    } else {
        row = _timeInterval/3600/2 - 1;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)removeWarmTimeWith:(NSInteger)index{
    NSInteger timeInterVal = [[[_warmTimeArray objectAtIndex:index] objectForKey:kWarmTimeValue] integerValue];
    [self cancelLocalNotificationWith:timeInterVal];
    [_warmTimeArray removeObjectAtIndex:index];
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
    [_warmTimeDic setValue:[NSNumber numberWithInteger:_getupTime] forKey:kGetupTime];
    [_warmTimeDic setValue:_warmTimeArray forKey:kWaterWarmTime];
    [_warmTimeDic setValue:_warmTimeStateArray forKey:[DateHelper getDayStringWith:0]];
    
    [[NSUserDefaults standardUserDefaults] setValue:_warmTimeDic forKey:kWaterWarmData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sortWarmTimeArray {
    _warmTimeArray = [NSMutableArray arrayWithArray:[_warmTimeArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
    [_warmTimeArray addObject:dic];
    [self addLocalNotificationWith:timeInterval];
    [self sortWarmTimeArray];
    [self refreshWarmTimeState];
}

- (void)replaceWarmTimeWith:(NSInteger)timeInterval atIndex:(NSInteger)index {
    BOOL isOn = [[[_warmTimeArray objectAtIndex:index] objectForKey:kWarmTimeIsOn] boolValue];
    NSInteger oldTimeInterval = [[[_warmTimeArray objectAtIndex:index] objectForKey:kWarmTimeValue] integerValue];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval],kWarmTimeValue,[NSNumber numberWithBool:isOn],kWarmTimeIsOn, nil];
    if (isOn) {
        [self cancelLocalNotificationWith:oldTimeInterval];
    }
    [_warmTimeArray replaceObjectAtIndex:index withObject:dic];
    if (isOn) {
        [self addLocalNotificationWith:timeInterval];
    }
    [self sortWarmTimeArray];
}

- (void)replaceWarmTimeOnWith:(BOOL)isOn atIndex:(NSInteger)index {
    NSInteger timeInterval =  [[[_warmTimeArray objectAtIndex:index] objectForKey:kWarmTimeValue] integerValue];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:timeInterval],kWarmTimeValue,[NSNumber numberWithBool:isOn],kWarmTimeIsOn, nil];
    [_warmTimeArray replaceObjectAtIndex:index withObject:dic];
    if (isOn) {
        [self addLocalNotificationWith:timeInterval];
    } else {
        [self cancelLocalNotificationWith:timeInterval];
    }
    [self refreshWarmTimeState];
}

- (void)setGetupTime:(NSInteger)getupTime {
    _getupTime = getupTime;
    if (!_isCustome) {
        [self refreshWarmTimeState];
    }
}

- (void)setIsCustome:(BOOL)isCustome {
    _isCustome = isCustome;
    [self refreshWarmTimeState];
    if (_isCustome) {
        for (NSInteger i = 0; i < [_warmTimeArray count]; i++) {
            NSInteger timeInterval =  [[[_warmTimeArray objectAtIndex:i] objectForKey:kWarmTimeValue] integerValue];
            [self cancelLocalNotificationWith:timeInterval];
        }
        
        for (int i = 0; i < kWarmCount; i++) {
            [self addLocalNotificationWith:_getupTime + (i+1)*2*3600];
        }
    } else {
        for (NSInteger i = 0; i < [_warmTimeArray count]; i++) {
            NSInteger timeInterval =  [[[_warmTimeArray objectAtIndex:i] objectForKey:kWarmTimeValue] integerValue];
            [self addLocalNotificationWith:timeInterval];
        }
        
        for (int i = 0; i < kWarmCount; i++) {
            [self cancelLocalNotificationWith:_getupTime + (i+1)*2*3600];
        }
    }
}

- (void)setIsOpenWarm:(BOOL)isOpenWarm {
    _isOpenWarm = isOpenWarm;
    if (_isOpenWarm) {
        if (_isCustome) {
            for (int i = 0; i < kWarmCount; i++) {
                [self addLocalNotificationWith:_getupTime + (i+1)*2*3600];
            }
        } else {
            for (NSInteger i = 0; i < [_warmTimeArray count]; i++) {
                NSInteger timeInterval =  [[[_warmTimeArray objectAtIndex:i] objectForKey:kWarmTimeValue] integerValue];
                [self addLocalNotificationWith:timeInterval];
            }
        }
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (NSArray *)getWarmTimes {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (!_isCustome) {
        for (int i = 0; i < kWarmCount; i++) {
            NSUInteger time = _getupTime + (i+1)*_timeInterval;
            if (time <= 24*60*60) {
                [array addObject:[NSNumber numberWithInteger:time]];
            }
        }
    } else {
        for (NSDictionary *dic in _warmTimeArray) {
            BOOL isOn = [[dic objectForKey:kWarmTimeIsOn] boolValue];
            if (isOn) {
                [array addObject:[NSNumber numberWithInteger:[[dic objectForKey:kWarmTimeValue] integerValue]]];
            }
        }
    }
    return array;
}

@end