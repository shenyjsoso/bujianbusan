//
//  SYJUserInfoViewController.m
//  不见不散
//
//  Created by soso on 2017/12/2.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJUserInfoViewController.h"
#import "UIImage+SYJImage.h"
#import "SYJBasicInfoTableViewCell.h"
#import "SYJSeniorTableViewCell.h"
#import "SYJSelectMateTableViewCell.h"
#import "SYJPhotoTableViewCell.h"
#import "SYJheadCollectionViewCell.h"
#import "SYJInterestCollectionViewCell.h"
#import "SYJLabelTableViewCell.h"
#import "SYJMate.h"
#import "SYJMyFriend.h"
#import "SYJPhotos.h"
#import "HUPhotoBrowser.h"
#import "UIImageView+HUWebImage.h"
#import "SYJreportViewController.h"

#import "ChatViewController.h"
#import "SYJblock.h"

//#import "CFYNavigationBarTransition.h"

static NSString * Basiccell = @"SYJBasicInfoTableViewCell";
static NSString * Seniorcell = @"SYJSeniorTableViewCell";
static NSString * SelectMatecell = @"SYJSelectMateTableViewCell";
static NSString * Photocell=@"SYJPhotoTableViewCell";
static NSString *Labelcell=@"SYJLabelTableViewCell";

static NSString *cellId = @"SYJheadCollectionViewCell";
static NSString* InterestCell=@"SYJInterestCollectionViewCell";

@interface SYJUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>



@property(nonatomic,strong)SYJPhotoTableViewCell *photoCell;
@property(nonatomic,strong)SYJMate *infoArrs;
//@property(nonatomic,strong)SYJMyFriend *myFriends;
@property (nonatomic, strong) NSMutableArray *datas;
@property(nonatomic,strong)NSMutableArray *URLStrings;
@property(nonatomic,strong)NSMutableArray *interestArr;
@property(nonatomic,strong)NSMutableArray *LabelArr;
//SYJLabelTableViewCell *interestcell
@property(nonatomic,strong)SYJLabelTableViewCell *interestcell;
@property(nonatomic,strong)SYJLabelTableViewCell *labelcell;
@property(nonatomic,strong)NSMutableArray *sameInterestArr;
@property(nonatomic,strong)NSMutableArray *sameLabelArr;


@end

@implementation SYJUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    
    //[self.view addSubview:self.bottomView];
    [self.view addSubview:self.bottomBtn];
    
    self.navigationItem.title=self.nickName;
    //右边的bar
    if (![[SYJTool getforkey:@"myid"] isEqualToString:[NSString stringWithFormat:@"%ld",self.customerId]]) {
        UIImage *picture=[[UIImage imageNamed:@"更多"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:picture style:UIBarButtonItemStylePlain target:self action:@selector(report)];
        self.navigationItem.rightBarButtonItem=right;
    }

    
    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //[self cfy_setNavigationBarShadowImage:[UIImage new]];
    if (self.gender==1) {
       // [self cfy_setNavigationBarBackgroundImage:[UIImage imageWithColor:SYJColor(140, 182, 255, 1)]];
       // [self cfy_setNavigationBarBackgroundColor:SYJColor(140, 182, 255, 1)];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:SYJColor(140, 182, 255, 1)] forBarMetrics:UIBarMetricsDefault];
       
    }
    else if (self.gender==2)
    {
        //[self cfy_setNavigationBarBackgroundColor:SYJColor(255, 190, 203, 1)];
        
        //[self cfy_setNavigationBarBackgroundImage:[UIImage imageWithColor:SYJColor(255, 190, 203, 1)]];
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:SYJColor(255, 190, 203, 1)] forBarMetrics:UIBarMetricsDefault];
        
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
   // [self cfy_setNavigationBarShadowImage:nil];
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVBAR_Color] forBarMetrics:UIBarMetricsDefault];
    
  
}

