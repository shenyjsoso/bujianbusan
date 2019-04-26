//
//  SYJLogInViewController.m
//  不见不散
//
//  Created by soso on 2017/12/2.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJLogInViewController.h"
#import "SYJTabBarController.h"
#import "SYJRegisterViewController.h"
#import "SYJForgetViewController.h"
#import "SYJCustomerRequired.h"
#import "SYJTool.h"
#import "SYJStatus.h"
#import "SYJRegisterTwoViewController.h"
#import "SYJNavigationController.h"
#import "SYJUserServiceViewController.h"
#import "ChatUIHelper.h"
#import "SYJMyInfo.h"
@interface SYJLogInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//@property (nonatomic, assign) BOOL isUserEmpty;
//@property (nonatomic, assign) BOOL isPasswordEmpty;
@property(nonatomic,strong)SYJMyInfo *myInfo;
@end

@implementation SYJLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //页面手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    

    if([SYJTool getforkey:@"mobile"])
    {
        _userName.text=[SYJTool getforkey:@"mobile"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//- (NSString*)lastLoginUsername
//{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//    if (username && username.length > 0) {
//        return username;
//    }
//    return nil;
//}
#pragma mark 按钮事件
- (IBAction)LogIn:(UIButton *)sender {
    [self.view endEditing:YES];

    if (self.userName.text.length==11&&self.passWord.text.length>5) {
        NSDictionary *parameters = @{@"mobile":self.userName.text,
                                     @"password":self.passWord.text
                                     };

        __weak typeof (self) weakSelf = self;
        [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
        [HttpTool postWithPath:API_LogIn params:parameters hearder:clientdic success:^(id json) {
            //解析
            SYJCustomerRequired *customer=[SYJCustomerRequired mj_objectWithKeyValues:json];
            //登录成功后保存信息
            [SYJTool saveaccessToken:customer.accessToken];
            [SYJTool saveUserDefault:self.userName.text forkey:@"mobile"];
            [SYJTool saveUserDefault:self.passWord.text forkey:@"password"];
            
            NSString *value=[NSString stringWithFormat:@"Bearer %@",customer.accessToken];
            //查看是否填写基本信息
            [HttpTool getWithPath:API_status params:nil hearder:value success:^(id json) {
                SYJStatus *info =[SYJStatus mj_objectWithKeyValues:json];
                //NSLog(@"基本信息:%lld",info.status);
                if (info.status==0) {
                    [weakSelf hideHud];
                SYJRegisterTwoViewController *infoer=[[SYJRegisterTwoViewController alloc]init];
                    infoer.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
                    [weakSelf.navigationController pushViewController:infoer animated:YES];
                }
                else if (info.status==1)
                {
                    [HttpTool getWithPath:API_MyInfo params:nil hearder:value success:^(id json) {
                        //NSLog(@"%@",json);
                        self.myInfo=[SYJMyInfo mj_objectWithKeyValues:json];
                        NSString *myid=[NSString stringWithFormat:@"%ld",self.myInfo.idField];
                        [SYJTool saveUserDefault:myid forkey:@"myid"];
                        //环信登录
                        //__weak typeof(self) weakself = self;
                        NSString *username=[NSString stringWithFormat:@"user_%ld_bujianbusan",self.myInfo.idField];
                        NSString *Avatar=nil;
                        if (self.myInfo.avatar) {
                            NSLog(@"我的头像%@",self.myInfo.avatar);
                            Avatar=[API_avatar stringByAppendingString:self.myInfo.avatar];
                            [SYJTool saveUserDefault:@"YES" forkey:[NSString stringWithFormat:@"isavatar%ld",self.myInfo.idField]];
                        }

                        [[EMClient sharedClient] loginWithUsername:username password:self.passWord.text completion:^(NSString *aUsername, EMError *aError) {
                            NSLog(@"用户名和密码%@,%@",username,[SYJTool getforkey:@"password"]);
                            
                            [weakSelf hideHud];
                            if (!aError) {
                                NSString *userOpenId = username;// 用户环信ID
                                NSString *nickName=nil;
                                NSString *avatarUrl=nil;
                                if (self.myInfo.nickName) {
                                    nickName = self.myInfo.nickName;// 用户昵称
                                }
                                avatarUrl = Avatar;// 用户头像（绝对路径）
                                [UserCacheManager save:userOpenId avatarUrl:avatarUrl nickName:nickName];
                                //设置是否自动登录
                                [[EMClient sharedClient].options setIsAutoLogin:YES];
                                //获取数据库中数据
                                [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        //[[ChatUIHelper shareHelper] asyncGroupFromServer];
                                        [[ChatUIHelper shareHelper] asyncConversationFromDB];
                                        [[ChatUIHelper shareHelper] asyncPushOptions];
                                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                        //发送自动登陆状态通知
                                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                                        //保存最近一次登录用户名
                                        //[weakSelf saveLastLoginUsername];
                                    });
                                });
                                
                            } else {
                                //NSLog(@"环信登录失败");
                                [SYJProgressHUD showMessage:@"登录失败" inView:weakSelf.view afterDelayTime:1];
                            }
                        }];
                        
                    } failure:^(NSError *error) {
                        [weakSelf hideHud];
                       // [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
                    }];
                }
            } failure:^(NSError *error) {
                //NSLog(@"登录失败%@",error);
                [weakSelf hideHud];
//                if (error.code==-1011) {
//                    NSDictionary *errorDict=[SYJTool code1011:error];
//                    [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
//                }
//                else if (error.localizedDescription)
//                {
//                    [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
//                }
//                else{
//                    [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
//                }
                
            }];
        } failure:^(NSError *error) {
           // [hud hideAnimated:YES];
            [weakSelf hideHud];
            //NSLog(@"登录失败的原因%@",error );
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
        [SYJProgressHUD showMessage:@"请填写正确的手机号和密码" inView:self.view afterDelayTime:1];
    }

}
- (IBAction)forGet:(UIButton *)sender {
    [self.view endEditing:YES];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    SYJForgetViewController *Forget=[[SYJForgetViewController alloc]init];
    [self.navigationController pushViewController:Forget animated:YES];
}
- (IBAction)Register:(UIButton *)sender {
    [self.view endEditing:YES];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    SYJRegisterViewController *RegVC=[[SYJRegisterViewController alloc]init];
    [self.navigationController pushViewController:RegVC animated:YES];
}
- (IBAction)userService:(UIButton *)sender {
    NSLog(@"服务条款");
    SYJUserServiceViewController *service=[[SYJUserServiceViewController alloc]init];
    [self.navigationController pushViewController:service animated:YES];
    
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
#pragma  mark - private
//- (void)saveLastLoginUsername
//{
//    NSString *username = [[EMClient sharedClient] currentUsername];
//    if (username && username.length > 0) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//        [ud synchronize];
//    }
//}
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
