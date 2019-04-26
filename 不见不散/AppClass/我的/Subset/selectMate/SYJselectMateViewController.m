//
//  SYJselectMateViewController.m
//  不见不散
//
//  Created by soso on 2017/12/12.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJselectMateViewController.h"
#import "PickerTool.h"
#import "CityPickerTool.h"
#import "doublePickerTool.h"
#import "SYJMate.h"
#import "SYJAllTags.h"
@interface SYJselectMateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray *basicArrs;
@property(nonatomic,strong)SYJMate *infoArrs;
@property(nonatomic,strong)NSMutableArray *BloodArrs;
@property(nonatomic,strong)NSMutableArray *incomeArrs;
@property(nonatomic,strong)NSMutableArray *educationArrs;
@property(nonatomic,strong)NSMutableArray *jobArrs;
@property(nonatomic,strong)NSMutableArray *marriageArrs;
@property(nonatomic,strong)NSMutableArray *carAndhouseArrs;
@property(nonatomic,strong)NSMutableArray *ageArrs;
@property(nonatomic,strong)NSMutableArray *heightArrs;
@property(nonatomic,strong)NSMutableArray *weightArrs;

@property(nonatomic,strong)NSMutableArray *allTags;
@end

@implementation SYJselectMateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"择偶标准";
    [self.view addSubview:self.tableView];
    [self setRefresh];

}
-(void)setRefresh
{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
}
-(void)loadData
{
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [HttpTool getWithPath:API_Mate params:nil hearder:nil success:^(id json) {
        //NSLog(@"%@",json);
        self.infoArrs=[SYJMate mj_objectWithKeyValues:json];
        [self.tableView reloadData];
        //NSLog(@"%@",self.infoArrs);
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
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
        [self.tableView.mj_header endRefreshing];
    }];
    
    //所有标签
    [HttpTool getWithPath:API_alltags params:nil hearder:nil success:^(id json) {
        //NSLog(@"所有的标签%@",json);
        self.allTags=[SYJAllTags mj_objectArrayWithKeyValuesArray:json];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark tableview协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.basicArrs count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;//44
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellSYJselectMateVC=@"idSYJselectMateViewController";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellSYJselectMateVC];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellSYJselectMateVC];
    }
    //取消选中状态
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    //箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.detailTextLabel.text = self.infoArrs[indexPath.row];
    cell.textLabel.text = self.basicArrs[indexPath.row];
    cell.textLabel.textColor=SYJColor(51, 51, 51, 1);
    switch (indexPath.row) {
        case 0:
            if (![self.infoArrs.minAge isEqualToString:self.infoArrs.maxAge]) {
                cell.detailTextLabel.text=[self.infoArrs.minAge stringByAppendingString:[NSString stringWithFormat:@"-%@岁",self.infoArrs.maxAge]];
            }
            else {
                if ([self.infoArrs.minAge isEqualToString:@"不限"]) {
                    cell.detailTextLabel.text=@"不限";
                }
                else
                {
                    cell.detailTextLabel.text=[self.infoArrs.minAge stringByAppendingString:@"岁"];
                }
            }
            break;
        case 1:
            
            if (![self.infoArrs.minHeight isEqualToString:self.infoArrs.maxHeight]) {
                cell.detailTextLabel.text=[self.infoArrs.minHeight stringByAppendingString:[NSString stringWithFormat:@"-%@cm",self.infoArrs.maxHeight]];
            }
            else {
                if ([self.infoArrs.minHeight isEqualToString:@"不限"]) {
                    cell.detailTextLabel.text=@"不限";
                }
                else
                {
                    cell.detailTextLabel.text=[self.infoArrs.minHeight stringByAppendingString:@"cm"];
                }
            }
            break;
        case 2:
            if (![self.infoArrs.minWeight isEqualToString:self.infoArrs.maxWeight]) {
                cell.detailTextLabel.text=[self.infoArrs.minWeight stringByAppendingString:[NSString stringWithFormat:@"-%@kg",self.infoArrs.maxWeight]];
            }
            else {
                if ([self.infoArrs.minWeight isEqualToString:@"不限"]) {
                    cell.detailTextLabel.text=@"不限";
                }
                else
                {
                    cell.detailTextLabel.text=[self.infoArrs.minWeight stringByAppendingString:@"kg"];
                }
            }
            break;
        case 3:
            cell.detailTextLabel.text=self.infoArrs.blood;
            break;
        case 4:
            if ([self.infoArrs.nowProvince isEqualToString:self.infoArrs.nowCity]) {
                cell.detailTextLabel.text=self.infoArrs.nowProvince;
            }
            else if ([self.infoArrs.nowCity isEqualToString:@"不限"])
            {
                cell.detailTextLabel.text=self.infoArrs.nowProvince;
            }
            else
            {
                cell.detailTextLabel.text=[self.infoArrs.nowProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.infoArrs.nowCity]];
            }
            break;
        case 5:
            if ([self.infoArrs.censusProvince isEqualToString:self.infoArrs.censusCity]) {
                cell.detailTextLabel.text=self.infoArrs.censusProvince;
            }
            else if ([self.infoArrs.censusCity isEqualToString:@"不限"])
            {
                cell.detailTextLabel.text=self.infoArrs.censusProvince;
            }
            else
            {
                cell.detailTextLabel.text=[self.infoArrs.censusProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.infoArrs.censusCity]];
            }
            break;
        case 6:
            cell.detailTextLabel.text=self.infoArrs.annualIncome;
            break;
        case 7:
            cell.detailTextLabel.text=self.infoArrs.education;
            break;
        case 8:
            cell.detailTextLabel.text=self.infoArrs.profession;
            break;
        case 9:
            cell.detailTextLabel.text=self.infoArrs.marriage;
            break;
        case 10:
            cell.detailTextLabel.text=self.infoArrs.car;
            break;
        case 11:
            cell.detailTextLabel.text=self.infoArrs.house;
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *celler=[tableView cellForRowAtIndexPath:indexPath];
    tableView.userInteractionEnabled=NO;
    //城市滚轮
    if (indexPath.row==4||indexPath.row==5) {
        CityPickerTool *pick=[[CityPickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-250-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 250)];
        pick.provincePick=@"不限";
        pick.cityPick=@"不限";
        pick.dataSource=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"citys" ofType:@"plist"]];

        __block CityPickerTool *blockPicker = pick;
        //__weak typeof (self) weakSelf = self;
        pick.callBlock = ^(NSString *pickDate, NSString *pickDatetwo) {
            if (pickDate) {
                if ([pickDate isEqualToString:pickDatetwo]) {
                    celler.detailTextLabel.text=pickDate;
                }
                else if ([pickDatetwo isEqualToString:@"不限"])
                {
                    celler.detailTextLabel.text=pickDate;
                }
                else
                {
                    celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@" %@",pickDatetwo]];
                }
                NSDictionary *params=[NSDictionary dictionary];
                if (indexPath.row==4) {
                    params=@{@"nowProvince":pickDate,
                             @"nowCity":pickDatetwo
                             };
                }
                else if (indexPath.row==5)
                {
                    params=@{@"censusProvince":pickDate,
                             @"censusCity":pickDatetwo
                             };
                }
                
