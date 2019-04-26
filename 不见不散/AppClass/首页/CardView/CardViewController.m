//
//  YFDraggableCardViewController.m
//  BigShow1949
//
//  Created by zhht01 on 16/3/18.
//  Copyright © 2016年 BigShowCompany. All rights reserved.
//

#import "CardViewController.h"
#import "YSLDraggableCardContainer.h"
#import "CardView.h"
#import "SYJPushButton.h"
#import "UIImage+SYJImage.h"
#import "SYJUserInfoViewController.h"
#import "SYJSelectViewController.h"
#import "SYJTool.h"
#import "SYJRecommends.h"
#import "SYJMyInfo.h"
#import "SYJMyFriend.h"
#import "SYJRemindHeadView.h"
#import "SYJLogInViewController.h"
#import "SYJNavigationController.h"
#import "SYJMeViewController.h"
//#import <MapKit/MapKit.h>
#import "ChatUIHelper.h"
#import <CoreLocation/CoreLocation.h>
#define BtnSize ScreenWidth/6.25
#define BtnBackGroundSize ScreenWidth/5
@interface CardViewController () <YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource,CLLocationManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) YSLDraggableCardContainer *container;
@property (strong,nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) NSMutableArray *datas;
@property(nonatomic,strong) SYJPushButton *dislikeBtn;
@property(nonatomic,strong)SYJPushButton *likeBtn;
@property(nonatomic,strong)UIImageView *leftBackgroundView;
@property(nonatomic,strong)UIImageView *rightBackgroundView;

@property(nonatomic,strong)CardView *Cardview;
@property(nonatomic,strong)NSMutableArray *myFriendsArray;
//@property(nonatomic,strong)SYJMyInfo *myInfo;
//@property(nonatomic,assign)BOOL isavatar;
@property(nonatomic,strong)UIImageView *NonetworkView;
@property(nonatomic,strong)UIImageView *NoFriendView;
@property(nonatomic,strong)UIWindow *window;
@property(nonatomic,strong)SYJRemindHeadView *remindview;
@end

@implementation CardViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    [self initUI];
    [self loadData];
    [self MyLocation];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarButtonClick) name:@"TabbarButtonClickDidRepeatNotification" object:nil];
   

}
-(void)viewWillAppear:(BOOL)animated
{
    //我的信息(取头像）
//    NSString *username=[NSString stringWithFormat:@"user_%@_bujianbusan",[SYJTool getforkey:@"myid"]];
//    NSLog(@"头像地址%@",[UserCacheManager getUserInfo:username].avatarUrl);
    
    __weak typeof(self) weakSelf = self;
    
   if(![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])
   {
       self.window = [UIApplication sharedApplication].keyWindow;
       self.window.windowLevel =UIWindowLevelNormal;
       self.remindview=[[[NSBundle mainBundle] loadNibNamed:@"SYJRemindHeadView"owner:nil options:nil] lastObject];
       self.remindview.center=self.window.center;
       __block SYJRemindHeadView *weakRemindview = self.remindview;
       self.remindview.block = ^{
               [weakRemindview removeFromSuperview];
           __strong typeof(self) strongSelf = weakSelf;
           
           //调用系统相册的类
           UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
           //调用系统相册的类
           pickerController = [[UIImagePickerController alloc]init];
           pickerController.delegate = strongSelf;
           //设置选取的照片是否可编辑
           pickerController.allowsEditing = YES;
           UIAlertController *alterController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
           UIAlertAction *PhotoLibraryAction=[UIAlertAction actionWithTitle:@"从相册选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   //设置相册呈现的样式
                   pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                           [strongSelf presentViewController:pickerController animated:YES completion:nil];
               }];
           UIAlertAction *CameraLibraryAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               //设置相册呈现的样式
           pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
           [pickerController.navigationController setNavigationBarHidden:YES];
           [strongSelf presentViewController:pickerController animated:YES completion:nil];
               }];
           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
           [alterController addAction:PhotoLibraryAction];
           [alterController addAction:CameraLibraryAction];
           [alterController addAction:cancelAction];
               //alterController.view.tintColor=NAVBAR_Color;
           [strongSelf presentViewController:alterController animated:YES completion:nil];
               };
           //实现弹出方法
       [self.window addSubview:self.remindview];
   }

}
-(void)tabbarButtonClick
{
    //判断window是否在窗口上
    if (self.view.window == nil) return;
    //判断当前的view是否与窗口重合  nil代表屏幕左上角
    if (![self.view hu_intersectsWithAnotherView:nil]) return;
    if (![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])
    {
        [self.window addSubview:self.remindview];
        return;
    }
    [self loadData];
}

