//
//  SYJRegisterViewController.m
//  不见不散
//
//  Created by soso on 2017/12/3.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJRegisterViewController.h"
#import "SYJRegisterTwoViewController.h"
#import "SYJCustomerRequired.h"
#import "SYJTool.h"
@interface SYJRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *checkTxt;
@property (weak, nonatomic) IBOutlet UITextField *passWordTxt;
@property (weak, nonatomic) IBOutlet UITextField *ensurePassWordTxt;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//@property (nonatomic, assign) BOOL isPhoneEmpty;
//@property (nonatomic, assign) BOOL isCheckEmpty;

@end

@implementation SYJRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    //页面手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    //设置textfield监听
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark 监听事件

#pragma mark 按钮事件
- (IBAction)countDownTouched:(JKCountDownButton *)sender {
    if (self.phoneTxt.text.length==11) {
        //NSLog(@"按下按钮");
        NSDictionary *parameters = @{@"mobile":self.phoneTxt.text};
        // [client.requestSerializer setValue:@"Basic ZDBmNzg1ZWE1N2IzNDFhM2ExMTRiZWIxNmNlZjFiOTc6" forHTTPHeaderField:@"Authorization"];
        //NSDictionary *hearderdic=@{@"Authorization":@"Basic ZDBmNzg1ZWE1N2IzNDFhM2ExMTRiZWIxNmNlZjFiOTc6"};
        [HttpTool getWithPath:API_Verifycode  params:parameters hearder:clientdic success:^(id json) {
           // NSLog(@"验证码收取成功%@",json);
            
            [SYJProgressHUD showMessage:@"验证码获取成功" inView:self.view afterDelayTime:1];
            sender.enabled = NO;
            self.nextBtn.enabled=YES;
            self.nextBtn.backgroundColor=NAVBAR_Color;
            //button type要 设置成custom 否则会闪动
            [sender startCountDownWithSecond:60];
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
    [self.view endEditing:YES];
    if (self.phoneTxt.text.length==11&&self.checkTxt.text.length==6&& self.passWordTxt.text.length>5&&[self.passWordTxt.text isEqualToString:self.ensurePassWordTxt.text]) {
         [self showHudInView:self.view hint:@"注册中..."];
        //网络请求
        __weak typeof(self) weakself = self;
        NSDictionary *parameters = @{
                 @"mobile":self.phoneTxt.text,
                 @"smscode":self.checkTxt.text,
                 @"password":self.passWordTxt.text};
        [HttpTool postWithPath:API_Register params:parameters hearder:clientdic success:^(id json) {
            //NSLog(@"注册成功：%@",json);
            [self hideHud];
        [SYJTool saveUserDefault:self.phoneTxt.text forkey:@"mobile"];
        [SYJTool saveUserDefault:self.passWordTxt.text forkey:@"password"];
            SYJCustomerRequired *customer=[SYJCustomerRequired mj_objectWithKeyValues:json];
            //NSLog(@"用户权限%@",customer.accessToken);
            [SYJTool saveaccessToken:customer.accessToken];
            [SYJProgressHUD showMessage:@"注册成功" inView:weakself.view afterDelayTime:1];
            [weakself performSelector:@selector(popNext) withObject:nil afterDelay:1.0f];
            
//            NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];

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
-(void)popNext
{
    SYJRegisterTwoViewController *twoVC=[[SYJRegisterTwoViewController alloc]init];
    [self.navigationController pushViewController:twoVC animated:YES];
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
