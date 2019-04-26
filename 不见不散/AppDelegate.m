//
//  AppDelegate.m
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"
#import "SYJNavigationController.h"
#import "SYJLogInViewController.h"
#import "SYJChangeViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ChatUIHelper.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UITabBarControllerDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        } else {
            // Fallback on earlier versions
        }
    }

    
    NSString *key = @"CFBundleShortVersionString";
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (![currentVersion isEqualToString:sanboxVersion])
    {
        //UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //引导页
        SYJChangeViewController *changeView=[[SYJChangeViewController alloc]init];
        self.window.rootViewController=changeView;
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        BOOL isHttpsOnly = [ud boolForKey:@"identifier_httpsonly"];
        
        EMOptions *options = [EMOptions optionsWithAppkey:@"1145180106178138#bujianbusan"];
        [[EMClient sharedClient] initializeSDKWithOptions:options];
        
        [[EaseSDKHelper shareHelper] hyphenateApplication:application
                            didFinishLaunchingWithOptions:launchOptions
                                                   appkey:@"1145180106178138#bujianbusan" apnsCertName:@"bujianbusan"
                                              otherConfig:@{@"httpsOnly":[NSNumber numberWithBool:isHttpsOnly],kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
        [ChatUIHelper shareHelper];
        //注册登录状态监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginStateChange:)
                                                     name:KNOTIFICATION_LOGINCHANGE
                                                   object:nil];
        
    }
    else
    {

//            SYJLogInViewController *login=[[SYJLogInViewController alloc]init];
//            SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:login];
//            self.window.rootViewController=nav;

        [self easemobApplication:application
   didFinishLaunchingWithOptions:launchOptions
                          appkey:@"1145180106178138#bujianbusan"
                    apnsCertName:@"bujianbusan"
                     otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    }


    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_tabbar) {
        [_tabbar jumpToChatList];
    }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_tabbar) {
        [_tabbar didReceiveLocalNotification:notification];
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (_tabbar) {
        [_tabbar didReceiveUserNotification:response.notification];
    }
    completionHandler();
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[EMClient sharedClient] applicationDidEnterBackground:application];
//}
//
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[EMClient sharedClient] applicationWillEnterForeground:application];
//}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    SYJNavigationController *navigationController = nil;
    if (loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
        
        // [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (self.tabbar == nil) {
            self.tabbar = [[SYJTabBarController alloc] init];
            // navigationController = [[SYJNavigationController alloc] initWithRootViewController:self.tabbar];
            self.window.rootViewController = self.tabbar;
        }else{
            navigationController  = (SYJNavigationController *)self.tabbar.navigationController;
            self.window.rootViewController = self.tabbar;
        }
        
        [ChatUIHelper shareHelper].mainVC = self.tabbar;
        
        // [[ChatUIHelper shareHelper] asyncGroupFromServer];
        [[ChatUIHelper shareHelper] asyncConversationFromDB];
        [[ChatUIHelper shareHelper] asyncPushOptions];
    }
    else{//登陆失败加载登陆页面控制器
        if (self.tabbar) {
            [self.tabbar.navigationController popToRootViewControllerAnimated:NO];
        }
        self.tabbar = nil;
        [ChatUIHelper shareHelper].mainVC = nil;
        
        SYJLogInViewController *loginController = [[SYJLogInViewController alloc] init];
        navigationController = [[SYJNavigationController alloc] initWithRootViewController:loginController];
        self.window.rootViewController = navigationController;
    }
    
    
    
    //navigationController.navigationBar.accessibilityIdentifier = @"navigationbar";
    
}

@end
