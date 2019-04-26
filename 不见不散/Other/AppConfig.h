//
//  AppConfig.h
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define SERVER_HOST @"http://904243.ichengyun.net/app"
#define API_Recommends @"/recommends"
#define API_LogIn @"/token"
#define API_Verifycode @"/verifycode"
#define API_Register @"/register"
#define API_ChangePassword @"/changepassword"
#define API_Customerinfo @"/customer/required"
#define API_status @"/loginstatus"
#define API_avatar @"http://904243.ichengyun.net/app/avatar/"
#define API_frineds @"/friends"
#define API_Like @"/like"
#define API_CustomerID @"/customers"
#define API_MyInfo @"/customer"
#define clientdic @"Basic ZDBmNzg1ZWE1N2IzNDFhM2ExMTRiZWIxNmNlZjFiOTc6"
#define API_Mate @"/mateselect"
#define API_FindSelect @"/findselect"
#define API_avatarShort @"/avatar"
#define API_photos @"/photos"
#define API_Location @"/position"
#define API_similarity @"/similarity"
#define API_createuser @"/emchat/createuser"
#define API_alltags @"/alltags"
#define API_settings @"/settings"
#define API_fullphoto @"http://904243.ichengyun.net/app/fullphoto/"
#define API_feedback @"/feedback"
#define API_informtypes @"/inform/types"
#define API_inform @"/inform"
#define API_blocked @"/blocked"
#define API_deblocked @"/deblocked"




#define SYJColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define NAVBAR_Color SYJColor(255, 127, 61, 1)

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//是否是手机
#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//是否是iphoneX
#define isIPhoneX (ScreenWidth >= 375.0f && ScreenHeight >= 812.0f && isIPhone)
//苹果X宽高
#define IPHONE_X_SCREEN_WIDTH 375
#define IPHONE_X_SCREEN_HEIGHT 812
//底部安全高度
#define BOTTOM_SAFE_HEIGHT (isIPhoneX ? 34 : 0)
//系统手势高度
#define SYSTEM_GESTURE_HEIGHT (isIPhoneX ? 13 : 0)
//tabbar高度
#define TABBAR_HEIGHT (49 + BOTTOM_SAFE_HEIGHT)
//状态栏高度
#define STATUS_HEIGHT (isIPhoneX ? 44 : 20)
//导航栏高
#define NAVBAR_HEIGHT 44

#endif /* AppConfig_h */
