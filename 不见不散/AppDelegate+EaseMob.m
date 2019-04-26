/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegate+EaseMob.h"
//#import "AppDelegate+EaseMobDebug.h"
//#import "ApplyViewController.h"
#import "SYJNavigationController.h"
#import "SYJLogInViewController.h"
#import "ChatUIHelper.h"
/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isHttpsOnly = [ud boolForKey:@"identifier_httpsonly"];

    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                    didFinishLaunchingWithOptions:launchOptions
                                           appkey:appkey
                                     apnsCertName:apnsCertName
                                      otherConfig:@{@"httpsOnly":[NSNumber numberWithBool:isHttpsOnly], kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

    [ChatUIHelper shareHelper];
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    
}

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - login changed

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


}



@end
