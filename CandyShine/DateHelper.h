//
//  DateHelper.h
//  CandyShine
//
//  Created by huangfulei on 14-2-11.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate *)getDayBegainWith:(int)day;

+ (NSDate *)getDayEndWith:(int)day;

+ (NSString *)getDayStringWith:(int)day;

+ (NSDate *)getWeekBegainWith:(int)week;

+ (NSDate *)getWeekEndWith:(int)week;

+ (NSString *)getWeekStringWith:(int)week;

+ (NSInteger)getDaysBetween:(NSDate *)startDate and:(NSDate *)endDate;

@end