//                NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                [HttpTool putWithPath:API_Mate params:params hearder:nil success:^(id json) {
                    //NSLog(@"修改成功%@",json);
                    [self loadData];
                } failure:^(NSError *error) {
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
            [blockPicker removeFromSuperview];
            tableView.userInteractionEnabled=YES;
        };
        [self.view addSubview:pick];
    }
    else if (indexPath.row==0||indexPath.row==1||indexPath.row==2)
    {
        //******************************年龄身高体重
        doublePickerTool *pick=[[doublePickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-250-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 250)];
        pick.minPick=@"不限";
        pick.maxPick=@"不限";
        switch (indexPath.row) {
            case 0:
                pick.dataSource=self.ageArrs;
                break;
            case 1:
                pick.dataSource=self.heightArrs;
                break;
            case 2:
                pick.dataSource=self.weightArrs;
                break;
            default:
                break;
        }
        __block doublePickerTool *blockPicker = pick;
        //__weak typeof (self) weakSelf = self;

        pick.callBlock = ^(NSString *pickDate, NSString *pickDatetwo) {
            if (pickDate) {
                //celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@"-%@",pickDatetwo]];
                NSDictionary *params=[NSDictionary dictionary];
                if (indexPath.row==0) {
                    if (![pickDate isEqualToString:pickDatetwo]) {
                        celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@"-%@岁",pickDatetwo]];
                    }
                    else if([pickDate isEqualToString:pickDatetwo]){
                        if ([pickDate isEqualToString:@"不限"]) {
                            celler.detailTextLabel.text=@"不限";
                        }
                        else
                        {
                            celler.detailTextLabel.text=[pickDate stringByAppendingString:@"岁"];
                        }
                        
                    }
                    
                    params=@{@"minAge":pickDate,
                             @"maxAge":pickDatetwo
                             };
                }
                else if (indexPath.row==1)
                {
                    if (![pickDate isEqualToString:pickDatetwo]) {
                        celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@"-%@cm",pickDatetwo]];
                    }
                    else if([pickDate isEqualToString:pickDatetwo]){
                        if ([pickDate isEqualToString:@"不限"]) {
                            celler.detailTextLabel.text=@"不限";
                        }
                        else
                        {
                            celler.detailTextLabel.text=[pickDate stringByAppendingString:@"cm"];
                        }
                        
                    }
                    params=@{@"minHeight":pickDate,
                             @"maxHeight":pickDatetwo
                             };
                }
                else if (indexPath.row==2)
                {
                    if (![pickDate isEqualToString:pickDatetwo]) {
                        celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@"-%@kg",pickDatetwo]];
                    }
                    else if([pickDate isEqualToString:pickDatetwo]){
                        if ([pickDate isEqualToString:@"不限"]) {
                            celler.detailTextLabel.text=@"不限";
                        }
                        else
                        {
                            celler.detailTextLabel.text=[pickDate stringByAppendingString:@"kg"];
                        }
                        
                    }
                    params=@{@"minWeight":pickDate,
                             @"maxWeight":pickDatetwo
                             };
                }
                
