//
//  CandyShineAPIKit.m
//  CandyShine
//
//  Created by huangfulei on 14-2-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CandyShineAPIKit.h"

@interface CandyShineAPIKit ()
{
    AFHTTPRequestOperationManager *_requestOperationManager;

}
@end

@implementation CandyShineAPIKit

+ (CandyShineAPIKit *)sharedAPIKit {
    static CandyShineAPIKit *_sharedAPIKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPIKit = [[CandyShineAPIKit alloc] init];
    });
    return _sharedAPIKit;
}

- (id)init {
    self = [super init];
    if (self) {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        _requestOperationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSOperationQueue *operationQueue = _requestOperationManager.operationQueue;
        [_requestOperationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"AFNetworkReachabilityStatusNotReachable");
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
    }
    return self;
}


- (void)requestRegisterWithUserName:(NSString *)userName passWord:(NSString *)passWord type:(CSLoginType)type success:(SuccessBlock)success fail:(FailBlock)fail {
    [_requestOperationManager GET:@"/register" parameters:@{@"luser": userName,@"pwd":passWord} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

@end
