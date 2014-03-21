//
//  CSDataManager.h
//  CandyShine
//
//  Created by huangfulei on 14-2-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#define kUserIsLogin        @"UserIsLogin"
#define kUserName           @"UserName"
#define kUserId             @"UserId"
#define kUserPortrait       @"UserPortrait"


#import <Foundation/Foundation.h>
#import "Sport.h"
#import "News.h"
#import "Ble4Util.h"

typedef void(^ConnectStateBlock)(CSConnectState);

@interface CSDataManager : NSObject <Ble4UtilDelegate,Ble4PeripheralDelegate>

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *portrait;
@property (nonatomic, assign) CSLoginType loginType;
@property (nonatomic, assign) NSInteger totalDays;
@property (nonatomic, assign) BOOL isReachable;

@property (nonatomic, retain) Ble4Util *ble4Util;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+ (CSDataManager *)sharedInstace;

- (Sport *)insertSportItemWithBlock:(void (^)(Sport *))settingBlock;

- (NSArray *)fetchSportItemsByDay:(NSInteger)day;

- (News *)insertNewsWithBlock:(void (^)(News *))settingBlock;

- (News *)fetchNewsByDate:(NSString *)date;

- (BOOL)saveCoreData;

- (void)saveUserData;

- (void)savePortrait:(NSData *)data;

- (NSData *)readPortrait;

- (void)scanDeviceWithBlock:(void (^) (CSConnectState))state;

@end
