//
//  SYJreportViewController.m
//  不见不散
//
//  Created by soso on 2018/3/13.
//  Copyright © 2018年 soso. All rights reserved.
//

#import "SYJreportViewController.h"
#import "SYJReportType.h"
@interface SYJreportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)UIView *bottomView;
@property (assign, nonatomic) NSIndexPath    *selIndex;   //单选选中的行
@end

@implementation SYJreportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"举报";
    [self loaddata];
    self.selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loaddata
{
    [self showHudInView:self.view hint:@"加载中..."];
    [HttpTool getWithPath:API_informtypes params:nil hearder:nil success:^(id json) {
        self.datas=[SYJReportType mj_objectArrayWithKeyValuesArray:json];
        [self.view addSubview:self.tableView];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)push
{
    NSLog(@"投诉%ld",(long)self.selIndex.row);
    NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%ld",self.customerId],@"type":[NSString stringWithFormat:@"%ld",self.selIndex.row+1]
                                 };
    NSLog(@"请求体%@",parameters);
    [HttpTool postWithPath:API_inform params:parameters hearder:nil success:^(id json) {
        [SYJProgressHUD showMessage:@"提交成功" inView:self.view afterDelayTime:1];
        [self performSelector:@selector(popNext) withObject:nil afterDelay:1.0f];
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
        [SYJProgressHUD showMessage:@"提交失败" inView:self.view afterDelayTime:1];
    }];
}
-(void)popNext
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ***********tableview代理**********

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYJReportType *type=self.datas[indexPath.row];
    static NSString *cellld=@"cellid";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellld];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellld];
    }
    if (_selIndex == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text=type.info;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //取消之前的选择
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.accessoryType = UITableViewCellAccessoryNone;
    
    //记录当前的选择的位置
    _selIndex = indexPath;
    
    //当前选择的打钩
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
#pragma mark *************访问器************
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
        //cell与cell之间的线
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor=SYJColor(248, 248, 248, 1);
        
        _tableView.tableFooterView=self.bottomView;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

-(UIView*)bottomView
{
    if (_bottomView==nil) {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, ScreenWidth-20, 50)];
        lab.text=@"请告诉我们举报的原因,我们将会在24小时内进行处理。";
        lab.textColor=[UIColor lightGrayColor];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:15];
        lab.numberOfLines=0;
        [_bottomView addSubview:lab];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10, 110, ScreenWidth-20, 50);
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor=SYJColor(228, 28, 13, 1);
        btn.layer.cornerRadius = 5.0;
        [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:btn];
    }
    return _bottomView;
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
