//
//  SYJNavigationController.m
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJNavigationController.h"
#import "UIImage+SYJImage.h"
@interface SYJNavigationController ()

@end

@implementation SYJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithObjects:@[[UIColor whiteColor],[UIFont systemFontOfSize:19]]forKeys:@[NSForegroundColorAttributeName,NSFontAttributeName]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    
  //  [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBarTintColor:NAVBAR_Color];
   // [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//设置按钮颜色
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
