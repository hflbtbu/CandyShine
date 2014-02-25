//
//  CandyShineAPIKit.h
//  CandyShine
//
//  Created by huangfulei on 14-2-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SuccessBlock)(NSDictionary *result);
typedef void(^FailBlock)(NSError *error);

@interface CandyShineAPIKit : NSObject

+ (CandyShineAPIKit *)sharedAPIKit;

- (void)requestRegisterWithUserName:(NSString *)userName
                           passWord:(NSString *)passWord
                               type:(CSLoginType)type
                            success:(SuccessBlock)success
                               fail:(FailBlock)fail;

@end
