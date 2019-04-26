//
//  SYJProgressHUD.h
//  不见不散
//
//  Created by soso on 2017/12/10.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJProgressHUD : NSObject

//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;
//-(MBProgressHUD*)showHUDinView:(UIView *)view;
@end
