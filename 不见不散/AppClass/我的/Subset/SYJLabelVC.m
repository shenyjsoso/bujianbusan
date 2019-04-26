//
//  SYJLabelAndInterestVC.m
//  不见不散
//
//  Created by soso on 2017/12/23.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJLabelVC.h"
#import "SYJInterestCollectionViewCell.h"
static NSString* InterestCell=@"SYJInterestCollectionViewCell";
@interface SYJLabelVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *CollectionView;

@end

@implementation SYJLabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.navigationItem.title=@"我的标签";
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem=right;
    
}
-(void)initUI
{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 10;
    //最小两行之间的间距
    layout.minimumLineSpacing = 10;
    //设置collectionView滚动方向
    //[layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置headerView的尺寸大小
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
    //layout.itemSize =CGSizeMake((ScreenWidth-3)/3, (ScreenWidth-3)/3);
    //2.初始化collectionView
    self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-STATUS_HEIGHT-NAVBAR_HEIGHT) collectionViewLayout:layout];
    self.CollectionView.backgroundColor=[UIColor whiteColor];
    self.CollectionView.alwaysBounceVertical=YES;
    [self.view addSubview:self.CollectionView];
    
    [self.CollectionView registerNib:[UINib nibWithNibName:@"SYJInterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:InterestCell];

    //4.设置代理
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    
}
-(void)finish
{
    if (self.LabelStr.length>0) {
        NSRange range1 = {0, 1};
        if ([[self.LabelStr substringWithRange:range1] isEqualToString:@","]) {
            [self.LabelStr deleteCharactersInRange:range1];
        }
        NSArray *array = [self.LabelStr componentsSeparatedByString:@","];
        if (array.count>8) {
            [SYJProgressHUD showMessage:@"最多只能选择8个" inView:self.view afterDelayTime:1];
            return;
        }
    }
    NSDictionary *parameters = @{@"label":self.LabelStr};
//    NSString *value=[NSString stringWithFormat:@"Bearer %@",[SYJTool getforkey:@"accessToken"]];
    [HttpTool putWithPath:API_MyInfo params:parameters hearder:nil success:^(id json) {
        if (self.block) {
            self.block();
            [self.navigationController popViewControllerAnimated:YES];
        }
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
#pragma mark ***********CollectionView代理**********
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.LabelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    SYJInterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:InterestCell forIndexPath:indexPath];
    cell.interestLbl.text=self.LabelArr[indexPath.item];
    [cell.interestLbl sizeToFit];
    cell.layer.borderWidth=1;
    cell.layer.cornerRadius=5;
    cell.layer.masksToBounds=YES;
    
    //分割字符串
    NSArray *array = [self.LabelStr componentsSeparatedByString:@","];
    for (NSString *str in array) {
        if ([str isEqualToString:self.LabelArr[indexPath.item]]) {
            cell.isAdd=YES;
            break;
        }
    }
    if (cell.isAdd==YES) {
        cell.interestLbl.textColor=[UIColor whiteColor];
        cell.layer.borderColor=NAVBAR_Color.CGColor;
        cell.backgroundColor=NAVBAR_Color;
    }
    else if (cell.isAdd==NO)
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.interestLbl.textColor=SYJColor(152, 152, 152, 1);
        cell.layer.borderColor=SYJColor(152, 152, 152, 1).CGColor;
    }
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //SYJInterestCollectionViewCell *cell = (SYJInterestCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGSize size=[self sizeWithText:self.LabelArr[indexPath.item] font:[UIFont systemFontOfSize:18]];
    size.height+=5;
    size.width+=20;
    return size;
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attrDict];
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    SYJInterestCollectionViewCell *cell = (SYJInterestCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isAdd==NO) {
        NSArray *array = [self.LabelStr componentsSeparatedByString:@","];
        if (array.count>8) {
            [SYJProgressHUD showMessage:@"最多只能选择8个" inView:self.view afterDelayTime:1];
            
            for (SYJInterestCollectionViewCell *ce in collectionView.visibleCells) {
                if (ce.isAdd==NO) {
                    ce.userInteractionEnabled=NO;
                }
            }
            
            return;
        }
        
        cell.isAdd=YES;
        cell.interestLbl.textColor=[UIColor whiteColor];
        cell.layer.borderColor=NAVBAR_Color.CGColor;
        cell.backgroundColor=NAVBAR_Color;
        [self.LabelStr appendString:[NSString stringWithFormat:@",%@", self.LabelArr[indexPath.item]]];
       // NSLog(@"兴趣爱好:%@",self.LabelStr);
    }
    else if (cell.isAdd==YES)
    {
        for (SYJInterestCollectionViewCell *ce in collectionView.visibleCells) {
            if (ce.isAdd==NO) {
                ce.userInteractionEnabled=YES;
            }
        }

        cell.isAdd=NO;
        cell.backgroundColor=[UIColor clearColor];
        cell.interestLbl.textColor=SYJColor(152, 152, 152, 1);
        cell.layer.borderColor=SYJColor(152, 152, 152, 1).CGColor;
        NSRange substr = [self.LabelStr rangeOfString:[NSString stringWithFormat:@",%@",self.LabelArr[indexPath.item]]];
        while (substr.location != NSNotFound) {
            [self.LabelStr deleteCharactersInRange:substr];
            substr = [self.LabelStr rangeOfString:[NSString stringWithFormat:@",%@",self.LabelArr[indexPath.item]]];
        }
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
