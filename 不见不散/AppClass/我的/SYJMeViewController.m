//
//  SYJMeViewController.m
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJMeViewController.h"
#import "SYJHeadTableViewCell.h"
#import "SYJFunctionTableViewCell.h"
#import "SYJSetUpViewController.h"
#import "SYJselectMateViewController.h"
#import "SYJWriteViewController.h"
#import "SYJMyInfo.h"
#import "SYJAllTags.h"
#import "PickerTool.h"
#import "CityPickerTool.h"
#import "DatePickerTool.h"
#import "SYJAlbumViewController.h"
#import "SYJInterestVC.h"
#import "SYJLabelVC.h"

//#import "CFYNavigationBarTransition.h"
static NSString * firstcell = @"SYJHeadTableViewCell";
static NSString * secondcell = @"SYJFunctionTableViewCell";
@interface SYJMeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView  *tableView;
@property(nonatomic,strong)NSArray *basicArrs;

@property(nonatomic,strong)SYJselectMateViewController *mateVC;
@property(nonatomic,strong)SYJAlbumViewController *AlbumVC;
@property(nonatomic,strong)SYJWriteViewController *writeVC;
@property(nonatomic,copy)NSString *PersonString;
@property(nonatomic,strong)SYJMyInfo *myInfo;

@property(nonatomic,strong)NSMutableArray *ageArrs;
@property(nonatomic,strong)NSMutableArray *heightArrs;
@property(nonatomic,strong)NSMutableArray *weightArrs;
@property(nonatomic,strong)NSMutableArray *BloodArrs;

@property(nonatomic,strong)NSMutableArray *incomeArrs;
@property(nonatomic,strong)NSMutableArray *educationArrs;
@property(nonatomic,strong)NSMutableArray *jobArrs;
@property(nonatomic,strong)NSMutableArray *marriageArrs;
@property(nonatomic,strong)NSMutableArray *carAndhouseArrs;
@property(nonatomic,strong)NSMutableArray *childrenArs;

@property(nonatomic,strong)NSMutableArray *allTags;
@end

