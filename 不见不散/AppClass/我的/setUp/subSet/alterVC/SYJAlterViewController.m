//
//  SYJRegisterViewController.m
//  不见不散
//
//  Created by soso on 2017/12/3.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJAlterViewController.h"
#import "SYJLogInViewController.h"
#import "SYJNavigationController.h"
//#import "ApplyViewController.h"
@interface SYJAlterViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *checkTxt;
@property (weak, nonatomic) IBOutlet UITextField *passWordTxt;
@property (weak, nonatomic) IBOutlet UITextField *ensurePassWordTxt;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation SYJAlterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改密码";
    self.phoneTxt.text=self.phoneStr;
    //页面手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)countDownTouched:(JKCountDownButton *)sender {
    if (self.phoneTxt.text.length==11) {
        NSDictionary *parameters = @{@"mobile":self.phoneTxt.text};
        [HttpTool getWithPath:API_Verifycode params:parameters hearder:clientdic success:^(id json) {
           // NSLog(@"验证码收取成功%@",json);
            [SYJProgressHUD showMessage:@"验证码获取成功" inView:self.view afterDelayTime:1];
            //button type要 设置成custom 否则会闪动
            [sender startCountDownWithSecond:60];
            sender.enabled = NO;
            self.nextBtn.enabled=YES;
            self.nextBtn.backgroundColor=NAVBAR_Color;
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        } failure:^(NSError *error) {
            //NSLog(@"验证码收取失败%@",error);
            if (error.code==-1011) {
                NSDictionary *errorDict=[SYJTool code1011:error];
                [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
            }
            else if (error.localizedDescription)
            {
                [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
            }
            else{
                [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
            }
        }];
    }
    else
    {
        [SYJProgressHUD showMessage:@"请填写正确手机号" inView:self.view afterDelayTime:1];
    }
    
}
- (IBAction)nextView:(UIButton *)sender {
 if(self.phoneTxt.text.length==11&&self.checkTxt.text.length==6&&self.passWordTxt.text.length>5&&[self.passWordTxt.text isEqualToString:self.ensurePassWordTxt.text]) {
        [self.view endEditing:YES];
     [self showHudInView:self.view hint:@"提交中..."];
        //网络请求
        NSDictionary *parameters = @{
                                     @"mobile":self.phoneTxt.text,
                                     @"smscode":self.checkTxt.text,
                                     @"password":self.passWordTxt.text};
     __weak SYJAlterViewController *weakSelf = self;
        [HttpTool postWithPath:API_ChangePassword params:parameters hearder:clientdic success:^(id json) {
            [self hideHud];
            [SYJProgressHUD showMessage:@"修改成功" inView:self.view afterDelayTime:1];
            [weakSelf performSelector:@selector(popRoot) withObject:nil afterDelay:1.0f];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                EMError *error = [[EMClient sharedClient] logout:YES];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (error != nil) {
//                        [weakSelf showHint:error.errorDescription];
//                    }
//                    else{
//                        [SYJProgressHUD showMessage:@"修改成功" inView:self.view afterDelayTime:1];
//                        //NSLog(@"退出成功");
//                        [weakSelf performSelector:@selector(popRoot) withObject:nil afterDelay:1.0f];
//
//                    }
//                });
//            });
            
        } failure:^(NSError *error) {
            [self hideHud];
            if (error.code==-1011) {
                NSDictionary *errorDict=[SYJTool code1011:error];
                [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
            }
            else if (error.localizedDescription)
            {
                [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
            }
            else{
                [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
            }
        }];
    }
    else
    {
        [SYJProgressHUD showMessage:@"密码设置不正确" inView:self.view afterDelayTime:1];
    }
}
-(void)popRoot
{
    //[[ApplyViewController shareController] clear];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];

    SYJLogInViewController *loginVC=[[SYJLogInViewController alloc]init];
    SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:loginVC];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:nav];
//    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
