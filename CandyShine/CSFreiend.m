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
        _name = [dic objectForKey:@"custom_name"];
        _sorce = [[dic objectForKey:@"score"] integerValue];
        _uid = [dic objectForKey:@"uid"];
        NSString *str = [dic objectForKey:@"portrait"];
        if (![str isKindOfClass:[NSNull class]]) {
            _portrait = [NSString stringWithFormat:@"%@%@",kBaseURL,str];
        }
    }
    return self;
}

@end
