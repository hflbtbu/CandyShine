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

@interface CSDataManager : NSObject

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *portrait;
@property (nonatomic, assign) CSLoginType loginType;
@property (nonatomic, assign) NSInteger totalDays;
@property (nonatomic, assign) BOOL isReachable;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+ (CSDataManager *)sharedInstace;

- (Sport *)insertSportItemWithBlock:(void (^)(Sport *))settingBlock;

- (NSArray *)fetchSportItemsByDay:(NSInteger)day;

- (BOOL)saveCoreData;

- (void)saveUserData;

- (void)savePortrait:(NSData *)data;

- (NSData *)readPortrait;

@end
