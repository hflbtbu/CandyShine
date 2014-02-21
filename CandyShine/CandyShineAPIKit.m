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


- (void)registerUser {
    [_requestOperationManager GET:@"/friend_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
//    [_requestOperationManager POST:@"/authentication" parameters:@{@"pwd": @"123456",@"user":@"lintao"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

@end
