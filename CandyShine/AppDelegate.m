//
//  AppDelegate.m
//  CandyShine
//
//  Created by huangfulei on 14-1-20.
//  Copyright (c) 2014年 CandyWearables. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarView.h"
#import "SportViewController.h"
#import "SleepViewController.h"
#import "NewsViewController.h"
#import "MeViewController.h"
#import "WaterWarmViewController.h"

#import "WaterWarmManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initialShareSDK];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    
    SportViewController *base = [[SportViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    //base.title = [NSString stringWithFormat:@"Page%d",i+1];
    BaseNavigationController *baseVC = [[BaseNavigationController alloc] initWithRootViewController:base];
    
    WaterWarmViewController *waterWarmViewController = [[WaterWarmViewController alloc ] initWithNibName:@"WaterWarmViewController" bundle:nil];
    BaseNavigationController *water = [[BaseNavigationController alloc] initWithRootViewController:waterWarmViewController];
    
    NewsViewController *newsVC = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    BaseNavigationController *news = [[BaseNavigationController alloc] initWithRootViewController:newsVC];
    
    SleepViewController *sleepViewController = [[SleepViewController alloc] initWithNibName:@"SleepViewController" bundle:nil];
    BaseNavigationController *sleepNVC = [[BaseNavigationController alloc] initWithRootViewController:sleepViewController];
    
    MeViewController *meViewController = [[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil];
    BaseNavigationController *me = [[BaseNavigationController alloc] initWithRootViewController:meViewController];
    
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    tabBarVC.viewControllers = [NSArray arrayWithObjects:baseVC, sleepNVC , news,water ,me,nil];
    TabBarView *tabBarView = [UIXib viewWithXib:@"TabBarView"];
    [tabBarVC.tabBar addSubview:tabBarView];
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initialShareSDK {
    [UMSocialData setAppKey:UmengAppkey];
    //设置微信AppId
    [UMSocialConfig setWXAppId:@"applwxd9a39c7122aa6516" url:nil];
    //打开新浪微博的SSO开关
    //[UMSocialConfig setSupportSinaSSO:YES];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[WaterWarmManager shared] saveData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[WaterWarmManager shared] saveData];
}

@end