@implementation SYJMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title=@"我";
    //右边的bar
    UIImage *picture=[[UIImage imageNamed:@"设置"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:picture style:UIBarButtonItemStylePlain target:self action:@selector(nextView)];
    self.navigationItem.rightBarButtonItem=right;
    
    //[self loadData];
    [self setRefresh];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClick) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
    

}
-(void)nextView
{
    SYJSetUpViewController *setup=[[SYJSetUpViewController alloc]init];
    [self.navigationController pushViewController:setup animated:YES];
}
-(void)tabbarButtonClick
{
    //判断window是否在窗口上
    if (self.view.window == nil) return;
    //判断当前的view是否与窗口重合  nil代表屏幕左上角
    if (![self.view hu_intersectsWithAnotherView:nil]) return;
    if (self.tableView.mj_header.isRefreshing) return;
    
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
    [HttpTool getWithPath:API_MyInfo params:nil hearder:nil success:^(id json) {
        NSLog(@"%@",json);
        self.myInfo=[SYJMyInfo mj_objectWithKeyValues:json];
        NSLog(@"户籍%@,%@",self.myInfo.censusProvince,self.myInfo.censusCity);
        //缓存头像
        if (self.myInfo.avatar) {
            NSString *Avatar=[API_avatar stringByAppendingString:self.myInfo.avatar];
            [UserCacheManager updateMyAvatar:Avatar];
        }
        [self.tableView reloadData];
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

#pragma mark ***********tableview代理**********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else if (section==1)
    {
        return 1;
    }
    else
    {
        return [self.basicArrs[section-2] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 105;
    }
    else if(indexPath.section==1)
    {
        return 85;//44
    }else
    {
        return 47;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section>2) {
        return 10;
    }
    else if(section==1||section==2)
    {
        return 6;
    }
    else
    {
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        customView.backgroundColor= SYJColor(248, 248, 248, 1);
        return customView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        SYJHeadTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:firstcell forIndexPath:indexPath];
        //取消选中状态
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        //昵称
        cell.nameLbl.text=self.myInfo.nickName;
        //self.PersonString=self.myInfo.signature;
        //个性签名
        if (!self.myInfo.signature) {
            [cell changePersonString:self.PersonString];
        }else
        {
            [cell changePersonString:self.myInfo.signature];
        }
        //头像
        if (self.myInfo.avatar) {
            NSString *sd=[API_avatar stringByAppendingString:self.myInfo.avatar];
            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:sd] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"]];
            //[cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:sd] forState:UIControlStateNormal];
        }
        __weak typeof (self) weakSelf = self;
        cell.block = ^(id sender) {
            __strong typeof(self) strongSelf = weakSelf;
            if ([sender isKindOfClass:[UILabel class]]) {
                //NSLog(@"点击了个性签名");
                _writeVC=[[SYJWriteViewController alloc]initWithString:@"写下你的个性签名(不能超过20个字)" Length:20 Par:@"signature"];
                _writeVC.navigationItem.title=@"个性签名";
                _writeVC.block = ^() {
                    [strongSelf loadData];
                };
                [strongSelf.navigationController pushViewController:_writeVC animated:YES];
            }
            else if([sender isKindOfClass:[UIButton class]])
            {
                //NSLog(@"点击了头像");
                //调用系统相册的类
                UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
                //调用系统相册的类
                pickerController = [[UIImagePickerController alloc]init];
                pickerController.delegate = self;
                //设置选取的照片是否可编辑
                pickerController.allowsEditing = YES;
                UIAlertController *alterController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *PhotoLibraryAction=[UIAlertAction actionWithTitle:@"从相册选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //设置相册呈现的样式
                    pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:pickerController animated:YES completion:nil];
                }];
                UIAlertAction *CameraLibraryAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                    //设置相册呈现的样式
                    pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
                    [pickerController.navigationController setNavigationBarHidden:YES];
                    [self presentViewController:pickerController animated:YES completion:nil];
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alterController addAction:PhotoLibraryAction];
                [alterController addAction:CameraLibraryAction];
                [alterController addAction:cancelAction];
                //alterController.view.tintColor=NAVBAR_Color;
                [self presentViewController:alterController animated:YES completion:nil];
                
            }
            else{
               // NSLog(@"点击了");
            }
        };
        return cell;
    }
    else if(indexPath.section==1)
    {
        SYJFunctionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:secondcell forIndexPath:indexPath];
        //取消选中状态
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        __weak typeof (self) weakSelf = self;
        cell.block = ^(UIButton *sender) {
            __strong typeof(self) strongSelf = weakSelf;
            switch (sender.tag) {
                case 1:
                    //NSLog(@"会员中心");
//                    [SYJProgressHUD showMessage:@"会员功能暂未开放" inView:self.view afterDelayTime:1];
                    break;
                case 2:
                    //NSLog(@"择偶标准");
                    _mateVC=[[SYJselectMateViewController alloc]init];
                    [strongSelf.navigationController pushViewController:_mateVC animated:YES];
                    break;
                case 3:
                    //NSLog(@"个人相册");
                    _AlbumVC=[[SYJAlbumViewController alloc]init];
                    [strongSelf.navigationController pushViewController:_AlbumVC animated:YES];
                    break;
                default:
                    break;
            }
        };
        return cell;
    }
    else
    {
        static NSString * cellSYJMeVC=@"idSYJMeViewController";
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellSYJMeVC];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellSYJMeVC];
        }
        //取消选中状态
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        //箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section==2) {
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text=self.myInfo.nickName;
                    
                    break;
                case 1:
                    cell.detailTextLabel.text=[SYJTool timeWithTimeIntervalString:[NSString stringWithFormat:@"%lld",self.myInfo.birthday]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    break;
                case 2:
                    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld岁",(long)self.myInfo.age];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    break;
                case 3:
                    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ldcm",(long)self.myInfo.height];
                    break;
                case 4:
                    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ldkg",(long)self.myInfo.weight];
                    break;
                case 5:
                    cell.detailTextLabel.text=self.myInfo.blood;
                    break;
                case 6:
                    cell.detailTextLabel.text=[self.myInfo.nowProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.myInfo.nowCity]];
                    break;
                default:
                    break;
            }
        }else if (indexPath.section==3)//兴趣爱好标签
        {
            switch (indexPath.row) {
                case 0:
                    if (self.myInfo.interest) {
                        if ([self.myInfo.interest componentsSeparatedByString:@","].count>1) {

                            cell.detailTextLabel.text =[[[self.myInfo.interest componentsSeparatedByString:@","] objectAtIndex:0] stringByAppendingString:@"..."];
                        }else  cell.detailTextLabel.text=self.myInfo.interest;
                    }
                    break;
                case 1:
                    if (self.myInfo.label) {
                        if ([self.myInfo.label componentsSeparatedByString:@","].count>1) {
                            cell.detailTextLabel.text =[[[self.myInfo.label componentsSeparatedByString:@","] objectAtIndex:0] stringByAppendingString:@"..."];
                        }else cell.detailTextLabel.text=self.myInfo.label;
                        
                    }
                    break;
                default:
                    break;
            }
        }
        else if (indexPath.section==4)
        {
            switch (indexPath.row) {
                case 0:
                    if (self.myInfo.censusProvince&&self.myInfo.censusCity) {
                        cell.accessoryType=UITableViewCellAccessoryNone;
                    }
                    cell.detailTextLabel.text=[self.myInfo.censusProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.myInfo.censusCity]];
                    break;
                case 1:
                    cell.detailTextLabel.text=self.myInfo.education;
                    break;
                case 2:
                    cell.detailTextLabel.text=self.myInfo.profession;
                    break;
                case 3:
                    cell.detailTextLabel.text=self.myInfo.annualIncome;
                    break;
                case 4:
                    cell.detailTextLabel.text=self.myInfo.marriage;
                    break;
                case 5:
                    cell.detailTextLabel.text=self.myInfo.children;
                    break;
                case 6:
                    cell.detailTextLabel.text=self.myInfo.car;
                    break;
                case 7:
                    cell.detailTextLabel.text=self.myInfo.house;
                    break;
                default:
                    break;
            }
        }
        cell.textLabel.text=self.basicArrs[indexPath.section-2][indexPath.row];
        cell.textLabel.textColor=SYJColor(51, 51, 51, 1);
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *celler=[tableView cellForRowAtIndexPath:indexPath];
    //tableView.userInteractionEnabled=NO;
    if (indexPath.section==2) {
        tableView.userInteractionEnabled=NO;
        if(indexPath.row==0)
        {
            tableView.userInteractionEnabled=YES;
            __weak typeof (self) weakSelf = self;
            _writeVC=[[SYJWriteViewController alloc]initWithString:@"写下你的昵称(不能超过15个字)" Length:15 Par:@"nickName"];
            _writeVC.navigationItem.title=@"昵称";
            _writeVC.block = ^{
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf loadData];
            };
            [self.navigationController pushViewController:_writeVC animated:YES];
        }
        
        else if(indexPath.row==1)
        {
//            DatePickerTool *datePicker = [[DatePickerTool alloc] initWithFrame:CGRectMake(0, ScreenHeight-300-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 300)];
//            __block DatePickerTool *blockPick = datePicker;
//            //__weak typeof (self) weakSelf = self;
//            datePicker.callBlock = ^(NSString *pickDate) {
//                if (pickDate) {
//                    celler.detailTextLabel.text=pickDate;
//                    long long age=[SYJTool getagetime:pickDate];
//                    NSDictionary *params=@{@"birthday":@(age)};
//                    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
//                    [HttpTool putWithPath:API_MyInfo params:params hearder:value success:^(id json) {
//                        //NSLog(@"修改成功%@",json);
//                        [self loadData];
//                    } failure:^(NSError *error) {
//                        if (error.code==-1011) {
//                            NSDictionary *errorDict=[SYJTool code1011:error];
//                            [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
//                        }
//                        else if (error.localizedDescription)
//                        {
//                            [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
//                        }
//                        else{
//                            [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
//                        }
//                    }];
//                }
//                [blockPick removeFromSuperview];
//                tableView.userInteractionEnabled=YES;
//            };
//            [self.view addSubview:datePicker];
            tableView.userInteractionEnabled=YES;
        }
        else if(indexPath.row==2)
        {
            tableView.userInteractionEnabled=YES;
        }
        else if (indexPath.row>2&&indexPath.row<6) {
             PickerTool *Pick = [[PickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-300-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 300)];
            switch (indexPath.row) {
                case 3:
                    Pick.dataSource=self.heightArrs;
                    Pick.sexPick=self.heightArrs[0];
                    break;
                case 4:
                    Pick.dataSource=self.weightArrs;
                    Pick.sexPick=self.weightArrs[0];
                    break;
                case 5:
                    Pick.dataSource=self.BloodArrs;
                    Pick.sexPick=self.BloodArrs[0];
                    break;
                default:
                    break;
            }
            __block PickerTool *blockPicker = Pick;
            
            Pick.callBlock = ^(NSString *pickDate) {
                if (pickDate) {
                    
                    NSDictionary*parameters=[NSDictionary dictionary];
                    if (indexPath.row==3) {
                        celler.detailTextLabel.text=[pickDate stringByAppendingString:@"cm"];
                        parameters = @{@"height":pickDate};
                    }
                    else if (indexPath.row==4)
                    {
                        celler.detailTextLabel.text=[pickDate stringByAppendingString:@"kg"];
                        parameters = @{@"weight":pickDate};
                    }
                    else{
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"blood":pickDate};
                    }
//                    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                    [HttpTool putWithPath:API_MyInfo params:parameters hearder:nil success:^(id json) {
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
            [self.view addSubview:Pick];
            
        }
        else if (indexPath.row==6)
        {
            //城市滚轮
            CityPickerTool *pick=[[CityPickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-300-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 300)];
            pick.cityPick=@"东城区";
            pick.provincePick=@"北京";
            NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"citys" ofType:@"plist"]];
            [arr removeObjectAtIndex:0];
            for (NSDictionary *pro in arr) {
                NSMutableArray *data=[pro objectForKey:@"city"];
                [data removeObjectAtIndex:0];
            }
            pick.dataSource=arr;
            __block CityPickerTool *blockPicker = pick;
            //__weak typeof (self) weakSelf = self;
            pick.callBlock = ^(NSString *pickDate, NSString *pickDatetwo) {
                if (pickDate) {
                    celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@" %@",pickDatetwo]];
                    
                    NSDictionary *params=@{@"nowProvince":pickDate,
                                           @"nowCity":pickDatetwo
                                           };
