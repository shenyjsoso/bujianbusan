//
//  SYJRegisterTwoViewController.m
//  不见不散
//
//  Created by soso on 2017/12/3.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJRegisterTwoViewController.h"
#import "SexPickerTool.h"
#import "DatePickerTool.h"
#import "SYJTool.h"
#import "SYJTabBarController.h"

#import "SYJCustomerRequired.h"
#import "SYJMyInfo.h"
#import "ChatUIHelper.h"
@interface SYJRegisterTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *sexTxt;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTxt;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
//@property(nonatomic,copy)NSString *userToken;
@property(nonatomic,strong)SYJMyInfo *myInfo;
@end

@implementation SYJRegisterTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"基本信息";
    //页面手势
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
 #pragma mark 按钮事件
- (IBAction)sexChange:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.enabled=NO;
    SexPickerTool *sexPick = [[SexPickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-250-STATUS_HEIGHT-NAVBAR_HEIGHT, ScreenWidth, 250)];
    __block SexPickerTool *blockPicker = sexPick;
    //__weak typeof (self) weakSelf = self;
    sexPick.callBlock = ^(NSString *pickDate) {
        if (pickDate) {
           _sexTxt.text=pickDate;
        }
        [blockPicker removeFromSuperview];
        sender.enabled=YES;
    };
    [self.view addSubview:sexPick];
}
- (IBAction)birthdayChange:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.enabled=NO;
    DatePickerTool *datePicker = [[DatePickerTool alloc] initWithFrame:CGRectMake(0, ScreenHeight-250-STATUS_HEIGHT-NAVBAR_HEIGHT, ScreenWidth, 250)];
    __block DatePickerTool *blockPick = datePicker;
    //__weak typeof (self) weakSelf = self;
    datePicker.callBlock = ^(NSString *pickDate) {
        if (pickDate) {
            _birthdayTxt.text=pickDate;
        }
        [blockPick removeFromSuperview];
        sender.enabled=YES;
    };
    [self.view addSubview:datePicker];
}
- (IBAction)registerChange:(UIButton *)sender {
    [self.view endEditing:YES];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.nameTxt.text.length>0&&self.sexTxt.text.length>0&&self.birthdayTxt.text.length>0) {
            [self showHudInView:self.view hint:@"提交中..."];
            NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
            // NSDictionary *usertoken=@{@"Authorization":value};
            NSInteger sex=0;
            if ([self.sexTxt.text isEqualToString:@"男"]) {
                sex=1;
            }
            else
            {
                sex=2;
            }
            long long age=[SYJTool getagetime:self.birthdayTxt.text];
            NSDictionary *params=@{@"nickName":self.nameTxt.text,
                                   @"gender":@(sex),
                                   @"birthday":@(age)
                                   };
            //NSLog(@"请求体%@",params);
            [HttpTool putWithPath:API_Customerinfo params:params hearder:value success:^(id json) {
                [self hideHud];
                [SYJProgressHUD showMessage:@"信息提交成功" inView:self.view afterDelayTime:1];
                [self performSelector:@selector(popRoot) withObject:nil afterDelay:1.0f];
            } failure:^(NSError *error) {
                //NSLog(@"填写信息失败%@",error);
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
            [SYJProgressHUD showMessage:@"请填写完整信息" inView:self.view afterDelayTime:1];
        }
    }];
    UIAlertController *alter=[SYJTool showAlterYesOrNo:@"性别、生日确定后将不可更改！"];
    [alter addAction:action];
    alter.view.tintColor=NAVBAR_Color;
    [self presentViewController:alter animated:YES completion:nil];

}
-(void)popRoot
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //SYJTabBarController *tabbar=[[SYJTabBarController alloc]init];
//    tabbar.modalTransitionStyle=UIModalTransitionStyleCrossDissolve ;
    //[[[UIApplication sharedApplication] keyWindow] setRootViewController:tabbar];
    NSDictionary *parameters = @{@"mobile":[SYJTool getforkey:@"mobile"],
                                 @"password":[SYJTool getforkey:@"password"]
                                 };
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //        hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    //        hud.bezelView.color =[UIColor clearColor];
    __weak typeof (self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    [HttpTool postWithPath:API_LogIn params:parameters hearder:clientdic success:^(id json) {
        
        //[hud hideAnimated:YES];
        //NSLog(@"登录成功%@",json);
        //解析
        SYJCustomerRequired *customer=[SYJCustomerRequired mj_objectWithKeyValues:json];
        //NSLog(@"用户权限%@",customer.accessToken);
        //登录成功后保存信息
        [SYJTool saveaccessToken:customer.accessToken];
        //[SYJTool saveUserDefault:self.userName.text forkey:@"mobile"];
        //[SYJTool saveUserDefault:self.passWord.text forkey:@"password"];
        //拿出accessToken
        //NSString *userToken=[SYJTool getforkey:@"accessToken"];
        NSString *value=[NSString stringWithFormat:@"Bearer %@",customer.accessToken];
        
                //我的信息
                //NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
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
                    [[EMClient sharedClient] loginWithUsername:username password:[SYJTool getforkey:@"password"] completion:^(NSString *aUsername, EMError *aError) {
                        //NSLog(@"%@,%@",username,[SYJTool getforkey:@"password"]);
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
                    [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
                }];
        

        } failure:^(NSError *error) {
            //NSLog(@"登录失败%@",error);
            [weakSelf hideHud];
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

#pragma textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//手势事件
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
