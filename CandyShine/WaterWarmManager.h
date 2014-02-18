//
//  WaterWarmManager.h
//  CandyShine
//
//  Created by huangfulei on 14-2-18.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kWaterWarmData      @"WaterWarmData"

#define kWaterWarmTime      @"WaterWarmTime"
#define kWarmTimeValue      @"WarmTimeValue"
#define kWarmTimeIsOn       @"WarmTimeIsOn"

#define kGetupTime          @"GetupTime"
#define kIsCustome          @"IsCustome"
#define kWarmInterval       @"WarmInterval"
#define kIsOpenWarm         @"IsOpenWarm"

#define kWarmCount          3

#import <Foundation/Foundation.h>

@interface WaterWarmManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *warmTimeDic;

@property (nonatomic, assign) NSInteger getupTime;
@property (nonatomic, assign) NSInteger timeInterval;
@property (nonatomic, assign) BOOL isCustome;
@property (nonatomic, assign) BOOL isOpenWarm;
@property (nonatomic, retain) NSMutableArray *warmTimeArray;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;



+ (WaterWarmManager *)shared;

- (void)saveData;

- (void)addLocalNotificationWith:(NSInteger)timeInterval;

- (void)cancelLocalNotificationWith:(NSInteger)timeInterval;

- (void)removeWarmTimeWith:(NSInteger)index;

- (void)replaceWarmTimeWith:(NSInteger)timeInterval atIndex:(NSInteger)index;

- (void)replaceWarmTimeOnWith:(BOOL)isOn atIndex:(NSInteger)index;

- (void)addWarmTimeWith:(NSInteger)timeInterval;

- (NSArray *)getWarmTime;

@end