-(void)MyLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
   // self.locationManager.allowsBackgroundLocationUpdates =YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
-(void)initUI
{
    self.navigationItem.title=@"不见不散";
    //右边的bar
    UIImage *picture=[[UIImage imageNamed:@"筛选"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:picture style:UIBarButtonItemStylePlain target:self action:@selector(selectView)];
    self.navigationItem.rightBarButtonItem=right;
    //创建灰色按钮背景
    _leftBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-1"]];
    _leftBackgroundView.frame=CGRectMake(0, 0, BtnBackGroundSize, BtnBackGroundSize);
    _leftBackgroundView.center=CGPointMake(ScreenWidth/3, ScreenHeight *0.74);
    _leftBackgroundView.hidden=YES;
    [self.view addSubview:_leftBackgroundView];
    
    _rightBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"椭圆-1"]];
    _rightBackgroundView.frame=CGRectMake(0, 0, BtnBackGroundSize, BtnBackGroundSize);
    _rightBackgroundView.center=CGPointMake(ScreenWidth/3*2, ScreenHeight*0.74);
    _rightBackgroundView.hidden=YES;
    [self.view addSubview:_rightBackgroundView];
    
    // 创建左右按钮
    //__weak typeof (self) weakSelf = self;
    _dislikeBtn=[SYJPushButton touchUpOutsideCancelButtonWithType:UIButtonTypeCustom
        frame:CGRectMake(0, 0, BtnSize, BtnSize) title:nil titleColor:nil
      backgroundColor:nil backgroundImage:@"不喜欢" andBlock:^{
          if (![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])
          {
              
              [self.window addSubview:self.remindview];
          }
          else
          {
              _likeBtn.enabled = NO;
              _dislikeBtn.enabled=NO;
              [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:0.35f];//防止用户重复点击
              [_container movePositionWithDirection:YSLDraggableDirectionLeft isAutomatic:YES];
          }
          
    }];
    _dislikeBtn.center=CGPointMake(ScreenWidth/3, ScreenHeight*0.74);
    _dislikeBtn.clipsToBounds = YES;
    _dislikeBtn.layer.cornerRadius = _dislikeBtn.frame.size.width / 2;
    _dislikeBtn.adjustsImageWhenHighlighted=NO;
    _dislikeBtn.hidden=YES;
    [self.view addSubview:_dislikeBtn];
    __weak typeof (self) weakSelf = self;
    _likeBtn= [SYJPushButton touchUpOutsideCancelButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, BtnSize, BtnSize) title:nil titleColor:nil backgroundColor:nil backgroundImage:@"喜欢" andBlock:^{
        if (![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])
        {
            [self.window addSubview:self.remindview];
            //[SYJProgressHUD showMessage:@"上传头像继续操作" inView:self.view afterDelayTime:1];
        }
        else
        {
            _likeBtn.enabled = NO;
            _dislikeBtn.enabled=NO;
            [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:0.35f];//防止用户重复点击
            [_container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
     
        }
        
        
    }];
    _likeBtn.center=CGPointMake(ScreenWidth/3*2, ScreenHeight*0.74);
    _likeBtn.clipsToBounds = YES;
    _likeBtn.layer.cornerRadius = _likeBtn.frame.size.width / 2;
    _likeBtn.adjustsImageWhenHighlighted=NO;
    _likeBtn.hidden=YES;
    [self.view addSubview:_likeBtn];
    // 创建 _container
    _container = [[YSLDraggableCardContainer alloc]init];
    _container.frame = CGRectMake(10,10, ScreenWidth-20,0.637*ScreenHeight);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    _container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionDown;
    [self.view addSubview:_container];
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    _container.leftblock = ^(NSInteger index) {
        SYJRecommends *recom=weakSelf.datas[index-1];
        NSDictionary *parameters = @{@"customerId":[NSString stringWithFormat:@"%ld",recom.customerId],
                                     @"realtion":@"2"
                                     };
        [HttpTool postWithPath:API_Like params:parameters hearder:nil success:^(id json) {
            NSLog(@"添加不喜欢成功");
            [weakSelf.NonetworkView removeFromSuperview];
        } failure:^(NSError *error) {
            
            
        }];
    };
    _container.rightblock = ^(NSInteger index) {
        SYJRecommends *recom=weakSelf.datas[index-1];
        NSDictionary *parameters = @{@"customerId":[NSString stringWithFormat:@"%ld",recom.customerId],
                                     @"realtion":@"1"
                                     };
        [HttpTool postWithPath:API_Like params:parameters hearder:nil success:^(id json) {
            NSLog(@"添加喜欢成功");
            [weakSelf.NonetworkView removeFromSuperview];
        } failure:^(NSError *error) {
  
        }];
    };
}
- (void)loadData
{
    [self hideHud];
    
    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [self showHudInView:self.view hint:@"正在寻找合适的人"];
    [HttpTool getWithPath:API_Recommends params:nil hearder:value success:^(id json) {
        // NSLog(@"数据是%@",json);
        [self hideHud];
        [self.NonetworkView removeFromSuperview];
        self.datas=[SYJRecommends mj_objectArrayWithKeyValuesArray:json];
        if (self.datas.count>0) {
            _rightBackgroundView.hidden=NO;
            _leftBackgroundView.hidden=NO;
            _dislikeBtn.hidden=NO;
            _likeBtn.hidden=NO;
            
            [self.NoFriendView removeFromSuperview];
        }
        else if(self.datas.count==0)
        {
            _rightBackgroundView.hidden=YES;
            _leftBackgroundView.hidden=YES;
            _dislikeBtn.hidden=YES;
            _likeBtn.hidden=YES;
            CGPoint nofriendcenter=self.view.center;
            nofriendcenter.y-=NAVBAR_HEIGHT+STATUS_HEIGHT;
            [self.view addSubview:self.NoFriendView];
            self.NoFriendView.center=nofriendcenter;
            
        }
        //刷新数据
        [_container reloadCardContainer];
        
    } failure:^(NSError *error) {

        [self hideHud];
//        if (self.datas.count==0) {
//            [self.view addSubview:self.NonetworkView];
//        }
        [self.view insertSubview:self.NonetworkView belowSubview:_container];
        [self.NoFriendView removeFromSuperview];
        CGPoint networkcenter=self.view.center;
        networkcenter.y-=NAVBAR_HEIGHT+STATUS_HEIGHT;
        self.NonetworkView.center=networkcenter;
        
        if (error.code==-1011) {
            NSDictionary *errorDict=[SYJTool code1011:error];
            [SYJProgressHUD showMessage:errorDict[@"message"] inView:self.view afterDelayTime:1];
            NSLog(@"1011:%@",errorDict[@"message"]);
            if ([errorDict[@"message"] isEqualToString:@"无效的token"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                SYJLogInViewController *loginVC=[[SYJLogInViewController alloc]init];
                SYJNavigationController *nav=[[SYJNavigationController alloc]initWithRootViewController:loginVC];
                [[[UIApplication sharedApplication] keyWindow] setRootViewController:nav];
            }
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
-(void)selectView
{
    //__weak typeof (self) weakSelf = self;
    if (![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])
    {
        [self.window addSubview:self.remindview];
        return;
    }
    SYJSelectViewController *selectVC=[[SYJSelectViewController alloc]init];
    selectVC.block = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:selectVC animated:YES];
}
-(void)changeButtonStatus
{
    self.likeBtn.enabled=YES;
    self.dislikeBtn.enabled=YES;
}
#pragma mark -- YSLDraggableCardContainer DataSource
// 根据index获取当前的view
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    SYJRecommends *recom=_datas[index];
    _Cardview = [[CardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20 , 0.637*ScreenHeight )];
    _Cardview.backgroundColor = [UIColor whiteColor];
    NSString * url = [API_fullphoto stringByAppendingPathComponent:recom.avatar];
    [_Cardview.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    _Cardview.namelabel.text = recom.nickName;
    if (recom.gender==1) {
        _Cardview.agelabel.text=[NSString stringWithFormat:@"♂%ld",recom.age];
        _Cardview.agelabel.backgroundColor=SYJColor(139, 176, 255, 1);
    }
    else if (recom.gender==2)
    {
        _Cardview.agelabel.text=[NSString stringWithFormat:@"♀%ld",recom.age];
        _Cardview.agelabel.backgroundColor=SYJColor(255, 179, 195, 1);
    }
    //身高
        _Cardview.heightlabel.text=[NSString stringWithFormat:@"%ldcm",recom.height];
 
    //地址
    if(recom.place)
    {
        _Cardview.addresslabel.text=recom.place;
        CGSize size=[self sizeWithText:recom.place font:[UIFont systemFontOfSize:12]];
        size.width+=5;
        size.height=19;
        if (size.width<40) {
            size.width=40;

            _Cardview.addresslabel.size = size;
        }
        else
        {
//            CGSize sizelbl = _Cardview.addresslabel.size;
//            sizelbl.width = size.width;
           
            _Cardview.addresslabel.size=size;
           
        }
    }
    else
    {
        _Cardview.addresslabel.hidden=YES;
    }
    _Cardview.distancelabel.text=recom.distance;
    return _Cardview;
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attrDict];
}
// 获取view的个数
- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return self.datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
// 滑动view结束后调用这个方法
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    if ((![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])||(_dislikeBtn.enabled==NO&&_likeBtn.enabled==NO))
    {
        [self.window addSubview:self.remindview];
        //[SYJProgressHUD showMessage:@"上传头像继续操作" inView:self.view afterDelayTime:1];
        [cardContainerView movePositionWithDirection:YSLDraggableDirectionDefault
                                         isAutomatic:NO];
    }
    else
    {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    //NSLog(@"index:%ld",index);
//    SYJRecommends *recom=_datas[index];
//    if (draggableDirection == YSLDraggableDirectionRight) {

//    else if (draggableDirection == YSLDraggableDirectionLeft)

}

// 更新view的状态, 滑动中会调用这个方法
- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
   //CGFloat scale=1+(widthRatio > 0.8 ? 0.8 : widthRatio)/9;
    CGFloat scale = 1 + ((0.8f > fabs(widthRatio) ? fabs(widthRatio) : 0.8f))/7;
    CardView *view = (CardView *)draggableView;    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.dislikeView.alpha = 0;
        view.likeView.alpha = 0;
        self.dislikeBtn.transform=CGAffineTransformMakeScale(1, 1);
        self.likeBtn.transform=CGAffineTransformMakeScale(1, 1);
    }
//   // CGFloat scale = 1 + ((0.8f > fabs(widthRatio) ? fabs(widthRatio) : 0.8f)) / 4;
    if (draggableDirection == YSLDraggableDirectionLeft) {
        //view.selectedView.backgroundColor = RGB(215, 215, 215);
        view.dislikeView.alpha = widthRatio > 1 ? 1 : widthRatio;
        self.dislikeBtn.transform = CGAffineTransformMakeScale(scale, scale);
    }
//
    if (draggableDirection == YSLDraggableDirectionRight) {
        //view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.likeView.alpha = widthRatio > 1 ? 1 : widthRatio;
        self.likeBtn.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

// 所有卡片拖动完成后调用这个方法
- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       // [container reloadCardContainer];
        [weakSelf loadData];
    });
}

