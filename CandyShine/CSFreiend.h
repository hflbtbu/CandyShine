//
//  CSFreiend.h
//  CandyShine
//
//  Created by huangfulei on 14-2-25.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFreiend : NSObject

@property (nonatomic, retain)NSString *name;
@property (nonatomic, assign)NSInteger sorce;
@property (nonatomic, retain)NSString *portrait;
@property (nonatomic, retain)NSString *uid;

- (id)initWithDic:(NSDictionary *)dic;

@end
