//
//  SYJMessageViewController.m
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJMessageViewController.h"
#import "SYJFriendTableViewCell.h"
#import "SYJMyFriend.h"
#import "UIImage+SYJImage.h"
#import "SYJUserInfoViewController.h"
#import "SYJMyInfo.h"

static NSString * cellid = @"SYJFriendTableViewCell";
@interface SYJMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *leftArray;
@property(nonatomic,strong)NSMutableArray *rightArray;

@property(nonatomic,strong)UIImageView *noFriendView;
//@property(nonatomic,strong)UIImageView *nochatView;

@end

@implementation SYJMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"消息";
    //self.tag = 0;
    [self initSegment];
    [self initTableView];
    //[self loadData];
    //[self setRefresh];
    //接收通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClick) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    //[self hideHud];
    //if (self.tag==0) {
        [self loadData];
    //}
    //else if(self.tag==1)
    //{
      //  [_ListView refreshDataSource];
    //}
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVBAR_Color] forBarMetrics:UIBarMetricsDefault];
}
//-(void)tabbarButtonClick
//{
//    //判断window是否在窗口上
//    if (self.view.window == nil) return;
//    //判断当前的view是否与窗口重合  nil代表屏幕左上角
//    if (![self.view hu_intersectsWithAnotherView:nil]) return;
//    if (self.leftTableView.mj_header.isRefreshing) return;
//    if (self.tag==1) return;
//    [self loadData];
//    
//}
//-(void)setRefresh
//{
//    self.leftTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    [self.leftTableView.mj_header beginRefreshing];
//}
- (void)initSegment{
    NSArray *array = [NSArray arrayWithObjects:@" 配对成功 ",@"我的聊天", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.selectedSegmentIndex = 0;
    segment.tintColor = NAVBAR_Color;
    segment.backgroundColor=[UIColor whiteColor];
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view).offset(30);
        
    }];
}
- (void)initTableView {
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 28+10, ScreenWidth, ScreenHeight-(28+10+TABBAR_HEIGHT+NAVBAR_HEIGHT+STATUS_HEIGHT)) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.separatorColor=SYJColor(223, 223, 223, 1);
    //_leftTableView.backgroundColor=SYJColor(248, 248, 248, 1);
    UIView *footerView=[[UIView alloc] init];
    
    _leftTableView.tableFooterView=footerView;
    _leftTableView.showsVerticalScrollIndicator = NO;
    [_leftTableView registerNib:[UINib nibWithNibName:@"SYJFriendTableViewCell" bundle:nil] forCellReuseIdentifier:cellid];
    [self.view addSubview:_leftTableView];
    //环信消息页面
    //_ListView=[[ConversationListController alloc]init];
    _ListView.view.frame=CGRectMake(0,28+10, ScreenWidth, ScreenHeight-(28+10+TABBAR_HEIGHT+NAVBAR_HEIGHT+STATUS_HEIGHT));
    [self addChildViewController:_ListView];
    [self.view addSubview:_ListView.view];
    if (self.tag==0) {
        [_ListView.view removeFromSuperview];
        [_ListView removeFromParentViewController];
    }

}

