//
//  SYJBaseViewController.m
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
//#import "CFYNavigationBarTransition.h"
#import "UIImage+SYJImage.h"
#import "SYJUserInfoViewController.h"
@interface SYJBaseViewController ()

@end

@implementation SYJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // UIColor * radomcolor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
 
    
    self.view.backgroundColor = SYJColor(248, 248, 248, 1);
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVBAR_Color] forBarMetrics:(UIBarMetricsDefault)];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
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
