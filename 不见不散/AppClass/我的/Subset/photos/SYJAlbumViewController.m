//
//  SYJAlbumViewController.m
//  不见不散
//
//  Created by soso on 2017/12/19.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJAlbumViewController.h"
#import "SYJheadCollectionViewCell.h"
#import "SYJAddCollectionViewCell.h"
#import "SYJPhotos.h"
#import "UIImage+SYJImage.h"
//#import "CFYNavigationBarTransition.h"
//#import "UINavigationController+CFYNavigationBarTransition_Public.h"
#import "YTAnimation.h"
#import "HUPhotoBrowser.h"
#import "UIImageView+HUWebImage.h"
static NSString *headcellId = @"SYJheadCollectionViewCell";
static NSString *addcellId = @"SYJAddCollectionViewCell";
@interface SYJAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CellDelegate>
{
    BOOL deleteBtnFlag;
    BOOL vibrateAniFlag;
}
@property(nonatomic,strong)UICollectionView *imageCollectionView;
@property (nonatomic, strong) NSMutableArray *URLStrings;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@end

@implementation SYJAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"个人相册";
    
    [self initUI];
    [self loadData];
    [self setFlagAndGsr];
}
-(void)initUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 1.5;
    //最小两行之间的间距
    layout.minimumLineSpacing = 1.5;
    //设置collectionView滚动方向
    //[layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置headerView的尺寸大小
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    layout.itemSize =CGSizeMake((ScreenWidth-3)/3, (ScreenWidth-3)/3);
    //2.初始化collectionView
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    self.imageCollectionView.backgroundColor=[UIColor whiteColor];
    self.imageCollectionView.alwaysBounceVertical=YES;
    [self.view addSubview:self.imageCollectionView];
 
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"SYJheadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:headcellId];
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"SYJAddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:addcellId];
    
    //4.设置代理
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;

}
-(void)loadData
{
    self.URLStrings=[NSMutableArray array];
    self.datas=[NSMutableArray array];
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [HttpTool getWithPath:API_photos params:nil hearder:nil success:^(id json) {
        //NSLog(@"我的相册%@",json);
        self.datas=[SYJPhotos mj_objectArrayWithKeyValuesArray:json];
       // [self.imageCollectionView.mj_header endRefreshing];
        for (SYJPhotos *url in self.datas) {
            NSString *sd=[API_fullphoto stringByAppendingString:url.name];
            [self.URLStrings addObject:sd];
        }
        [self.imageCollectionView reloadData];
    } failure:^(NSError *error) {
        [SYJProgressHUD showMessage:@"获取相册失败" inView:self.view afterDelayTime:1];
        //NSLog(@"失败");
      //  [self.imageCollectionView.mj_header endRefreshing];
    }];
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
    return self.datas.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==self.datas.count) {
        SYJAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addcellId forIndexPath:indexPath];
        cell.backgroundColor = SYJColor(226, 226, 226, 1);
        [cell.addImage setImage:[UIImage imageNamed:@"添加"]];
        return cell;
    }
    else
    {
        
        
        SYJheadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:headcellId forIndexPath:indexPath];
        //add this in your  "cellForItemAtIndexPath"长按抖动三方
        [self setCellVibrate:cell IndexPath:indexPath];
        
        cell.backgroundColor=SYJColor(226, 226, 226, 1);
        //缩略图
        //SYJPhotos *myphotos=self.datas[indexPath.item];
        //NSString *sd=[API_avatar stringByAppendingString:myphotos.name];
       // [cell.myImage sd_setImageWithURL:[NSURL URLWithString:sd]];
        cell.myImage.contentMode=UIViewContentModeScaleAspectFill;
        cell.myImage.clipsToBounds=YES;
        //原图
        [cell.myImage hu_setImageWithURL:[NSURL URLWithString:self.URLStrings[indexPath.row]]];
        
        return cell;
    }
    
    
}

