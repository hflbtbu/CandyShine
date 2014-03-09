
//
//  CSDataManager.m
//  CandyShine
//
//  Created by huangfulei on 14-2-24.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "CSDataManager.h"

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
        _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kUserIsLogin];
        if (_isLogin) {
            _userName = [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
            _userId = [[NSUserDefaults standardUserDefaults] stringForKey:kUserId];
            _portrait = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPortrait];
        }
        _totalDays = [DateHelper getDaysBetween:[[NSUserDefaults standardUserDefaults] objectForKey:kFirstLaunchDate] and:[NSDate date]];
        
        
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
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"date between {%@, %@}",[DateHelper getDayBegainWith:day],[DateHelper getDayEndWith:day]];
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

@end
