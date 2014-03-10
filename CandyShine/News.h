//
//  News.h
//  CandyShine
//
//  Created by huangfulei on 14-3-10.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * image;

@end
