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
#import "Sleep.h"
#import "Ble4Util.h"

typedef void(^ConnectStateBlock)(CSConnectState state);
typedef void(^ReadDataBlock)();
typedef void(^CallBackBlock)();

@interface CSDataManager : NSObject <Ble4UtilDelegate,Ble4PeripheralDelegate>

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *portrait;
@property (nonatomic, assign) CSLoginType loginType;
@property (nonatomic, assign) NSInteger totalDays;
@property (nonatomic,assign) NSInteger totalWeeks;
@property (nonatomic, assign) BOOL isReachable;
@property (nonatomic, assign) NSInteger userGogal;

@property (nonatomic, retain) Ble4Util *ble4Util;
@property (nonatomic, retain) NSString *udid;
@property (nonatomic, assign) BOOL isConneting;
@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, assign) BOOL isDongingConnect;
@property (nonatomic, retain) NSDate *readDataDate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+ (CSDataManager *)sharedInstace;

- (Sport *)insertSportItemWithBlock:(void (^)(Sport *))settingBlock;

- (Sleep *)insertSleepItemWithBlock:(void (^)(Sleep *))settingBlock;

- (NSArray *)fetchSportItemsByDay:(NSInteger)day;

- (NSArray *)fetchSportItemsByWeek:(NSInteger)week;

- (NSArray *)fetchSportItemsFromeDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSArray *)fetchSleepItemsByDay:(NSInteger)day;

- (News *)insertNewsWithBlock:(void (^)(News *))settingBlock;

- (News *)fetchNewsByDate:(NSString *)date;

- (BOOL)saveCoreData;

- (void)saveUserData;

- (void)savePortrait:(NSData *)data;

- (void)autoSyncData;

- (NSData *)readPortrait;

- (void)scanDevice;

- (void)connectDeviceWithBlock:(ConnectStateBlock)block;

- (void)synchronizationDeviceDataWithBlock:(ReadDataBlock)block;

-(void)setSleepTimeWithHour:(NSInteger)hour andMin:(NSInteger)min block:(CallBackBlock)block;

-(void)setSetSportsPlanWithType:(BleSportsPlanType)type andGogal:(NSInteger)gogal block:(CallBackBlock)block;

-(void)setDrinkWaterInterval:(NSInteger)interval block:(CallBackBlock)block;

@end