//                    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                    [HttpTool putWithPath:API_MyInfo params:params hearder:nil success:^(id json) {
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
    
    }
    else if (indexPath.section==3)//兴趣爱好和标签
    {
        tableView.userInteractionEnabled=YES;
        if (indexPath.row==0) {
            //兴趣爱好
            SYJAllTags *tags=_allTags[11];
            SYJInterestVC *interest=[[SYJInterestVC alloc]init];
            interest.interestArr=tags.tags;
            
            if (self.myInfo.interest) {
                if (self.myInfo.interest.length>0) {
                    interest.interestStr=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@",%@",self.myInfo.interest]];
                }
                else
                {
                    interest.interestStr=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",self.myInfo.interest]];
                }
                
            }
            else
            {
                interest.interestStr=[[NSMutableString alloc]initWithString:@""];
            }
            interest.block = ^{
                [self loadData];
            };
            [self.navigationController pushViewController:interest animated:YES];
        }
        else if (indexPath.row==1)
        {
            //我的标签
            SYJAllTags *tags=_allTags[10];
            SYJLabelVC *label=[[SYJLabelVC alloc]init];
            label.LabelArr=tags.tags;
            if (self.myInfo.label) {
                if (self.myInfo.label.length>0) {
                    label.LabelStr=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@",%@",self.myInfo.label]];
                }
                else
                {
                    label.LabelStr=[[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",self.myInfo.label]];
                }
            }
            else
            {
                label.LabelStr=[[NSMutableString alloc]initWithString:@""];
            }
            label.block = ^{
                [self loadData];
            };
            [self.navigationController pushViewController:label animated:YES];
        }
    }
    else if (indexPath.section==4)
    {
        tableView.userInteractionEnabled=NO;
        if (indexPath.row==0) {
            if (self.myInfo.censusProvince&&self.myInfo.censusCity) {
                tableView.userInteractionEnabled=YES;
                return;
            }
            //城市滚轮
            CityPickerTool *pick=[[CityPickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-300-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 300)];
            pick.cityPick=@"东城区";
            pick.provincePick=@"北京";
            NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"citys" ofType:@"plist"]];
            [arr removeObjectAtIndex:0];
            //NSMutableArray *citydata=nil;
            for (NSDictionary *pro in arr) {
               NSMutableArray *data=[pro objectForKey:@"city"];
                [data removeObjectAtIndex:0];
            }
            
            pick.dataSource=arr;
            
            __block CityPickerTool *blockPicker = pick;
            //__weak typeof (self) weakSelf = self;
            pick.callBlock = ^(NSString *pickDate, NSString *pickDatetwo) {
                if (pickDate) {
                    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSDictionary *params=@{@"censusProvince":pickDate,
                                               @"censusCity":pickDatetwo
                                               };
//                        NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                        [HttpTool putWithPath:API_MyInfo params:params hearder:nil success:^(id json) {
                            //NSLog(@"修改成功%@",json);
//                            celler.detailTextLabel.text=[pickDate stringByAppendingString:[NSString stringWithFormat:@" %@",pickDatetwo]];
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
                    }];
                    UIAlertController *alter=[SYJTool showAlterYesOrNo:@"户籍确定后将不可更改！"];
                    [alter addAction:action];
                    alter.view.tintColor=NAVBAR_Color;
                    [self presentViewController:alter animated:YES completion:nil];
                    
                }
                [blockPicker removeFromSuperview];
                tableView.userInteractionEnabled=YES;
            };
            [self.view addSubview:pick];
        }
        else
        {
            PickerTool *Pick = [[PickerTool alloc]initWithFrame:CGRectMake(0, ScreenHeight-300-NAVBAR_HEIGHT-STATUS_HEIGHT, ScreenWidth, 300)];
            __block PickerTool *blockPicker = Pick;
            switch (indexPath.row) {
                case 1:
                    Pick.dataSource=self.educationArrs;
                    Pick.sexPick=self.educationArrs[0];
                    break;
                case 2:
                    Pick.dataSource=self.jobArrs;
                    Pick.sexPick=self.jobArrs[0];
                    break;
                case 3:
                    Pick.dataSource=self.incomeArrs;
                    Pick.sexPick=self.incomeArrs[0];
                    break;
                case 4:
                    Pick.dataSource=self.marriageArrs;
                    Pick.sexPick=self.marriageArrs[0];
                    break;
                case 5:
                    Pick.dataSource=self.childrenArs;
                    Pick.sexPick=self.childrenArs[0];
                    break;
                case 6:
                    Pick.dataSource=self.carAndhouseArrs;
                    Pick.sexPick=self.carAndhouseArrs[0];
                    break;
                case 7:
                    Pick.dataSource=self.carAndhouseArrs;
                    Pick.sexPick=self.carAndhouseArrs[0];
                    break;
                default:
                    break;
            }
            Pick.callBlock = ^(NSString *pickDate) {
                if (pickDate) {
                    
                    NSDictionary*parameters=[NSDictionary dictionary];
                    if (indexPath.row==1) {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"education":pickDate};
                    }
                    else if (indexPath.row==2)
                    {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"profession":pickDate};
                    }
                    else if (indexPath.row==3)
                    {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"annualIncome":pickDate};
                    }
                    else if (indexPath.row==4)
                    {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"marriage":pickDate};
                    }
                    else if (indexPath.row==5)
                    {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"children":pickDate};
                    }
                    else if (indexPath.row==6)
                    {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"car":pickDate};
                    }
                    else if (indexPath.row==7)
                    {
                        celler.detailTextLabel.text=pickDate;
                        parameters = @{@"house":pickDate};
                    }