//设置每个item的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.item==0) {
//        return CGSizeMake((ScreenWidth-3)*2/3+1.5 , (ScreenWidth-3)*2/3+1.5);
//    }
//    else
//
//    return CGSizeMake((ScreenWidth-3)/3, (ScreenWidth-3)/3);
//}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 20, 0);
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    NSString *msg = cell.botlabel.text;
    if (indexPath.item==self.datas.count) {
        if (self.datas.count>=8) {
            [SYJProgressHUD showMessage:@"最多上传8张" inView:self.view afterDelayTime:1];
            return;
        }
        //调用系统相册的类
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        //设置选取的照片是否可编辑
        self.imagePicker.allowsEditing = YES;
    
        UIAlertController *alterController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *PhotoLibraryAction=[UIAlertAction actionWithTitle:@"从相册选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //设置相册呈现的样式
            self.imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
            }];
        UIAlertAction *CameraLibraryAction=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //设置相机呈现的样式
            self.imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alterController addAction:PhotoLibraryAction];
        [alterController addAction:CameraLibraryAction];
        [alterController addAction:cancelAction];
        //alterController.view.tintColor=NAVBAR_Color;
        [self presentViewController:alterController animated:YES completion:nil];
    }
    else
    {
        //NSLog(@"点击了");
        SYJheadCollectionViewCell *cell = (SYJheadCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [HUPhotoBrowser showFromImageView:cell.myImage withURLStrings:_URLStrings atIndex:indexPath.item];
    }
}

#pragma mark ************imagePickerController代理*************
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //info是所选择照片的信息
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    //[self cfy_setNavigationBarAlpha:0];
   // [self.navigationController setNavigationBarHidden:YES];
   // NSLog(@"info::::%@",info);
//    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    //NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];

    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    NSData *imageData=UIImageJPEGRepresentation(resultImage, 1);
    //  NSDictionary *params=@{@"avatar":imageData};
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *keyName = [NSString stringWithFormat:@"%@", str];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"上传中...";
    //hud.delegate=self;
    [HttpTool uploadImageWithPath:API_photos params:nil hearder:nil thumbName:keyName image:resultImage success:^(id json) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self loadData];
        }];
        [hud hideAnimated:YES];
    
        [self.imageCollectionView reloadData];
    } failure:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:^{}];
        [hud hideAnimated:YES];
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
        //NSLog(@"上传图片中%f",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
//删除相册
-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(SYJheadCollectionViewCell *)cell
{
    
    [self.imageCollectionView performBatchUpdates:^{
        SYJPhotos *photo=self.datas[indexPath.row];
        NSString *url=[API_photos stringByAppendingString:[NSString stringWithFormat:@"/%ld",photo.idField]];
//        NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
        [HttpTool deleteWithPath:url params:nil hearder:nil success:^(id json) {
            //NSLog(@"删除成功");
           // [self.imageCollectionView reloadData];
        } failure:^(NSError *error) {
            //NSLog(@"删除失败");
        }];
        [self.URLStrings removeObjectAtIndex:indexPath.row];
        [self.datas removeObjectAtIndex:indexPath.row];
        [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.imageCollectionView reloadData];
    }];
}
#pragma mark the following methods you just need copy ~ paste
- (void)setFlagAndGsr{
    deleteBtnFlag = YES;
    vibrateAniFlag = YES;
    [self addDoubleTapGesture];
}
- (void)setCellVibrate:(SYJheadCollectionViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = deleteBtnFlag?YES:NO;
    //抖动效果
    if (!vibrateAniFlag) {
       // [YTAnimation vibrateAnimation:cell];
    }else{
        [cell.layer removeAnimationForKey:@"shake"];
    }
    cell.delegate = self;
}
- (void) handleDoubleTap:(UITapGestureRecognizer *) gestureRecognizer{
    [self hideAllDeleteBtn];
}
- (void)addDoubleTapGesture{
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubletap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubletap];
}
- (void)hideAllDeleteBtn{
    if (!deleteBtnFlag) {
        deleteBtnFlag = YES;
        vibrateAniFlag = YES;
        [self.imageCollectionView reloadData];
    }
}
- (void)showAllDeleteBtn{
    deleteBtnFlag = NO;
    vibrateAniFlag = NO;
    [self.imageCollectionView reloadData];
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
