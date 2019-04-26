//
//  SYJUserServiceViewController.m
//  不见不散
//
//  Created by soso on 2018/3/14.
//  Copyright © 2018年 soso. All rights reserved.
//

#import "SYJUserServiceViewController.h"

@interface SYJUserServiceViewController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation SYJUserServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"用户协议";
    [self simpleUIWebViewTest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)simpleUIWebViewTest {

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-STATUS_HEIGHT-NAVBAR_HEIGHT)];
    webView.backgroundColor=SYJColor(248, 248, 248, 1);
    // 2.创建URL
    NSURL *url = [NSURL URLWithString:@"http://904243.ichengyun.net/app/privacyclause"];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [webView loadRequest:request];
    // 5.最后将webView添加到界面
    [self.view addSubview:webView];
    self.webView = webView;
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
