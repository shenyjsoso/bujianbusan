//
//  YFGradualChangeViewController.m
//  BigShow1949
//
//  Created by zhht01 on 16/5/10.
//  Copyright © 2016年 BigShowCompany. All rights reserved.
//

#import "SYJChangeViewController.h"
#import "ZWIntroductionViewController.h"
#import "SYJLogInViewController.h"
#import "SYJNavigationController.h"
#import "AppDelegate+EaseMob.h"
@interface SYJChangeViewController ()
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@end

@implementation SYJChangeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Added Introduction View Controller
    //NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    NSArray *backgroundImageNames = @[@"引导页1", @"引导页2", @"引导页3"];
    
    //self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    
    // Example 1 : Simple
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:backgroundImageNames];
    
    // Example 2 : Custom Button
    //    UIButton *enterButton = [UIButton new];
    //    [enterButton setBackgroundImage:[UIImage imageNamed:@"bg_bar"] forState:UIControlStateNormal];
    //    self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames button:enterButton];
    [self.view addSubview:self.introductionView.view];
    
    //__weak SYJChangeViewController *weakSelf = self;
    SYJLogInViewController *loginVC=[[SYJLogInViewController alloc]init];
    SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:loginVC];
    self.introductionView.didSelectedEnter = ^() {
        CATransition *anim = [[CATransition alloc] init];
        anim.type = @"rippleEffect";
        anim.duration = 1.0;
        [[[UIApplication sharedApplication] keyWindow].layer addAnimation:anim forKey:nil];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:nav];

    };
}
@end
