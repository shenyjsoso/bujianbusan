//
//  SYJTabBarController.m
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJTabBarController.h"
#import "ConversationListController.h"
#import "CardViewController.h"
#import "SYJMessageViewController.h"
//#import "SYJFindViewController.h"
#import "SYJMeViewController.h"
#import "SYJNavigationController.h"
#import "SYJTabBar.h"

#import "ChatUIHelper.h"

static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kMessageType = @"MessageType";
@interface SYJTabBarController ()
@property(nonatomic,strong)SYJMessageViewController *message;
@end

@implementation SYJTabBarController

+(void)initialize{
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=[UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName]=[UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs=[NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName]=SYJColor(255, 125, 45, 1);
    
    //  通过appearance统一设置所有UITabBarItem的文字属性
    //  后面带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象统一设置
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    }
    //NOTIFY_ADD(setupUntreatedApplyCount, kSetupUntreatedApplyCount);
    
    NOTIFY_ADD(setupUnreadMessageCount, kSetupUnreadMessageCount);
    
    NOTIFY_ADD(networkChanged, kConnectionStateChanged);
    
    CardViewController *home=[[CardViewController alloc]init];
    [self SetupChildController:home
                         image:@"首页2"
                 Selectedimage:@"首页1"
                         title:@"首页"];
    
    self.message=[[SYJMessageViewController alloc]init];
    [self SetupChildController:self.message
                         image:@"消息2"
                 Selectedimage:@"消息1"
                         title:@"消息"];
    
    self.message.ListView=[[ConversationListController alloc]init];
    [self.message.ListView networkChanged:_connectionState];
    self.message.tag=0;
    
    SYJMeViewController *Me=[[SYJMeViewController alloc]init];
    [self SetupChildController:Me
                         image:@"个人2"
                 Selectedimage:@"个人1"
                         title:@"我的"];
    
    [self setValue:[[SYJTabBar alloc]init] forKeyPath:@"tabBar"];
    [self setupUnreadMessageCount];
    [ChatUIHelper shareHelper].conversationListVC = self.message.ListView;
 
}
-(void)SetupChildController:(UIViewController *)ChildController  image:(NSString *)image Selectedimage:(NSString *)Selectedimage title:(NSString *)title{
    
    ChildController.tabBarItem.title=title;
    ChildController.tabBarItem.image=[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ChildController.tabBarItem.selectedImage=
    [[UIImage imageNamed:Selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:ChildController];
    [self addChildViewController:nav];
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (self.message.ListView) {
        if (unreadCount > 0) {
            self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            self.message.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}
- (void)networkChanged
{
    _connectionState = [ChatUIHelper shareHelper].connectionState;
    [self.message.ListView networkChanged:_connectionState];
}
#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}
- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}
#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
    }
    else if(self.message.ListView)
    {
        [self.navigationController popToViewController:self animated:NO];
        self.message.tag=1;
        [self setSelectedViewController:self.message];
    }
}
- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}
- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        }
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];

                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];

                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];

                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];

                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (self.message)
    {
        [self.navigationController popToViewController:self animated:NO];
        self.message.tag=1;
        [self setSelectedViewController:self.message];
    }
}
- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        }
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];

                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];

                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (self.message)
    {
        [self.navigationController popToViewController:self animated:NO];
        self.message.tag=1;
        [self setSelectedViewController:self.message];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
