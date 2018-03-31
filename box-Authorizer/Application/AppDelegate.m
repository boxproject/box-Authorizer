//
//  AppDelegate.m
//  box-Authorizer
//
//  Created by Rony on 2018/2/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AppDelegate.h"
#import "InitAccountViewController.h"

#import "HomepageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //启动页延时
    //sleep(2);
    [NSThread sleepForTimeInterval:2.0];
    
    //网络监测
    [self monitorReachabilityStatus];
    [self launchJumpVC];
    
    return YES;
}

//启动跳转的VC
-(void)launchJumpVC
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    InitAccountViewController *initAccountVC = [[InitAccountViewController alloc] init];
    UINavigationController *initAccountNC = [[UINavigationController alloc] initWithRootViewController:initAccountVC];
    //设置导航栏颜色
    [UINavigationBar appearance].barTintColor =  kWhiteColor;
    self.window.rootViewController = initAccountNC;
    
    
//    HomepageViewController *homePageVC = [[HomepageViewController alloc] init];
//    UINavigationController *homePageNC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
//    //设置导航栏颜色
//    [UINavigationBar appearance].barTintColor =  kWhiteColor;
//    self.window.rootViewController = homePageNC;
    
}


//监测网络状态的方法
- (void)monitorReachabilityStatus
{
    // 开始监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 网络状态改变的回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            default:
                break;
        }
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"startAnimation" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
