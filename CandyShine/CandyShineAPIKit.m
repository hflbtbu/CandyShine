//
//  CandyShineAPIKit.m
//  CandyShine
//
//  Created by huangfulei on 14-2-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CandyShineAPIKit.h"
#import "CSFreiend.h"

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


- (void)requestRegisterSuccess:(SuccessBlock)success fail:(FailBlock)fail {
    NSMutableString *parameterString = [NSMutableString stringWithCapacity:0];
    [parameterString appendString:@"user="];
    [parameterString appendString:[self encodeToPercentEscapeString:_userName]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"type="];
    [parameterString appendString:[self encodeToPercentEscapeString:[NSString stringWithFormat:@"%d",_loginType]]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"pwd="];
    [parameterString appendString:[self encodeToPercentEscapeString:_passWord]];
    if (_loginType == CSLoginDefault) {
        [parameterString appendString:@"&"];
        [parameterString appendString:@"email="];
        [parameterString appendString:[self encodeToPercentEscapeString:_email]];
    }

    [_requestOperationManager GET:@"/register" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======Register======");
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)requestLogInSuccess:(SuccessBlock)success fail:(FailBlock)fail {
    NSMutableString *parameterString = [NSMutableString stringWithCapacity:0];
    [parameterString appendString:@"user="];
    [parameterString appendString:[self encodeToPercentEscapeString:_userName]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"type="];
    [parameterString appendString:[self encodeToPercentEscapeString:[NSString stringWithFormat:@"%d",_loginType]]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"pwd="];
    [parameterString appendString:[self encodeToPercentEscapeString:_passWord]];
    [_requestOperationManager GET:@"/authentication" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======LogIn======");
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)requestFriednListSuccess:(SuccessArrayBlock)success fail:(FailBlock)fail {
    [_requestOperationManager GET:@"/friend_list" parameters:@{@"user": @"lin"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        NSMutableArray *friendArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in [responseObject objectForKey:@"friend_list"]) {
            CSFreiend *fried = [[CSFreiend alloc] initWithDic:dic];
            [friendArray addObject:fried];
        }
        success(friendArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (NSString *)encryptorStringWithAES:(NSString *)str {
    NSMutableString *string = [NSMutableString stringWithString:str];
    int count = 16 - [string length]%16;
    for (int i = 0; i < count; i++) {
        [string appendString:@"&"];
    }
    NSString *encryptedString = [FBEncryptorAES encryptString:string keyString:kAESKey];
    return encryptedString;
}


- (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    NSString* outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       
                                                                                       NULL, /* allocator */
                                                                                       (__bridge CFStringRef)input,
                                                                                       NULL, /* charactersToLeaveUnescaped */
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                       kCFStringEncodingUTF8);
    return outputStr;
}

@end
