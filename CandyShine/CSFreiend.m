//
//  CSFreiend.m
//  CandyShine
//
//  Created by huangfulei on 14-2-25.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CSFreiend.h"

@implementation CSFreiend

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _name = [dic objectForKey:@"name"];
        _sorce = [[dic objectForKey:@"score"] integerValue];
    }
    return self;
}

@end