-(void)loadData
{
    //获取择偶标准
    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    NSLog(@"值%@",value);
    NSString *url=[API_Mate stringByAppendingString:[NSString stringWithFormat:@"/%ld",self.customerId]];
    [HttpTool getWithPath:url params:nil hearder:nil success:^(id json) {
        //NSLog(@"择偶标准%@",json);
        self.infoArrs=[SYJMate mj_objectWithKeyValues:json];
    } failure:^(NSError *error) {
       // NSLog(@"择偶标准失败%@",error);
    }];
    //照片
    self.URLStrings=[NSMutableArray array];
    self.datas=[NSMutableArray array];
    NSString *photosurl=[API_photos stringByAppendingString:[NSString stringWithFormat:@"/%ld",self.customerId]];
    [HttpTool getWithPath:photosurl params:nil hearder:nil success:^(id json) {
       // NSLog(@"我的相册%@",json);
        self.datas=[SYJPhotos mj_objectArrayWithKeyValuesArray:json];
        
        for (SYJPhotos *url in self.datas) {
            NSString *sd=[API_fullphoto stringByAppendingString:url.name];
            [self.URLStrings addObject:sd];
        }
        [self.photoCell.collectionView reloadData];
    } failure:^(NSError *error) {
       // NSLog(@"失败");
    }];
    //共同标签
    NSString *path=[API_similarity stringByAppendingString:[NSString stringWithFormat:@"/%ld",self.customerId]];
    [HttpTool getWithPath:path params:nil hearder:nil success:^(id json) {
       // NSLog(@"共同标签：%@",json);
        _sameInterestArr=[json objectForKey:@"interest"];
        _sameLabelArr=[json objectForKey:@"label"];
        [self.interestcell.collectionView reloadData];
        [self.labelcell.collectionView reloadData];
        [self.tableView reloadData];
        //NSLog(@"共同兴趣爱好：%@",_sameInterestArr);
    } failure:^(NSError *error) {
        //NSLog(@"失败");
    }];

}
- (void)creatTableView {
   // self.automaticallyAdjustsScrollViewInsets = NO;
     //   self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    //底部空白
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 93)];
    //头背景view
    UIView *heardback=[[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight)];
    //头view
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+STATUS_HEIGHT, ScreenWidth, 134)];
    heardView.backgroundColor = [UIColor clearColor];
    //背景图案
    if (self.gender==1) {
        self.heardImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人资料男"]];
        heardback.backgroundColor=SYJColor(140, 182, 255, 1);
    }
    else if(self.gender==2)
    {
        self.heardImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人资料女"]];
        heardback.backgroundColor=SYJColor(255, 190, 203, 1);
    }
    
    self.heardImage.frame=CGRectMake(0, 0, ScreenWidth, 134);
    //个性签名
    UILabel *signaturelbl=[[UILabel alloc]init];
    signaturelbl.backgroundColor=[UIColor yellowColor];
    signaturelbl.text=self.signatureStr;
    signaturelbl.font=[UIFont boldSystemFontOfSize:14];
    signaturelbl.textColor=SYJColor(100, 100, 100, 1);
    signaturelbl.textAlignment=NSTextAlignmentCenter;
    signaturelbl.backgroundColor=[UIColor clearColor];
    //头像
    UIImageView *headPicture=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor grayColor]]];
    
    if (self.avatar) {
        NSString *sd=[API_avatar stringByAppendingString:self.avatar];
        //[headPicture sd_setImageWithURL:[NSURL URLWithString:sd] placeholderImage:[UIImage imageWithColor:[UIColor grayColor]]];
         [headPicture hu_setImageWithURL:[NSURL URLWithString:sd]];
        
    }
    headPicture.frame=CGRectMake(0, 0, 90, 90);
    headPicture.layer.masksToBounds=YES;
    headPicture.layer.cornerRadius=headPicture.frame.size.width/2;
    headPicture.center=self.heardImage.center;
    [heardView addSubview:heardback];
    [heardView addSubview:self.heardImage];
    [heardView addSubview:headPicture];
    [heardView addSubview:signaturelbl];
    [signaturelbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(heardView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 22));
        make.bottom.mas_equalTo(self.heardImage.mas_bottom);
    }];

    self.tableView.tableHeaderView = heardView;
    if (!_isChat) {
        self.tableView.tableFooterView=footerView;
    }else{
        self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    }
    
}
-(void)nextStep:(UIButton*)sender
{
//    if (sender.tag==100) {
        //NSLog(@"聊天");
        // 缓存到本地
        
         NSString *username=[NSString stringWithFormat:@"user_%ld_bujianbusan",self.customerId];
        NSString *Avatar=nil;
        if (self.avatar) {
            Avatar=[API_avatar stringByAppendingString:self.avatar];
        }
        [UserCacheManager save:username avatarUrl:Avatar nickName:self.nickName];
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:username conversationType:EMConversationTypeChat];
        [self.navigationController pushViewController:chatController animated:YES];
