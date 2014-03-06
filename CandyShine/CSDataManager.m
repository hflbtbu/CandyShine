
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
        _totalDays = [DateHelper getDaysBetween:[[NSUserDefaults standardUserDefaults] objectForKey:kFirstLaunchDate] and:[NSDate date]];
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

- (BOOL)saveData {
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

@end