//                    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
                    [HttpTool putWithPath:API_MyInfo params:parameters hearder:nil success:^(id json) {
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
            [self.view addSubview:Pick];
        }
    }
}
//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 10; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark ************imagePickerController代理*************
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //info是所选择照片的信息
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    //NSLog(@"info::::%@",info);
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    //UIButton *button = (UIButton *)[self.view viewWithTag:4];

    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //[button setImage:[resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];//如果按钮创建时用的是系统风格UIButtonTypeSystem，需要在设置图片一栏设置渲染模式为"使用原图"
    
//    NSData *imageData=UIImageJPEGRepresentation(resultImage, 1);
//  NSDictionary *params=@{@"avatar":imageData};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"上传中...";
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [HttpTool uploadImageWithPath:API_avatarShort params:nil hearder:nil thumbName:@"avatar" image:resultImage success:^(id json) {
       // NSLog(@"上传头像成功");
        [self loadData];
        [SYJTool saveUserDefault:@"YES" forkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]];
        
         [hud hideAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
         [hud hideAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    } progress:^(CGFloat progress) {
       // NSLog(@"上传头像中");
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    }];
    
    
}

#pragma mark *************访问器************
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TABBAR_HEIGHT-NAVBAR_HEIGHT-STATUS_HEIGHT) style:UITableViewStylePlain];
        //cell与cell之间的线
        //_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=SYJColor(223, 223, 223, 1);
        _tableView.backgroundColor=SYJColor(248, 248, 248, 1);
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
        _tableView.tableFooterView=footerView;
        [_tableView registerNib:[UINib nibWithNibName:@"SYJHeadTableViewCell" bundle:nil] forCellReuseIdentifier:firstcell];
        [_tableView registerNib:[UINib nibWithNibName:@"SYJFunctionTableViewCell" bundle:nil] forCellReuseIdentifier:secondcell];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