//                NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                [HttpTool putWithPath:API_Mate params:params hearder:nil success:^(id json) {
                    //NSLog(@"修改成功%@",json);
                    [self loadData];
                } failure:^(NSError *error) {
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
            [blockPicker removeFromSuperview];
            tableView.userInteractionEnabled=YES;
        };
        [self.view addSubview:pick];
    }
    //单滚轮
    else
    {
        PickerTool *Pick = [[PickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-250-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 250)];
        Pick.sexPick=@"不限";
            switch (indexPath.row) {
                case 3:
                    Pick.dataSource=self.BloodArrs;
                    break;
                case 6:
                    Pick.dataSource=self.incomeArrs;
                    break;
                case 7:
                    Pick.dataSource=self.educationArrs;
                    break;
                case 8:
                    Pick.dataSource=self.jobArrs;
                    break;
                case 9:
                    Pick.dataSource=self.marriageArrs;
                    break;
                case 10:
                    Pick.dataSource=self.carAndhouseArrs;
                    break;
                case 11:
                    Pick.dataSource=self.carAndhouseArrs;
                    break;
                default:
                    break;
            }
        __block PickerTool *blockPicker = Pick;
        //__weak typeof (self) weakSelf = self;
        Pick.callBlock = ^(NSString *pickDate) {
            if (pickDate) {

                NSDictionary*parameters=[NSDictionary dictionary];

                 if (indexPath.row==3)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"blood":pickDate};
                }
                else if (indexPath.row==6)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"annualIncome":pickDate};
                }
                else if (indexPath.row==7)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"education":pickDate};
                }
                else if (indexPath.row==8)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"profession":pickDate};
                }
                else if (indexPath.row==9)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"marriage":pickDate};
                }
                else if (indexPath.row==10)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"car":pickDate};
                }
                else if (indexPath.row==11)
                {
                    celler.detailTextLabel.text=pickDate;
                    parameters = @{@"house":pickDate};
                }
//                NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                [HttpTool putWithPath:API_Mate params:parameters hearder:nil success:^(id json) {
                    //(@"修改成功%@",json);
                    [self loadData];
                } failure:^(NSError *error) {
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
            [blockPicker removeFromSuperview];
            tableView.userInteractionEnabled=YES;
        };
        [self.view addSubview:Pick];
    }
}
#pragma mark - ################################ 访问器方法 ################################
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-STATUS_HEIGHT-NAVBAR_HEIGHT) style:UITableViewStylePlain ];
        //cell与cell之间的线
        //_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //cell与cell之间的线的颜色
        _tableView.separatorColor=SYJColor(223, 223, 223, 1);
        //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor=SYJColor(248, 248, 248, 1);
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 27)];
        _tableView.tableFooterView=footerView;
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        _tableView.tableHeaderView=headerView;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
-(NSArray*)basicArrs
{
    if (_basicArrs==nil) {
        _basicArrs=@[@"年龄",@"身高",@"体重",@"血型",@"现居地",@"户籍",@"年收入",@"学历",@"职业",@"婚史",@"购车情况",@"购房情况"];
    }
    return _basicArrs;
}

