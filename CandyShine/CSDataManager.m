
//
//  CSDataManager.m
//  CandyShine
//
//  Created by huangfulei on 14-2-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CSDataManager.h"
#import "WaterWarmManager.h"

@interface CSDataManager ()
{
    NSTimer *_timer;
    ConnectStateBlock _connectStateBlock;
    ReadDataBlock _readDataBlock;
    CallBackBlock _callBackBlock;
}
@end

@implementation CSDataManager 

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CSDataManager *)sharedInstace {
    static CSDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CSDataManager alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        _ble4Util = [Ble4Util shareBleUtilWithTarget:self];
        _udid = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDeviceID];
        _isConneting = NO;
        _isDongingConnect = NO;
        _isReading = NO;
        _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserIsLogin];
        
        _readDataDate = [[NSUserDefaults standardUserDefaults] objectForKey:kReadDateDate];
        
        _userGogal = [[NSUserDefaults standardUserDefaults] integerForKey:kUserGogal];
        if (_userGogal  == 0) {
            [[NSUserDefaults standardUserDefaults] setInteger:2000 forKey:kUserGogal];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (_isLogin) {
            _userName = [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
            _userId = [[NSUserDefaults standardUserDefaults] stringForKey:kUserId];
            _portrait = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPortrait];
        }
        _totalDays = [DateHelper getDaysBetween:[[NSUserDefaults standardUserDefaults] objectForKey:kFirstLaunchDate] and:[NSDate date]];
        _totalWeeks = [DateHelper getWeeksBetween:[[NSUserDefaults standardUserDefaults] objectForKey:kFirstLaunchDate] and:[NSDate date]];
        
        AFHTTPRequestOperationManager *requestOperationManager = [CandyShineAPIKit sharedAPIKit].requestOperationManager;
        NSOperationQueue *operationQueue = requestOperationManager.operationQueue;
        [requestOperationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    _isReachable = YES;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    _isReachable = YES;
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"AFNetworkReachabilityStatusNotReachable");
                    _isReachable = NO;
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
        [requestOperationManager.reachabilityManager startMonitoring];
    }
    return self;
}

- (Sport *)insertSportItemWithBlock:(void (^)(Sport *))settingBlock; {
    Sport *data = [NSEntityDescription insertNewObjectForEntityForName:@"Sport" inManagedObjectContext:self.managedObjectContext];
    settingBlock(data);
    return data;
}

- (NSArray *)fetchSportItemsByDay:(NSInteger)day {
    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] initWithEntityName:@"Sport"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSDate *begain = [DateHelper getDayBegainWith:day];
    NSDate *end = [DateHelper getDayEndWith:day];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"date between {%@, %@}",begain,end];
    fetchRequset.sortDescriptors = @[sortDescriptor];
    fetchRequset.predicate = predicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequset error:&error];
    
    if (error == nil) {
        return results;
    } else {
        NSLog(@"FetchSportItemsByDay Failed");
        return nil;
    }
}

- (NSArray *)fetchSportItemsFromeDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] initWithEntityName:@"Sport"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"date between {%@, %@}",fromDate,toDate];
    fetchRequset.sortDescriptors = @[sortDescriptor];
    fetchRequset.predicate = predicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequset error:&error];
    
    if (error == nil) {
        return results;
    } else {
        NSLog(@"FetchSportItemsByDay Failed");
        return nil;
    }
}

- (NSArray *)fetchSportItemsByWeek:(NSInteger)week {
    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] initWithEntityName:@"Sport"];
    NSError *error;
    NSDate *weekBegain = [DateHelper getWeekBegainWith:week];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < 7; i++) {
        NSDate *begain = [weekBegain dateByAddingTimeInterval:24*60*60*i];
        NSDate *end = [weekBegain dateByAddingTimeInterval:24*60*60*(i+1)];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"date between {%@, %@}",begain,end];
        fetchRequset.predicate = predicate;
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequset error:&error];
        [array addObject:results];
    }
    
    if (error == nil) {
        return array;
    } else {
        NSLog(@"FetchSportItemsByDay Failed");
        return nil;
    }
}