//    }
//    else if(sender.tag==101)
//    {
//       // NSLog(@"喜欢");
//        NSDictionary *parameters = @{@"customerId":[NSString stringWithFormat:@"%ld",self.customerId],
//                                     @"realtion":@"1"
//                                     };
//        //NSLog(@"喜欢请求体%@",parameters);
//        NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
//        [HttpTool postWithPath:API_Like params:parameters hearder:value success:^(id json) {
//            //NSLog(@"添加喜欢成功%@",json);
//            sender.tag=102;
//            [sender setImage:[UIImage imageNamed:@"聊天中的不喜欢"] forState:UIControlStateNormal];
//        } failure:^(NSError *error) {
//            if (error.code==-1011) {
//                NSDictionary *errorDict=[SYJTool code1011:error];
//                [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
//            }
//            else if (error.localizedDescription)
//            {
//                [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
//            }
//            else{
//                [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
//            }
//        }];
//
//    }
//    else if(sender.tag==102)
//    {
//        //NSLog(@"不喜欢");
//        NSDictionary *parameters = @{@"customerId":[NSString stringWithFormat:@"%ld",self.customerId],
//                                     @"realtion":@"2"
//                                     };
//       // NSLog(@"不喜欢请求体%@",parameters);
//        NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
//        [HttpTool postWithPath:API_Like params:parameters hearder:value success:^(id json) {
//            //NSLog(@"添加不喜欢成功%@",json);
//            sender.tag=101;
//            [sender setImage:[UIImage imageNamed:@"聊天中的喜欢"] forState:UIControlStateNormal];
//        } failure:^(NSError *error) {
//            if (error.code==-1011) {
//                NSDictionary *errorDict=[SYJTool code1011:error];
//                [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
//            }
//            else if (error.localizedDescription)
//            {
//                [SYJProgressHUD showMessage:error.localizedDescription inView:self.view afterDelayTime:1];
//            }
//            else{
//                [SYJProgressHUD showMessage:@"错误" inView:self.view afterDelayTime:1];
//            }
//        }];
//    }
}
-(void)report
{
    UIAlertController *alterController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *userblock=[NSString stringWithFormat:@"/%ld/block",self.customerId];
    NSLog(@"%@",userblock);
    [HttpTool getWithPath:userblock params:nil hearder:nil success:^(id json) {
        NSLog(@"是否拉黑%@",json);
        SYJblock *isblock=[SYJblock mj_objectWithKeyValues:json];
        
        UIAlertAction *blockaction=[[UIAlertAction alloc]init];
        NSDictionary *parameters = @{@"id":[NSString stringWithFormat:@"%ld",self.customerId]
                                     };
        //    NSData *data=[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        
        //没拉黑
        if (isblock.state==0) {
            blockaction=[UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *afterblock=[UIAlertController alertControllerWithTitle:nil message:@"拉黑后,你将不再收到对方消息" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *noAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [HttpTool postWithPath:API_blocked params:parameters hearder:nil success:^(id json) {
                
                        [SYJProgressHUD showMessage:@"拉黑成功" inView:self.view afterDelayTime:1];
                        NSLog(@"拉黑成功");
                        
                    } failure:^(NSError *error) {
                        NSLog(@"拉黑失败");
                    }];
                }];
                [afterblock addAction:noAction];
                [afterblock addAction:okAction];
                [self presentViewController:afterblock animated:YES completion:nil];
                
            }];
            
        }
        else if (isblock.state==1)//已经拉黑
        {
            blockaction=[UIAlertAction actionWithTitle:@"取消拉黑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [HttpTool postWithPath:API_deblocked params:parameters hearder:nil success:^(id json) {
                    NSLog(@"取消拉黑成功");
                    [SYJProgressHUD showMessage:@"取消拉黑成功" inView:self.view afterDelayTime:1];
                } failure:^(NSError *error) {
                    NSLog(@"取消拉黑失败");
                }];
            }];
        }
        [alterController addAction:blockaction];
        [self presentViewController:alterController animated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
    
    UIAlertAction *reportAction=[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        SYJreportViewController *reportVC=[[SYJreportViewController alloc]init];
        reportVC.customerId=self.customerId;
        [self.navigationController pushViewController:reportVC animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alterController addAction:reportAction];
    [alterController addAction:cancelAction];
    
    
    


   
}
#pragma mark ***********tableview代理**********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0){
        if (self.datas.count==0)//照片
        {
            return 0;
        }
        else
        {
            return 82;
        }
    }
    else if (indexPath.section==1)//基本信息
    {
        return 170;
    }
    else if(indexPath.section==2)//兴趣爱好
    {
        if (self.interestArr.count>0) {
            return 99;//44
        }
        else return 33;
        
    }
    else if(indexPath.section==3)//我的标签
    {
        if (self.LabelArr.count>0) {
            return 99;//44
        }
        else return 33;
    }
    else if(indexPath.section==4)//高级信息
    {
        return 215;//44
    }
    else if (indexPath.section==5)//择偶标准
    {
        if (self.infoArrs) {
            return 320;//125;
        }else return 0;
        
    }
    else
    {
        return 0;//44
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=SYJColor(248, 248, 248, 1);
    return view;
}

