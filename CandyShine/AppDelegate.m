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

#import "IntroduceViewController.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()
{
    UITabBarController *_tabBarController;
    IntroduceViewController *_introVC;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self commenInit];
    [self initialShareSDK];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    SportViewController *base = [[SportViewController alloc] initWithNibName:@"SportViewController" bundle:nil];
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
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = [NSArray arrayWithObjects:baseVC, sleepNVC , news,water ,me,nil];
    if (IsIOS7) {
        _tabBarController.tabBar.barTintColor = [UIColor colorWithRed:82/255.0 green:62/255.0 blue:55/255.0 alpha:1.0];
    } else {
        _tabBarController.tabBar.tintColor = [UIColor colorWithRed:82/255.0 green:62/255.0 blue:55/255.0 alpha:1.0];
    }
    
    if (launchOptions != nil) {
        _tabBarController.selectedIndex = 3;
    }
    
    self.window.rootViewController = _tabBarController;
    
    
    _introVC = [[IntroduceViewController alloc] initWithNibName:@"IntroduceViewController" bundle:nil];

    [_tabBarController.view addSubview:_introVC.view];
    
    [self initAppearece];
    
    //tabBarVC.tabBar.selectionIndicatorImage = ;


    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)commenInit {
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstLaunch];
    if (!isFirstLaunch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstLaunch];
        [[NSUserDefaults standardUserDefaults] setObject:[DateHelper getDayBegainWith:0] forKey:kFirstLaunchDate];
    }
    [CSDataManager sharedInstace];
}

- (void)initAppearece {
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kContentFont3, UITextAttributeFont, kContentNormalColor, UITextAttributeTextColor, nil]];
    if (!IsIOS7) {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
}

- (void)initialShareSDK {
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialConfig setQQAppId:@"100424468" url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxd9a39c7122aa6516" url:nil];}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    _tabBarController.selectedIndex = 3;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
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
    [[WaterWarmManager shared] saveData];
    [[CSDataManager sharedInstace] saveUserData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