- (Sleep *)insertSleepItemWithBlock:(void (^)(Sleep *))settingBlock {
    Sleep *data = [NSEntityDescription insertNewObjectForEntityForName:@"Sleep" inManagedObjectContext:self.managedObjectContext];
    settingBlock(data);
    return data;
}

- (NSArray *)fetchSleepItemsByDay:(NSInteger)day {
    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] initWithEntityName:@"Sleep"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSDate *begain = [NSDate dateWithTimeInterval:[WaterWarmManager shared].sleepTime sinceDate:[DateHelper getDayBegainWith:day + 1]];
    NSDate *end = [NSDate dateWithTimeInterval:[WaterWarmManager shared].sleepTime sinceDate:[DateHelper getDayBegainWith:day]];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"date between {%@, %@}",begain,end];
    fetchRequset.sortDescriptors = @[sortDescriptor];
    fetchRequset.predicate = predicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequset error:&error];
    
    if (error == nil) {
        return results;
    } else {
        NSLog(@"FetchSportItemsByDay Failed");
        return nil;
    }

}

- (void)saveUserData {
    [[NSUserDefaults standardUserDefaults] setBool:_isLogin forKey:kUserIsLogin];
    if (_isLogin) {
        [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:kUserName];
        [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:kUserId];
        [[NSUserDefaults standardUserDefaults] setObject:_portrait forKey:kUserPortrait];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_readDataDate forKey:kReadDateDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)saveCoreData {
    BOOL result = NO;
    if (![self.managedObjectContext hasChanges]) {
        return YES;
    }
    NSError *error;
    result = [self.managedObjectContext save:&error];
    if (!result) {
        NSLog(@"%s,error:%@",__FUNCTION__,error);
    }
    return result;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] initWithEntityName:@"CandyData"];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequset managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"date" cacheName:nil];
    [_fetchedResultsController performFetch:nil];
    return _fetchedResultsController;
}

- (News *)insertNewsWithBlock:(void (^)(News *))settingBlock {
    News *data = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:self.managedObjectContext];
    settingBlock(data);
    return data;
}

- (News *)fetchNewsByDate:(NSString *)date {
    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] initWithEntityName:@"News"];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"date = %@",date];
    fetchRequset.predicate = predicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequset error:&error];
    if (error == nil) {
        if (results.count != 0) {
            News *news = [results objectAtIndex:0];
            return news;
        } else {
            return nil;
        }
    } else {
        NSLog(@"FetchSportItemsByDay Failed");
        return nil;
    }
}

- (void)savePortrait:(NSData *)data {
    [self saveData:data directory:@"Portrait" fileName:@"Portrait"];
}

- (NSData *)readPortrait {
    NSString *path = [self getPathWithDirectory:@"Portrait" fileName:@"Portrait"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (void)saveData:(NSData *)data directory:(NSString *)directory fileName:(NSString *)fileName {
    NSString *path = [self getPathWithDirectory:directory fileName:fileName];
    [data writeToFile:path atomically:YES];
}

- (NSString *)getPathWithDirectory:(NSString *)directory fileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [paths objectAtIndex:0];
    NSString *directoryPath = [path stringByAppendingPathComponent:directory];
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",directory,fileName]];
}

- (void)scanDevice {
    if([self startConnectionHead])
    {
        _isDongingConnect = YES;
        _timer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanDeviceTimeoutHandler:) userInfo:nil repeats:NO];
        
        [_ble4Util stopScanBle];
        
        [_ble4Util startScanBle];
    }
}

- (void)scanDeviceTimeoutHandler:(NSTimer *)timer {
    [_timer invalidate];
    _timer = nil;
    [_ble4Util stopScanBle];
    _isDongingConnect = NO;
    _connectStateBlock(CSConnectUnfound);
}

