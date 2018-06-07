//
//  AppDelegate.m
//  box-Authorizer
//
//  Created by Rony on 2018/2/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AppDelegate.h"
#import "InitAccountViewController.h"
#import "GenerateContractViewController.h"
#import "ServiceStartViewController.h"
#import "AwaitBackupViewController.h"
#import "BlueToothListViewController.h"
#import "HomepageViewController.h"
#import "LeftMenuViewController.h"

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
    [[BoxDataManager sharedManager] getAllData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *launchState = [defaults valueForKey:@"launchState"];
    NSInteger launchStateIn = [launchState integerValue];
    if (launchState != nil) {
        if (launchStateIn == EnterHomeBox) {
            //启动直接进入主页
            [self enterHomeBoxPage];
        }else if (launchStateIn == NotBackupPassword) {
            //蓝牙打印二维码
            [self enterBlueToothListPrint];
        }
        else {
            //启动根据签名机状态
            [self requestAgentStatus];
        }
    } else {
        //账户首次初始化
        [self enterInitAccountView];
    }
}

//启动根据签名机状态
-(void)requestAgentStatus
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/status" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            NSInteger ServerStatus = [dict[@"Status"][@"ServerStatus"] integerValue];
            [self handleLaunchWithStatus:ServerStatus];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)handleLaunchWithStatus:(NSInteger)status
{
    switch (status) {
        case NotConnectedStatus:
            //账户初始化
            [self enterInitAccountView];
            break;
        case NotCreatedContractStatus:
            //账户初始化
            [self enterInitAccountView];
            break;
        case CreatedContractStatus:
            if ([BoxDataManager sharedManager].codePassWord != nil) {
                [self enterAwaitBackup];
            }else{
                //已创建,发布合约
                [self enterCreatedContract];
            }
            break;
        case PublishContractStatus:
            //首次启动服务
            [self enterFirstStartServer];
            break;
        case StartedServiceStatus:
            //启动直接进入主页
            [self enterHomeBoxPage];
            break;
        case StoppedServiceStatus:
            //启动直接进入主页
            [self enterHomeBoxPage];
            break;
        default:
            break;
    }
}

//进入主页
-(void)enterHomeBoxPage
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    HomepageViewController *homepageVC = [[HomepageViewController alloc] init];
    LeftMenuViewController *leftMenuVC = [[LeftMenuViewController alloc] init];
    //侧滑栏
    JASidePanelController *panelVC = [[JASidePanelController alloc] init];
    UINavigationController *homepageNC = [[UINavigationController alloc]initWithRootViewController:homepageVC];
    UINavigationController *leftMenuNC = [[UINavigationController alloc]initWithRootViewController:leftMenuVC];
    leftMenuNC.navigationBar.hidden = YES;
    panelVC.leftPanel = leftMenuNC;
    panelVC.centerPanel = homepageNC;
    panelVC.recognizesPanGesture = YES;
    panelVC.leftGapPercentage = .71;
    self.window.rootViewController = panelVC;
}

//初始化
-(void)enterInitAccountView
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    InitAccountViewController *initAccountVC = [[InitAccountViewController alloc] init];
    UINavigationController *initAccountNC = [[UINavigationController alloc] initWithRootViewController:initAccountVC];
    [UINavigationBar appearance].barTintColor =  kWhiteColor;
    self.window.rootViewController = initAccountNC;
}

//进入发布合约
-(void)enterCreatedContract
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    GenerateContractViewController *generateContractVC = [[GenerateContractViewController alloc] init];
    UINavigationController *generateContractNC = [[UINavigationController alloc] initWithRootViewController:generateContractVC];
    self.window.rootViewController = generateContractNC;
}

//进入备份状态
-(void)enterAwaitBackup
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    AwaitBackupViewController *awaitBackupVC = [[AwaitBackupViewController alloc] init];
    self.window.rootViewController = awaitBackupVC;
}

//进入启动服务
-(void)enterFirstStartServer
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    ServiceStartViewController *serviceStartVC = [[ServiceStartViewController alloc] init];
    UINavigationController *serviceStartNV = [[UINavigationController alloc] initWithRootViewController:serviceStartVC];
    self.window.rootViewController = serviceStartNV;
}

//蓝牙打印二维码
-(void)enterBlueToothListPrint
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    BlueToothListViewController *blueToothListVC = [[BlueToothListViewController alloc] init];
    UINavigationController *blueToothListNC = [[UINavigationController alloc] initWithRootViewController:blueToothListVC];
    self.window.rootViewController = blueToothListNC;
}

//监测网络状态
- (void)monitorReachabilityStatus
{
    //开始监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //网络状态改变的回调
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

#pragma mark ----- 禁止横屏 -----
- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //关闭横屏
    return UIInterfaceOrientationMaskPortrait;
    //允许横屏
    //return UIInterfaceOrientationMaskAll;
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