// 点击view调用这个
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
    if (![[SYJTool getforkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]] isEqualToString:@"YES"])
    {
        [self.window addSubview:self.remindview];
       // [SYJProgressHUD showMessage:@"上传头像继续操作" inView:self.view afterDelayTime:1];
        return;
    }
    SYJRecommends *recom=_datas[index];
    //NSLog(@"++ index : %ld",(long)index);
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    NSString *url=[API_CustomerID stringByAppendingString:[NSString stringWithFormat:@"/%ld",recom.customerId]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.style=MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color =[UIColor clearColor];
    SYJUserInfoViewController *userinfo=[[SYJUserInfoViewController alloc]init];
    userinfo.customerId=recom.customerId;
    userinfo.gender=recom.gender;
    
    [HttpTool getWithPath:url params:nil hearder:nil success:^(id json) {
        //NSLog(@"跳转成功%@",json);
        SYJMyInfo *infoArrs=[SYJMyInfo mj_objectWithKeyValues:json];
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
            [hud hideAnimated:YES];
            [self.navigationController pushViewController:userinfo animated:YES];
        //获取我的朋友
//        [HttpTool getWithPath:API_frineds params:nil hearder:value success:^(id json) {
//           // NSLog(@"朋友数据成功%@",json);
//            self.myFriendsArray=[SYJMyFriend mj_objectArrayWithKeyValuesArray:json];
//                for (SYJMyFriend *my in self.myFriendsArray) {
//                    if (my.customerId==infoArrs.idField) {
//                        userinfo.isLike=YES;
//                        break ;
//                    }
//                    else
//                    {
//                        userinfo.isLike=NO;
//                    }
//                }
//            [hud hideAnimated:YES];
//            [self.navigationController pushViewController:userinfo animated:YES];
//        } failure:^(NSError *error) {
//           // NSLog(@"朋友数据失败%@",error);
//            [hud hideAnimated:YES];
//        }];
        
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
    
}
#pragma mark ************imagePickerController代理*************
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //info是所选择照片的信息
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    //(@"info::::%@",info);
    
    //info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
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
        //NSLog(@"上传头像成功");
        
        [SYJTool saveUserDefault:@"YES" forkey:[NSString stringWithFormat:@"isavatar%@",[SYJTool getforkey:@"myid"]]];
        SYJNavigationController *navme=[self.tabBarController.viewControllers objectAtIndex:2];
        SYJMeViewController * me=(SYJMeViewController*)navme.topViewController;
        [me loadData];
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
        //NSLog(@"上传头像中");
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    }];
    
    
}
#pragma mark -- location Delegate
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    switch (status) {
//
//        casekCLAuthorizationStatusNotDetermined:
//            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//                [self.locationManager requestWhenInUseAuthorization];
//            }break;
//        default:break;
//    }
//}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
//        for (CLPlacemark *place in placemarks)
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSLog(@"市:%@",placeMark.locality);
            NSLog(@"省:%@",placeMark.administrativeArea);

//            NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
            NSDictionary *parameters = @{@"latitude":[NSString stringWithFormat:@"%f",oldCoordinate.latitude],
                                         @"longitude":[NSString stringWithFormat:@"%f",oldCoordinate.longitude],
                                         @"province":placeMark.administrativeArea,
                                         @"city":placeMark.locality
                                         };
            [HttpTool postWithPath:API_Location params:parameters hearder:nil success:^(id json) {
               // NSLog(@"定位成功");
            } failure:^(NSError *error) {
               // NSLog(@"定位失败");
            }];
        }
        else if (error == nil && placemarks.count == 0) {
            //(@"No location and error return");
        }
        else if (error) {
           // NSLog(@"location error: %@ ",error);
        }
    }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒
        [SYJProgressHUD showMessage:@"访问被拒绝" inView:self.view afterDelayTime:1];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        [SYJProgressHUD showMessage:@"无法获取位置信息" inView:self.view afterDelayTime:1];
    }
}
-(UIImageView *)NonetworkView
{
    if (_NonetworkView==nil) {
        _NonetworkView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无网络"]];
    }
    return _NonetworkView;
}
-(UIImageView*)NoFriendView
{
    if (_NoFriendView==nil) {
        _NoFriendView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无结果"]];
    }
    return _NoFriendView;
}
@end

