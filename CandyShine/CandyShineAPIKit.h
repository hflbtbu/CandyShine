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
@property (nonatomic, retain) NSString *email;
@property (nonatomic, assign) CSLoginType loginType;
@property (nonatomic, retain) AFHTTPRequestOperationManager *requestOperationManager;



+ (CandyShineAPIKit *)sharedAPIKit;

- (void)requestRegisterSuccess:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestLogInSuccess:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestFriednListSuccess:(SuccessArrayBlock)success fail:(FailBlock)fail;

- (void)requestModifyPortraitWithImage:(NSData *)image Success:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestSearchFriednListWithKeyword:(NSString *)keyword Success:(SuccessArrayBlock)success fail:(FailBlock)fail;

- (void)requestAddFeiendWithUserID:(NSString *)uid Success:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestModifyUserNameWithName:(NSString *)name Success:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestModifyPassWordWithNewPsw:(NSString *)newPsw  oldPsw:(NSString *)oldPsw  Success:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestNewsWithDate:(NSString *)date Success:(SuccessBlock)success fail:(FailBlock)fail;

- (void)requestFindPasswordWithEmail:(NSString *)email Success:(SuccessBlock)success fail:(FailBlock)fail;


@end
