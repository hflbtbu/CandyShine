//
//  CSDataManager.h
//  CandyShine
//
//  Created by huangfulei on 14-2-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSDataManager : NSObject

@property (nonatomic, assign) BOOL isLogin;

+ (CSDataManager *)sharedInstace;

@end
