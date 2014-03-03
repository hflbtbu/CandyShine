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
typedef void(^SuccessArrayBlock)(NSMutableArray *result);

@interface CandyShineAPIKit : NSObject

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *passWord;
@property (nonatomic, assign) CSLoginType loginType;


+ (CandyShineAPIKit *)sharedAPIKit;

- (void)requestRegisterSuccess:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestFriednListSuccess:(SuccessArrayBlock)success fail:(FailBlock)fail;

@end