-(NSArray*)basicArrs
{
    if (_basicArrs==nil) {
        _basicArrs=@[@[@"昵称",@"生日",@"年龄",@"身高",@"体重",@"血型",@"现居地"],@[@"兴趣爱好",@"我的标签"],@[@"户籍",@"学历",@"职业",@"年收入",@"婚史",@"有无子女",@"购车情况",@"购房情况"]];
    }
    return _basicArrs;
}
-(NSString*)PersonString
{
    if (_PersonString==nil) {
        _PersonString=@"个性签名";
    }
    return _PersonString;
}

-(NSMutableArray*)heightArrs
{
    if (_heightArrs==nil) {
        _heightArrs=[NSMutableArray array];
        for (NSInteger i=140; i<221; i++) {
            [_heightArrs addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    return _heightArrs;
}
-(NSMutableArray*)weightArrs
{
    if (_weightArrs==nil) {

        _weightArrs=[NSMutableArray array];
        for (NSInteger i=40; i<121; i++) {
            [_weightArrs addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    return _weightArrs;
}
-(NSMutableArray*)BloodArrs
{
    if (_BloodArrs==nil) {
        SYJAllTags *tags=_allTags[8];
        _BloodArrs=tags.tags;
        
    }
    return _BloodArrs;
}
-(NSMutableArray*)incomeArrs
{
    if (_incomeArrs==nil) {
        SYJAllTags *tags=_allTags[0];
        _incomeArrs=tags.tags;
    }
    return _incomeArrs;
}
-(NSMutableArray*)educationArrs
{
    if (_educationArrs==nil) {
        SYJAllTags *tags=_allTags[4];
        _educationArrs=tags.tags;
    }
    return _educationArrs;
}
-(NSMutableArray*)jobArrs
{
    if (_jobArrs==nil) {
        SYJAllTags *tags=_allTags[3];
        _jobArrs=tags.tags;
        
    }
    return _jobArrs;
}
-(NSMutableArray*)marriageArrs
{
    if (_marriageArrs==nil) {
        SYJAllTags *tags=_allTags[1];
        _marriageArrs=tags.tags;
    }
    return _marriageArrs;
}
-(NSMutableArray*)carAndhouseArrs
{
    if (_carAndhouseArrs==nil) {
        SYJAllTags *tags=_allTags[6];
        _carAndhouseArrs=tags.tags;
        
    }
    return _carAndhouseArrs;
}
-(NSMutableArray*)childrenArs
{
    if (_childrenArs==nil) {
        SYJAllTags *tags=_allTags[13];
        _childrenArs=tags.tags;
    }
    return _childrenArs;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
