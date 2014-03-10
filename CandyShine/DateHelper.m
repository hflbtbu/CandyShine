//
//  DateHelper.m
//  CandyShine
//
//  Created by huangfulei on 14-2-11.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSDate *)getDayBegainWith:(int)day {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    return [NSDate dateWithTimeInterval:-day*24*60*60 sinceDate:date];
}

+ (NSDate *)getDayEndWith:(int)day {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    return [NSDate dateWithTimeInterval:-day*24*60*60 sinceDate:date];
}

+ (NSString *)getYYMMDDString:(NSInteger)day {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getDayBegainWith:day]];
    return [NSString stringWithFormat:@"%d%02d%02d",components.year,components.month,components.day];
}

+ (NSString *)getDayStringWith:(int)day {
    if (day == 0) {
        return @"今天";
    }
    if (day == 1) {
        return @"昨天";
    }
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getDayBegainWith:day]];
    return [NSString stringWithFormat:@"%d月%d日",components.month,components.day];
}


+ (NSDate *)getWeekBegainWith:(int)week {
    unsigned int flags = kCFCalendarUnitWeekday;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    int weekDay = components.weekday;
    NSDate *date = [DateHelper getDayBegainWith:weekDay -2 + week*7];
    return date;
}

+ (NSDate *)getWeekEndWith:(int)week {
    unsigned int flags = kCFCalendarUnitWeekday;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date]];
    int weekDay = components.weekday;
    NSDate *date = [DateHelper getDayEndWith:weekDay - 8 + week*7];
    return date;
}

+ (NSString *)getWeekStringWith:(int)week {
    unsigned int flags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *begainComponents = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getWeekBegainWith:week]];
    
    NSDateComponents *endComponents = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getWeekEndWith:week]];
    
    return [NSString stringWithFormat:@"%d月%d日~%d月%d日",begainComponents.month,begainComponents.day,endComponents.month,endComponents.day];
}

+ (NSInteger)getDaysBetween:(NSDate *)startDate and:(NSDate *)endDate {
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:endDate  toDate:[DateHelper getDayBegainWith:-3]  options:0];
    return [comps day];
}

+ (NSString *)getDayWithIndex:(NSInteger)index {
    unsigned int flags = NSDayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getDayBegainWith:index]];

    return [NSString stringWithFormat:@"%02d",components.day];
}

+ (NSString *)getMothWithIndex:(NSInteger)index {
    unsigned int flags = NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getDayBegainWith:index]];
    
    return [NSString stringWithFormat:@"%@ %d",[DateHelper getEnglishMonthWith:components.month],components.year];
}

+ (NSString *)getYearWithIndex:(NSInteger)index {
    unsigned int flags = NSYearCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[DateHelper getDayBegainWith:index]];
    return [NSString stringWithFormat:@"%d",components.year];
}

+ (NSString *)getEnglishMonthWith:(NSInteger)moth {
    NSArray *moths = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    NSString *mothString = [moths objectAtIndex:moth];
    return mothString;
}

@end
