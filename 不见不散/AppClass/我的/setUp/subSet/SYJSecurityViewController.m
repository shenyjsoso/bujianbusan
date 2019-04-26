//
//  SYJSecurityViewController.m
//  不见不散
//
//  Created by soso on 2017/12/12.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJSecurityViewController.h"
#import "SYJAlterViewController.h"
@interface SYJSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  *tableView;
@property(nonatomic,strong)NSArray *basicArrs;

@end

@implementation SYJSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"账号与安全";
    [self.view addSubview:self.tableView];
}
#pragma mark tableview协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.basicArrs count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;//44
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString * cellSYJSecurityVC=@"idSYJSecurityViewController";
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellSYJSecurityVC];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellSYJSecurityVC];
        }
        //取消选中状态
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        //箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.detailTextLabel.text=@"不限";
    if (indexPath.row==0) {
        cell.detailTextLabel.text=[SYJTool getforkey:@"mobile"];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
        cell.textLabel.text = self.basicArrs[indexPath.row];
        cell.textLabel.textColor=SYJColor(51, 51, 51, 1);
        return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        SYJAlterViewController *Alter=[[SYJAlterViewController alloc]init];
        Alter.phoneStr=[SYJTool getforkey:@"mobile"];
        [self.navigationController pushViewController:Alter animated:YES];
    }
}
#pragma mark *************访问器************
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TABBAR_HEIGHT) style:UITableViewStylePlain];
        //cell与cell之间的线
        //_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=SYJColor(223, 223, 223, 1);
        _tableView.backgroundColor=SYJColor(248, 248, 248, 1);
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
        _tableView.tableFooterView=footerView;
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
        _tableView.tableHeaderView=headerView;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
-(NSArray*)basicArrs
{
    if (_basicArrs==nil) {
        _basicArrs=@[@"手机号",@"修改密码"];
    }
    return _basicArrs;
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
