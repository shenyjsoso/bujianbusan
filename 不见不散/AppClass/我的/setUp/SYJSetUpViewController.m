//
//  SYJSetUpViewController.m
//  不见不散
//
//  Created by soso on 2017/12/12.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJSetUpViewController.h"

#import "SYJSecurityViewController.h"
#import "SYJLogInViewController.h"
#import "SYJNavigationController.h"
//#import "ApplyViewController.h"
#import "SYJFeedbackViewController.h"
#import "PushNotificationViewController.h"
@interface SYJSetUpViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *basicArrs;
//@property(nonatomic,strong)SYJPrivacyViewController *privacy;

@property(nonatomic,strong)SYJSecurityViewController *security;
@property(nonatomic,strong)SYJFeedbackViewController *FeedbackView;
@property(nonatomic,strong)PushNotificationViewController *PushNotificationView;
@end

@implementation SYJSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设置";
    [self setUI];
}
-(void)setUI
{
    self.signOut.layer.borderColor=[SYJColor(255, 120, 38, 1) CGColor];
    self.signOut.layer.borderWidth=1;
    self.tableView.separatorColor=SYJColor(223, 223, 223, 1);
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
    self.tableView.tableFooterView=footerView;
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 12)];
    self.tableView.tableHeaderView=headerView;
    self.tableView.backgroundColor=SYJColor(248, 248, 248, 1);
    self.tableView.scrollEnabled=NO;
}
//退出登录
- (IBAction)signOut:(UIButton *)sender {
   // NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    UIAlertAction *agreeAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
        //请求delete
        __weak SYJSetUpViewController *weakSelf = self;
        [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] logout:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (error != nil) {
                    [weakSelf showHint:error.errorDescription];
                }
                else{
                    //[[ApplyViewController shareController] clear];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                    // NSLog(@"退出成功");
                    SYJLogInViewController *loginVC=[[SYJLogInViewController alloc]init];
                    SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:loginVC];
                    [[[UIApplication sharedApplication] keyWindow] setRootViewController:nav];
                }
            });
        });
        
    }];
    
    UIAlertController *alter=[SYJTool showAlterYesOrNo:@"确定要退出吗?"];
    [alter addAction:agreeAction];
    alter.view.tintColor=NAVBAR_Color;
    [self presentViewController:alter animated:YES completion:nil];
    
    
}
#pragma mark tableview协议
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.basicArrs.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;//44
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 12;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellSYJSetUpVC=@"idSYJSetUpViewController";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellSYJSetUpVC];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellSYJSetUpVC];
    }
    cell.textLabel.text=self.basicArrs[indexPath.row];
    cell.textLabel.textColor=SYJColor(51, 51, 51, 1);
    //取消选中状态
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    //箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==1) {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%0.2fM",[SYJTool folderSizeAtPath]];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row==0)//隐私和通知
    {
       // [self.navigationController pushViewController:self.privacy animated:YES];
    [self.navigationController pushViewController:self.PushNotificationView animated:YES];
    }
    else if (indexPath.row==1)//数据缓存
    {
        
        UIAlertAction *Action=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SYJTool cleanCache:^{
                [self.tableView reloadData];
            }];
        }];
        UIAlertController *alter=[SYJTool showAlterYesOrNo:@"确定要清除吗?"];
        [alter addAction:Action];
        alter.view.tintColor=NAVBAR_Color;
        [self presentViewController:alter animated:YES completion:nil];
    }
    else if (indexPath.row==2)//账户安全
    {
        [self.navigationController pushViewController:self.security animated:YES];
    }
    else if (indexPath.row==3)//意见反馈
    {
        [self.navigationController pushViewController:self.FeedbackView animated:YES];
    }

}
#pragma mark - ################################ 访问器方法 ################################
-(NSArray*)basicArrs
{
    if (_basicArrs==nil) {
        _basicArrs=@[@"隐私和通知",@"数据与缓存",@"账号与安全",@"意见反馈"];
    }
    return _basicArrs;
}
-(PushNotificationViewController*)PushNotificationView
{
    if (_PushNotificationView==nil) {
        _PushNotificationView = [[PushNotificationViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _PushNotificationView;
}
-(SYJSecurityViewController *)security
{
    if (_security==nil) {
        _security=[[SYJSecurityViewController alloc]init];
    }
    return _security;
}
-(SYJFeedbackViewController*)FeedbackView
{
    if (_FeedbackView==nil) {
        _FeedbackView=[[SYJFeedbackViewController alloc]init];
    }
    return _FeedbackView;
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
