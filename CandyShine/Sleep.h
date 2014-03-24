//
//  Sleep.h
//  CandyShine
//
//  Created by huangfulei on 14-3-23.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sleep : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * value;

@end
