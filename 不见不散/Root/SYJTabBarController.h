//
//  SYJTabBarController.h
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface SYJTabBarController : UITabBarController
{
    EMConnectionState _connectionState;
}
@property(nonatomic,copy)NSString *userPower;
- (void)jumpToChatList;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

@end
