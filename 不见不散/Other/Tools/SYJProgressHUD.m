//
//  SYJProgressHUD.m
//  不见不散
//
//  Created by soso on 2017/12/10.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJProgressHUD.h"

@implementation SYJProgressHUD
//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:delay];
}
//进度
//-(MBProgressHUD*)showProgress:(float )progress inView:(UIView *)view 
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode=MBProgressHUDModeAnnularDeterminate;
//    hud.progress=progress;
//    return hud;
//}
//-(MBProgressHUD*)showHUDinView:(UIView *)view
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    return hud;
//}
@end
