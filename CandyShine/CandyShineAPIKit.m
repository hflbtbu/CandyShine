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
    }
    return self;
}


- (void)requestRegisterSuccess:(SuccessBlock)success fail:(FailBlock)fail {
    NSMutableString *parameterString = [NSMutableString stringWithCapacity:0];
    [parameterString appendString:@"user="];
    [parameterString appendString:[self encodeToPercentEscapeString:_email]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"type="];
    [parameterString appendString:[self encodeToPercentEscapeString:[NSString stringWithFormat:@"%d",_loginType]]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"pwd="];
    [parameterString appendString:[self encodeToPercentEscapeString:_passWord]];
    [parameterString appendString:@"&"];
    [parameterString appendString:@"custom_name="];
    [parameterString appendString:[self encodeToPercentEscapeString:_userName]];
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
    [parameterString appendString:[self encodeToPercentEscapeString:_email]];
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
    [_requestOperationManager GET:@"/friend_list" parameters:@{@"encrypt_param":[self encryptorStringWithAES:[NSString stringWithFormat:@"uid=%@",[CSDataManager sharedInstace].userId]]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======FriendList======\n%@",responseObject);
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

- (void)requestModifyPortraitWithImage:(NSData *)image Success:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *uid = [CSDataManager sharedInstace].userId;
    [_requestOperationManager POST:[NSString stringWithFormat:@"image?encrypt_param=%@",[self encryptorStringWithAES:[NSString stringWithFormat:@"action=upload&type=portrait&uid=%@",uid]]] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:image name:@"portrait" fileName:@"portrait" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======UploadPortrait======");
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)requestSearchFriednListWithKeyword:(NSString *)keyword Success:(SuccessArrayBlock)success fail:(FailBlock)fail; {
    NSString *parameterString = [NSString stringWithFormat:@"query=%@",[self encodeToPercentEscapeString:keyword]];
    [_requestOperationManager GET:@"/friend_list" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======SearchFriendList======\n%@",responseObject);
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

- (void)requestAddFeiendWithUserID:(NSString *)uid Success:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *parameterString = [NSString stringWithFormat:@"uid=%@&friend_id=%@",[CSDataManager sharedInstace].userId,uid];
    [_requestOperationManager GET:@"add_friend" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======AddFeiend======\n%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)requestModifyUserNameWithName:(NSString *)name Success:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *parameterString = [NSString stringWithFormat:@"uid=%@&modify_field=custom_name&custom_name=%@",[CSDataManager sharedInstace].userId,[self encodeToPercentEscapeString:name]];
    [_requestOperationManager GET:@"user_modify" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======ModifyUserName======\n%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)requestModifyPassWordWithNewPsw:(NSString *)newPsw  oldPsw:(NSString *)oldPsw  Success:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *parameterString = [NSString stringWithFormat:@"uid=%@&modify_field=pwd&new_pwd=%@&old_pwd=%@",[CSDataManager sharedInstace].userId,[self encodeToPercentEscapeString:newPsw],[self encodeToPercentEscapeString:oldPsw]];
    [_requestOperationManager GET:@"user_modify" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======ModifyPassWord======\n%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error);
    }];
}

- (void)requestNewsWithDate:(NSString *)date Success:(SuccessBlock)success fail:(FailBlock)fail {
    NSString *parameterString = [NSString stringWithFormat:@"type=daily_message&date=%@",date];
    [_requestOperationManager GET:@"system_message" parameters:@{@"encrypt_param":[self encryptorStringWithAES:parameterString]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======News======\n%@",responseObject);
        success(responseObject);
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