-(BOOL)startConnectionHead
{
    NSArray *stateArray = [NSArray arrayWithObjects:@"未发现蓝牙4.0设备"
                           ,@"请重设蓝牙设备"
                           ,@"硬件不支持蓝牙4.0"
                           ,@"app未被授权使用BLE4.0"
                           ,@"请在设置中开启蓝牙功能", nil];
    
    if ([_ble4Util cbCentralManagerState] == CBCentralManagerStatePoweredOn)
    {
        return YES;
    }
    else
    {
        UIAlertView *bleAlert = [[UIAlertView alloc] initWithTitle:nil message:stateArray[[_ble4Util cbCentralManagerState]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [bleAlert show];
        return NO;
    }
}

-(void)ble4Util:(id)ble4Util didDiscoverPeripheralWithName:(NSString *)name andUDID:(NSString *)udid {
    [_timer invalidate];
    _timer = nil;
    
    if (_udid == nil || _udid.length == 0) {
        _udid = udid;
        [[NSUserDefaults standardUserDefaults] setObject:_udid forKey:kUserDeviceID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([_udid isEqualToString:udid]) {
     [_ble4Util stopScanBle];
     [_ble4Util connectPeripheralWithUDID:_udid];
    }
}

-(void)ble4UtilDidConnect:(id)ble4Util withUDID:(NSString *)udid {
}

- (void)ble4PeripheralDidDiscoverCharacteristics:(id)ble4Peripheral {
    [_ble4Util cmdDeviceTimeWithUDID:_udid];
}

/** 获取设备时间回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithDeviceTime:(NSDate *)date andWeek:(NSInteger)week {
    if (date == nil) {
        [_ble4Util cmdUpdateTimeWithUDID:_udid];

    } else {
        _isConneting = YES;
        _isDongingConnect = NO;
        _connectStateBlock(CSConnectfound);
    }
}

- (void)setSleepTimeWithHour:(NSInteger)hour andMin:(NSInteger)min block:(CallBackBlock)block {
    _callBackBlock = block;
    [_ble4Util cmdSetSleepTimeWithHour:hour andMin:min andUDID:_udid];
}

-(void)setSetSportsPlanWithType:(BleSportsPlanType)type andGogal:(NSInteger)gogal block:(CallBackBlock)block {
    _callBackBlock = block;
    [_ble4Util cmdSetSportsPlanWithType:type andTarget:gogal andUDID:_udid];
}


- (void)ble4Peripheral:(id)ble4Peripheral callBackWithMark:(Ble4CallBackMark)mark
{
    switch (mark) {
        case Ble4CallBackMarkShakeHands:
            //_lblResponse.text=@"握手成功!";
            break;
        case Ble4CallBackMarkUpdateTime:
            //_lblResponse.text=@"更新设备时间成功!";
            _isConneting = YES;
            _isDongingConnect = NO;
            _connectStateBlock(CSConnectfound);
            break;
        case Ble4CallBackMarkSetSportsPlan:
            //_lblResponse.text=@"设置运动计划成功!";
            _callBackBlock();
            break;
        case Ble4CallBackMarkPairLovers:
            //_lblResponse.text=@"情侣配对提示!";
            break;
        case Ble4CallBackMarkDrinkWater:
            //_lblResponse.text=@"喝水提示!";
            break;
        case Ble4CallBackMarkSetSleepTime:
            //_lblResponse.text=@"设置睡眠模式时间成功!";
            _callBackBlock();
            break;
        case Ble4CallBackMarkSetDrinkWaterInterval:
            //_lblResponse.text=@"设置喝水提示间隔时间成功!";
            break;
        default:
            break;
    }
}


- (void)ble4UtilDidDisconnect:(id)ble4Util withUDID:(NSString *)udid {
    _isConneting = NO;
}

- (void)ble4Util:(id)ble4Util didUpdateState:(CBCentralManagerState)state {
    if (state == CBCentralManagerStatePoweredOff) {
        _isConneting = NO;
    } else if (state == CBCentralManagerStatePoweredOn) {
        //[self autoSyncData];
    }
}

- (void)connectDeviceWithBlock:(ConnectStateBlock)block {
    _connectStateBlock = block;
    [self scanDevice];
}

- (void)synchronizationDeviceDataWithBlock:(ReadDataBlock)block {
    if (_udid != nil || _udid.length > 0) {
        _readDataBlock = block;
        _isReading = YES;
        [_ble4Util cmdReadDataWithUDID:_udid];
    }
}

/** 读取数据回调 */
- (void)ble4Peripheral:(id)ble4Peripheral callBackWithSportsData:(NSArray *)data
{
    NSDate *endDate;
    BOOL hasData = NO;
    if(data && data.count>0)
    {
        hasData = YES;
        for(int i=0;i<data.count;i++)
        {
            BleSportsDataList *dataList=[data objectAtIndex:i];
            if(dataList.listData.count == 0)continue;
            BleSportsDataType sportsDataType=dataList.dataType;
            NSDate *startDate = dataList.startTime;
            endDate = dataList.endTime;
            NSInteger count = [endDate timeIntervalSinceDate:startDate]/300;
            count = count < dataList.listData.count ? count :dataList.listData.count;
            for(int j=0;j<dataList.listData.count;j++)
            {
                if(sportsDataType==BleSportsDataTypeSports)
                {
                    BleSportsData *sportsData=[dataList.listData objectAtIndex:j];
                    [self insertSportItemWithBlock:^(Sport *item) {
                        item.date =  [NSDate dateWithTimeInterval:j*300 sinceDate:startDate];
                        item.value = [NSNumber numberWithInteger:sportsData.calories];
                    }];
//                    [self insertSleepItemWithBlock:^(Sleep *item) {
//                        item.date = [NSDate dateWithTimeInterval:j*300 sinceDate:startDate];
//                        item.value = [NSNumber numberWithInteger:sportsData.calories];
//                    }];
                }
                else if(sportsDataType==BleSportsDataTypeSleep)
                {
                    NSLog(@"====sleep data==== \n%d",[[dataList.listData objectAtIndex:j] integerValue]);
                    [self insertSportItemWithBlock:^(Sport *item) {
                        item.date = [NSDate dateWithTimeInterval:j*300 sinceDate:startDate];
                        item.value = [NSNumber numberWithInteger:0];
                    }];
                    [self insertSleepItemWithBlock:^(Sleep *item) {
                        item.date = [NSDate dateWithTimeInterval:j*300 sinceDate:startDate];
                        item.value = [dataList.listData objectAtIndex:j];
                    }];
                }
            }
        }
        [self saveCoreData];
    }
    _isReading = NO;
    _readDataBlock();
    if (hasData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReadDeviceDataFinishNotification object:endDate];
    }
}

- (void)autoSyncData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_ble4Util.cbCentralManagerState == CBCentralManagerStatePoweredOn) {
            BOOL hasSynt = [[NSUserDefaults standardUserDefaults] boolForKey:[DateHelper getYYMMDDString:0]];
            if (!hasSynt) {
                if ([[NSDate date] timeIntervalSinceDate:[DateHelper getDayBegainWith:0]] >= 10*60*60) {
                    if (!_isReading) {
                        if (_isConneting) {
                            [self synchronizationDeviceDataWithBlock:^{
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:[DateHelper getYYMMDDString:1]];
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[DateHelper getYYMMDDString:0]];
                            }];
                        } else {
                            [self connectDeviceWithBlock:^(CSConnectState state) {
                                if (state == CSConnectfound) {
                                    [self synchronizationDeviceDataWithBlock:^{
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[DateHelper getYYMMDDString:1]];
                                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[DateHelper getYYMMDDString:0]];
                                    }];
                                }
                            }];
                        }
                    }
                }
            }
        }
    });
}

@end