//- (void)tableView:(UITableView *)tableView willplayFooterView:(UIView *)view forSection:(NSInteger)section {
//    view.tintColor = [UIColor redColor];
//}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        self.photoCell=[tableView dequeueReusableCellWithIdentifier:Photocell forIndexPath:indexPath];
        //取消选中状态
        self.photoCell.selectionStyle =UITableViewCellSelectionStyleNone;
        [self.photoCell.collectionView registerNib:[UINib nibWithNibName:@"SYJheadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellId];
        self.photoCell.collectionView.tag=20;
        self.photoCell.collectionView.dataSource=self;
        self.photoCell.collectionView.delegate=self;
        return self.photoCell;
    }
    else if (indexPath.section==1) {
        SYJBasicInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Basiccell forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (self.gender==1) {
            cell.sexLbl.text=@"男";
        }
        else
        {
            cell.sexLbl.text=@"女";
        }
        if (self.age) {
            cell.ageLbl.text=[NSString stringWithFormat:@"%ld岁",self.age];
        }
        if (self.height) {
            cell.heightLbl.text=[NSString stringWithFormat:@"%ldcm",self.height];
        }
        if (self.weight) {
            cell.weightLbl.text=[NSString stringWithFormat:@"%ldkg",self.weight];
        }
        if (self.blood) {
            cell.bloodLbl.text=self.blood;
        }
        if (self.nowCity&&self.nowProvince) {
            cell.cityLbl.text=[NSString stringWithFormat:@"%@ %@",self.nowProvince,self.nowCity];
            
            if ([self.nowProvince isEqualToString:self.nowCity]) {
                cell.cityLbl.text=self.nowProvince;
            }
            else if ([self.nowCity isEqualToString:@"不限"])
            {
                cell.cityLbl.text=self.nowProvince;
            }
            else
            {
                cell.cityLbl.text=[self.nowProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.nowCity]];
            }
        }
        
        return cell;
    }
    else if (indexPath.section==2)
    {
        _interestcell=[tableView dequeueReusableCellWithIdentifier:Labelcell forIndexPath:indexPath];
        _interestcell.selectionStyle =UITableViewCellSelectionStyleNone;
        _interestcell.titleLbl.text=@"兴趣爱好";
        _interestcell.commonLbl.text=[NSString stringWithFormat:@"%ld个共同爱好",self.sameInterestArr.count];
        [_interestcell.collectionView registerNib:[UINib nibWithNibName:@"SYJInterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:InterestCell];
        _interestcell.collectionView.tag=21;
        _interestcell.collectionView.delegate=self;
        _interestcell.collectionView.dataSource=self;
        return _interestcell;
        
    }
    else if (indexPath.section==3)
    {
        _labelcell=[tableView dequeueReusableCellWithIdentifier:Labelcell forIndexPath:indexPath];
        _labelcell.selectionStyle =UITableViewCellSelectionStyleNone;
        _labelcell.titleLbl.text=@"我的标签";
        _labelcell.commonLbl.text=[NSString stringWithFormat:@"%ld个共同标签",self.sameLabelArr.count];
        [_labelcell.collectionView registerNib:[UINib nibWithNibName:@"SYJInterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:InterestCell];
        _labelcell.collectionView.tag=22;
        _labelcell.collectionView.delegate=self;
        _labelcell.collectionView.dataSource=self;
        return _labelcell;
    }
    else if (indexPath.section==4)
    {
        SYJSeniorTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Seniorcell forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        //cell.censusCityLbl.text=[self.censusProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.censusCity]];
        
        if ([self.censusProvince isEqualToString:self.censusCity]) {
            cell.censusCityLbl.text=self.censusProvince;
        }
        else if ([self.censusCity isEqualToString:@"不限"])
        {
            cell.censusCityLbl.text=self.censusProvince;
        }
        else
        {
            cell.censusCityLbl.text=[self.censusProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.censusCity]];
        }
        
        cell.eduLbl.text=self.education;
        cell.jobLbl.text=self.profession;
        cell.inComeLbl.text=self.annualIncome;
        cell.marriageLbl.text=self.marriage;
        cell.childLbl.text=self.children;
        cell.houseLbl.text=self.house;
        cell.carLbl.text=self.car;
        return cell;
        
    }
    else//择偶标准
    {
        SYJSelectMateTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SelectMatecell forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        if ([self.infoArrs.censusProvince isEqualToString:self.infoArrs.censusCity]) {
            cell.censusCityLbl.text=self.infoArrs.censusProvince;
        }
        else if ([self.infoArrs.censusCity isEqualToString:@"不限"])
        {
            cell.censusCityLbl.text=self.infoArrs.censusProvince;
        }
        else
        {
            cell.censusCityLbl.text=[self.infoArrs.censusProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.infoArrs.censusCity]];
        }
        
        cell.educationLbl.text=self.infoArrs.education;
        cell.jobLbl.text=self.infoArrs.profession;
        cell.inComeLbl.text=self.infoArrs.annualIncome;
        //年龄
        if (![self.infoArrs.minAge isEqualToString:self.infoArrs.maxAge]) {
            cell.ageLbl.text=[self.infoArrs.minAge stringByAppendingString:[NSString stringWithFormat:@"-%@岁",self.infoArrs.maxAge]];
        }
        else {
            if ([self.infoArrs.minAge isEqualToString:@"不限"]) {
                cell.ageLbl.text=@"不限";
            }
            else
            {
                cell.ageLbl.text=[self.infoArrs.minAge stringByAppendingString:@"岁"];
            }
        }
        //身高
        if (![self.infoArrs.minHeight isEqualToString:self.infoArrs.maxHeight]) {
            cell.heightLbl.text=[self.infoArrs.minHeight stringByAppendingString:[NSString stringWithFormat:@"-%@cm",self.infoArrs.maxHeight]];
        }
        else {
            if ([self.infoArrs.minHeight isEqualToString:@"不限"]) {
                cell.heightLbl.text=@"不限";
            }
            else
            {
                cell.heightLbl.text=[self.infoArrs.minHeight stringByAppendingString:@"cm"];
            }
        }
        //体重
        if (![self.infoArrs.minWeight isEqualToString:self.infoArrs.maxWeight]) {
            cell.weight.text=[self.infoArrs.minWeight stringByAppendingString:[NSString stringWithFormat:@"-%@kg",self.infoArrs.maxWeight]];
        }
        else {
            if ([self.infoArrs.minWeight isEqualToString:@"不限"]) {
                cell.weight.text=@"不限";
            }
            else
            {
                cell.weight.text=[self.infoArrs.minWeight stringByAppendingString:@"kg"];
            }
        }
       cell.bloodLbl.text=self.infoArrs.blood;
        
        if ([self.infoArrs.nowProvince isEqualToString:self.infoArrs.nowCity]) {
            cell.nowCityLbl.text=self.infoArrs.nowProvince;
        }
        else if ([self.infoArrs.nowCity isEqualToString:@"不限"])
        {
            cell.nowCityLbl.text=self.infoArrs.nowProvince;
        }
        else
        {
            cell.nowCityLbl.text=[self.infoArrs.nowProvince stringByAppendingString:[NSString stringWithFormat:@" %@",self.infoArrs.nowCity]];
        }
        cell.marriageLbl.text=self.infoArrs.marriage;
        cell.houseLbl.text=self.infoArrs.house;
        cell.carLbl.text=self.infoArrs.car;
        return cell;
    }

}
//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 8; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark ***********CollectionView代理**********
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag==20) {
        return self.datas.count;
    }
    else if (collectionView.tag==21)
    {
       return  self.interestArr.count;
        
    }
    else
    {
//        NSArray *array = [self.label componentsSeparatedByString:@" "];
//        return array.count;
       return  self.LabelArr.count;
    }
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"点击了");
    if (collectionView.tag==20) {
        SYJheadCollectionViewCell *cell = (SYJheadCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:cell.myImage withURLStrings:_URLStrings atIndex:indexPath.item];
    }

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag==20) {
        SYJPhotos *myphotos=self.datas[indexPath.item];
        
        SYJheadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        //cell.backgroundColor = SYJColor(248, 248, 248, 1);
        cell.backgroundColor=SYJColor(226, 226, 226, 1);
      //  [cell.myImage hu_setImageWithURL:[NSURL URLWithString:self.URLStrings[indexPath.row]]];
        
        NSString *sd=[API_avatar stringByAppendingString:myphotos.name];
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:sd]];
        
        cell.layer.cornerRadius=5;
        cell.layer.masksToBounds=YES;
        return cell;
    }
    else if (collectionView.tag==21)
    {
        SYJInterestCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:InterestCell forIndexPath:indexPath];
        cell.backgroundColor=[UIColor clearColor];
        cell.interestLbl.font=[UIFont systemFontOfSize:14];
        cell.interestLbl.text=self.interestArr[indexPath.item];
        if (self.sameInterestArr.count>0) {
            for (NSString *sameinterest in self.sameInterestArr) {
                if ([sameinterest isEqualToString:self.interestArr[indexPath.item]]) {
                    cell.interestLbl.textColor=NAVBAR_Color;
                    cell.layer.borderColor=NAVBAR_Color.CGColor;
                    break;
                    
                }
                else{
                    cell.interestLbl.textColor=SYJColor(152, 152, 152, 1);
                    cell.layer.borderColor=SYJColor(152, 152, 152, 1).CGColor;
                    
                }
            }
        }
        else
        {
            cell.interestLbl.textColor=SYJColor(152, 152, 152, 1);
            cell.layer.borderColor=SYJColor(152, 152, 152, 1).CGColor;
        }
        
        cell.layer.borderWidth=1;
        cell.layer.cornerRadius=5;
        cell.layer.masksToBounds=YES;
        cell.backgroundColor=[UIColor clearColor];
        
        return cell;
    }
    else
    {
        SYJInterestCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:InterestCell forIndexPath:indexPath];
        cell.backgroundColor=[UIColor clearColor];
        cell.interestLbl.font=[UIFont systemFontOfSize:14];
        cell.interestLbl.text=self.LabelArr[indexPath.item];
        
        if (self.sameLabelArr.count>0) {
            for (NSString *samelabel in self.sameLabelArr) {
                if ([samelabel isEqualToString:self.LabelArr[indexPath.item]]) {
                    cell.interestLbl.textColor=NAVBAR_Color;
                    cell.layer.borderColor=NAVBAR_Color.CGColor;
                    break;
                    
                }
                else{
                    cell.interestLbl.textColor=SYJColor(152, 152, 152, 1);
                    cell.layer.borderColor=SYJColor(152, 152, 152, 1).CGColor;
                    
                }
            }
        }
        else
        {
            cell.interestLbl.textColor=SYJColor(152, 152, 152, 1);
            cell.layer.borderColor=SYJColor(152, 152, 152, 1).CGColor;
        }
        cell.layer.borderWidth=1;
        cell.layer.cornerRadius=5;
        cell.layer.masksToBounds=YES;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }

}
//这个是两行cell之间的间距（上下行cell的间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
        return 10;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    if (collectionView.tag==21||collectionView.tag==22) {
        return 10;

}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag==21||collectionView.tag==22) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    else
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //SYJInterestCollectionViewCell *cell = (SYJInterestCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (collectionView.tag==21) {
       
        CGSize size=[self sizeWithText:self.interestArr[indexPath.item] font:[UIFont systemFontOfSize:14]];
        size.height+=5;
        size.width+=20;
        return size;
        //return CGRectIntegral(size);
    }
    else if (collectionView.tag==22)
    {
       // NSArray *array = [self.label componentsSeparatedByString:@" "];
        CGSize size=[self sizeWithText:self.LabelArr[indexPath.item] font:[UIFont systemFontOfSize:14]];
        size.height+=5;
        size.width+=20;
        return size;
    }
    else
    {
        return CGSizeMake(60, 60);
    }

}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attrDict];
}
#pragma mark *************访问器************
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
        //cell与cell之间的线
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=SYJColor(248, 248, 248, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"SYJBasicInfoTableViewCell" bundle:nil] forCellReuseIdentifier:Basiccell];
        [_tableView registerNib:[UINib nibWithNibName:@"SYJSeniorTableViewCell" bundle:nil] forCellReuseIdentifier:Seniorcell];
        [_tableView registerNib:[UINib nibWithNibName:@"SYJSelectMateTableViewCell" bundle:nil] forCellReuseIdentifier:SelectMatecell];
        [_tableView registerNib:[UINib nibWithNibName:@"SYJPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:Photocell];
        [_tableView registerNib:[UINib nibWithNibName:@"SYJLabelTableViewCell" bundle:nil] forCellReuseIdentifier:Labelcell];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
//-(UIButton *)chatBtn
//{
//    if (_chatBtn==nil) {
//        _chatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [_chatBtn setImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
//        _chatBtn.adjustsImageWhenHighlighted=NO;
//        _chatBtn.tag=100;
//        [_chatBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _chatBtn;
//}
//-(UIView*)bottomView
//{
//    if (_bottomView==nil) {
//        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVBAR_HEIGHT-STATUS_HEIGHT-60, ScreenWidth, 60)];
//        _bottomView.backgroundColor=[UIColor whiteColor];
//        //聊天按钮
//
//        [_bottomView addSubview:self.chatBtn];
//        [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(125, 50));
//            make.centerY.equalTo(_bottomView);
//            make.centerX.equalTo(_bottomView).with.mas_offset(-ScreenWidth/4);
//        }];
//        //喜欢不喜欢按钮
//        _likeOrNoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//
//            if (!_isLike) {
//                [_likeOrNoBtn setImage:[UIImage imageNamed:@"聊天中的喜欢"] forState:UIControlStateNormal];
//                _likeOrNoBtn.tag=101;
//            }
//            else
//            {
//                [_likeOrNoBtn setImage:[UIImage imageNamed:@"聊天中的不喜欢"] forState:UIControlStateNormal];
//                _likeOrNoBtn.tag=102;
//            }
//        _likeOrNoBtn.adjustsImageWhenHighlighted=NO;
//        [_likeOrNoBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
//
//        [_bottomView addSubview:_likeOrNoBtn];
//        [_likeOrNoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(125, 50));
//            make.centerY.equalTo(_bottomView);
//            make.centerX.equalTo(_bottomView).with.mas_offset(ScreenWidth/4);
//        }];
//    }
//    return _bottomView;
//}
-(UIButton*)bottomBtn
{
    if (_bottomBtn==nil) {
        _bottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame=CGRectMake(0, ScreenHeight-NAVBAR_HEIGHT-STATUS_HEIGHT-49, ScreenWidth, 49);
        [ _bottomBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:NAVBAR_Color forState:UIControlStateNormal];
        _bottomBtn.titleLabel.font=[UIFont systemFontOfSize:19];
        [_bottomBtn setBackgroundColor:[UIColor whiteColor]];
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0, 0)];
        [linePath addLineToPoint:CGPointMake(ScreenWidth,0)];
        
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.lineWidth = 1.0f;
        lineLayer.strokeColor = SYJColor(248, 248, 248, 1).CGColor;
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = nil;
        
        [_bottomBtn.layer addSublayer:lineLayer];
        [_bottomBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
-(NSMutableArray *)interestArr
{
    if (_interestArr==nil) {
        NSArray *array=nil;
        if (self.label.length>0) {
            array=[self.interest componentsSeparatedByString:@","];
        }
       // NSArray *array=[self.interest componentsSeparatedByString:@","];
        _interestArr = [NSMutableArray arrayWithArray:array];
        //[_interestArr removeObjectAtIndex:0];
    }
    return _interestArr;

}
-(NSMutableArray *)LabelArr
{
    if (_LabelArr==nil) {
        NSArray *array=nil;
        if (self.label.length>0) {
            array=[self.label componentsSeparatedByString:@","];
        }
        //NSArray *array=[self.label componentsSeparatedByString:@","];
        _LabelArr = [NSMutableArray arrayWithArray:array];
        //[_LabelArr removeObjectAtIndex:0];
    }
    return _LabelArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