//点击不同分段就会有不同的事件进行相应
-(void)change:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        [self.view addSubview:_leftTableView];
        
        [_ListView removeFromParentViewController];
        [_ListView.view removeFromSuperview];
        
        self.tag = 0;
        [_leftTableView reloadData];
    }else if (sender.selectedSegmentIndex == 1){
   
        [self addChildViewController:_ListView];
        [self.view addSubview:_ListView.view];
        
        [_leftTableView removeFromSuperview];
        
        self.tag = 1;
       
    }
}
-(void)loadData
{
    
    //__weak typeof(self) weakself = self;
     //   [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Please wait...")];
    
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [HttpTool getWithPath:API_frineds params:nil hearder:nil success:^(id json) {
        //NSLog(@"朋友数据获取成功%@",json);
       // [self hideHud];
        self.leftArray=[SYJMyFriend mj_objectArrayWithKeyValuesArray:json];
        //NSLog(@"数据数量%ld",self.leftArray.count);
        if (self.leftArray.count==0) {
            [self.leftTableView addSubview:self.noFriendView];
            self.noFriendView.center=CGPointMake(ScreenWidth/2+11, ScreenHeight/2-100);
//            CGPoint nofriendCneter=self.view.center;
//            nofriendCneter.y-=NAVBAR_HEIGHT+STATUS_HEIGHT;
//            nofriendCneter.x+=11;
//            self.noFriendView.center=nofriendCneter;
        }else
        {
            [self.noFriendView removeFromSuperview];
        }
        [self.leftTableView reloadData];
       // [self.leftTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        //[weakself hideHud];
       // [self.leftTableView.mj_header endRefreshing];
//        if (error.code==-1011) {
//            NSDictionary *errorDict=[SYJTool code1011:error];
//            [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
//        }
//        else if (error.localizedDescription)
//        {
//            [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
//        }
//        else{
//            [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
//        }
    }];
}
#pragma mark ************tableview协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tag == 0) {
        return self.leftArray.count;
    }
    else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return @"取消配对";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.leftTableView) {
        UIAlertAction *Action=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
            SYJMyFriend *ary=self.leftArray[indexPath.row];
            NSDictionary *parameters = @{@"customerId":[NSString stringWithFormat:@"%ld",ary.customerId],
                                         @"realtion":@"2"
                                         };
            [HttpTool postWithPath:API_Like params:parameters hearder:nil success:^(id json) {
                NSLog(@"不喜欢成功");
                [self.leftArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (self.leftArray.count==0) {
                    [self.leftTableView addSubview:self.noFriendView];
                    self.noFriendView.center=CGPointMake(ScreenWidth/2+11, ScreenHeight/2-100);
                }
            } failure:^(NSError *error) {
            }];
        
        }];
        UIAlertController *alter=[SYJTool showAlterYesOrNo:@"确定要取消匹配吗?"];
        [alter addAction:Action];
        alter.view.tintColor=NAVBAR_Color;
        [self presentViewController:alter animated:YES completion:nil];
        
    
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tag == 0) {
        SYJMyFriend *myFriends=self.leftArray[indexPath.row];
        SYJFriendTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        cell.PersonalityLbl.text=myFriends.signature;
        cell.nameLbl.text=myFriends.nickName;
        NSString * url = [API_avatar stringByAppendingPathComponent:myFriends.avatar];
        [cell.headPicture sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        return cell;
    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.tag==0) {
        SYJMyFriend *myFriends=self.leftArray[indexPath.row];
//        NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
        NSString *url=[API_CustomerID stringByAppendingString:[NSString stringWithFormat:@"/%ld",myFriends.customerId]];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color =[UIColor clearColor];
        SYJUserInfoViewController *userinfo=[[SYJUserInfoViewController alloc]init];
        userinfo.customerId=myFriends.customerId;
        
        [HttpTool getWithPath:url params:nil hearder:nil success:^(id json) {
            //NSLog(@"跳转成功%@",json);
            [hud hideAnimated:YES];
            SYJMyInfo *infoArrs=[SYJMyInfo mj_objectWithKeyValues:json];
            userinfo.gender=infoArrs.gender;
            userinfo.signatureStr=infoArrs.signature;
            userinfo.age=infoArrs.age;
            userinfo.height=infoArrs.height;
            userinfo.weight=infoArrs.weight;
            userinfo.blood=infoArrs.blood;
            userinfo.nowCity=infoArrs.nowCity;
            userinfo.nowProvince=infoArrs.nowProvince;
            userinfo.censusCity=infoArrs.censusCity;
            userinfo.censusProvince=infoArrs.censusProvince;
            userinfo.education=infoArrs.education;
            userinfo.annualIncome=infoArrs.annualIncome;
            userinfo.marriage=infoArrs.marriage;
            userinfo.children=infoArrs.children;
            userinfo.profession=infoArrs.profession;
            userinfo.house=infoArrs.house;
            userinfo.car=infoArrs.car;
            userinfo.avatar=infoArrs.avatar;
            userinfo.nickName=infoArrs.nickName;
            if (infoArrs.label) {
                userinfo.label=infoArrs.label;
            }
            else
            {
                userinfo.label=@"";
            }
            if (infoArrs.interest) {
                userinfo.interest=infoArrs.interest;
            }
            else
            {
                userinfo.interest=@"";
            }
            //userinfo.isLike=YES;
            [self.navigationController pushViewController:userinfo animated:YES];
            
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
        }];
    }
    else if (self.tag==1)
    {
        
    }
}
#pragma mark ************访问器
-(NSMutableArray*)leftArray
{
    if (_leftArray==nil) {
        _leftArray=[[NSMutableArray alloc]init];
    }
    return _leftArray;
}
-(NSMutableArray*)rightArray
{
    if (_rightArray==nil) {
        _rightArray=[[NSMutableArray alloc]init];
    }
    return _rightArray;
}
-(UIImageView *)noFriendView
{
    if (_noFriendView==nil) {
        _noFriendView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无配对"]];
    }
    return _noFriendView;
}
//-(UIImageView *)nochatView
//{
//    if (_nochatView==nil) {
//        _nochatView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无消息"]];
//    }
//    return _nochatView;
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