-(NSMutableArray*)ageArrs
{
    if (_ageArrs==nil) {
        
        NSMutableArray *arr=[NSMutableArray arrayWithObjects:@"不限",nil];
        for (NSInteger i=16; i<81; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        _ageArrs=[NSMutableArray arrayWithObjects:arr,arr, nil];
    }
    return _ageArrs;
}
-(NSMutableArray*)heightArrs
{
    if (_heightArrs==nil) {
        NSMutableArray *arr=[NSMutableArray arrayWithObjects:@"不限",nil];
        for (NSInteger i=140; i<221; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        _heightArrs=[NSMutableArray arrayWithObjects:arr,arr, nil];
    }
    return _heightArrs;
}
-(NSMutableArray*)weightArrs
{
    if (_weightArrs==nil) {
        NSMutableArray *arr=[NSMutableArray arrayWithObjects:@"不限",nil];
        for (NSInteger i=40; i<121; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        _weightArrs=[NSMutableArray arrayWithObjects:arr,arr, nil];
    }
    return _weightArrs;
}
-(NSMutableArray*)BloodArrs
{
    if (_BloodArrs==nil) {
        //_BloodArrs=[NSMutableArray arrayWithObjects:@"不限",@"A",@"B",@"O",@"AB", nil];
        SYJAllTags *tags=_allTags[8];
        _BloodArrs=[NSMutableArray arrayWithObjects:@"不限",nil];
        [_BloodArrs addObjectsFromArray:tags.tags];
    }
    return _BloodArrs;
}
-(NSMutableArray*)incomeArrs
{
    if (_incomeArrs==nil) {
        //_incomeArrs=[NSMutableArray arrayWithObjects:@"不限",@"10W以下",@"10-30W",@"30-50W",@"50-100W",@"100W以上", nil];
        SYJAllTags *tags=_allTags[0];
        _incomeArrs=[NSMutableArray arrayWithObjects:@"不限",nil];
        [_incomeArrs addObjectsFromArray:tags.tags];
    }
    return _incomeArrs;
}
-(NSMutableArray*)educationArrs
{
    if (_educationArrs==nil) {
        //_educationArrs=[NSMutableArray arrayWithObjects:@"不限",@"初中及以上",@"高中及以上",@"大专及以上",@"本科及以上",@"硕士及以上",nil];
        SYJAllTags *tags=_allTags[14];
        _educationArrs=[NSMutableArray arrayWithObjects:@"不限",nil];
        [_educationArrs addObjectsFromArray:tags.tags];
    }
    return _educationArrs;
}
-(NSMutableArray*)jobArrs
{
    if (_jobArrs==nil) {
       // _jobArrs=[NSMutableArray arrayWithObjects:@"不限",@"学生",@"公务员",@"法律",@"IT互联网",@"教育科研",@"医疗健康",@"文化艺术",@"影视娱乐",@"工业",@"媒体公关",@"金融",@"零售",@"其他", nil];
        SYJAllTags *tags=_allTags[3];
        _jobArrs=[NSMutableArray arrayWithObjects:@"不限",nil];
        [_jobArrs addObjectsFromArray:tags.tags];
    }
    return _jobArrs;
}
-(NSMutableArray*)marriageArrs
{
    if (_marriageArrs==nil) {
        //_marriageArrs=[NSMutableArray arrayWithObjects:@"不限",@"未婚",@"离异",@"丧偶", nil];
        SYJAllTags *tags=_allTags[1];
        _marriageArrs=[NSMutableArray arrayWithObjects:@"不限",nil];
        [_marriageArrs addObjectsFromArray:tags.tags];
    }
    return _marriageArrs;
}
-(NSMutableArray*)carAndhouseArrs
{
    if (_carAndhouseArrs==nil) {
        //_carAndhouseArrs=[NSMutableArray arrayWithObjects:@"不限",@"已购买",@"未购买" ,nil];
        SYJAllTags *tags=_allTags[6];
        _carAndhouseArrs=[NSMutableArray arrayWithObjects:@"不限",nil];
        [_carAndhouseArrs addObjectsFromArray:tags.tags];
    }
    return _carAndhouseArrs;
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
