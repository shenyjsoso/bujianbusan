//
//  SYJRegisterViewController.m
//  不见不散
//
//  Created by soso on 2017/12/3.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJForgetViewController.h"
#import "SYJLogInViewController.h"
#import "SYJNavigationController.h"
@interface SYJForgetViewController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *checkTxt;
@property (weak, nonatomic) IBOutlet UITextField *passWordTxt;
@property (weak, nonatomic) IBOutlet UITextField *ensurePassWordTxt;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation SYJForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"忘记密码";
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
            NSLog(@"验证码收取成功%@",json);
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
            NSLog(@"验证码收取失败%@",error);
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
    [self showHudInView:self.view hint:@"提交中..."];
    if(self.phoneTxt.text.length==11&&self.checkTxt.text.length==6&&self.passWordTxt.text.length>5&&[self.passWordTxt.text isEqualToString:self.ensurePassWordTxt.text]) {
        [self.view endEditing:YES];
        //网络请求
        NSDictionary *parameters = @{
                                     @"mobile":self.phoneTxt.text,
                                     @"smscode":self.checkTxt.text,
                                     @"password":self.passWordTxt.text};
        [HttpTool postWithPath:API_ChangePassword params:parameters hearder:clientdic success:^(id json) {
            //NSLog(@"修改成功：%@",json);
            [self hideHud];
            [SYJProgressHUD showMessage:@"修改成功" inView:self.view afterDelayTime:1];
            [self performSelector:@selector(popRoot) withObject:nil afterDelay:1.0f];
        } failure:^(NSError *error) {
            //(@"修改失败%@",error);
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
    [self.navigationController popToRootViewControllerAnimated:YES];
//    SYJLogInViewController *loginVC=[[SYJLogInViewController alloc]init];
//    SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:loginVC];
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
