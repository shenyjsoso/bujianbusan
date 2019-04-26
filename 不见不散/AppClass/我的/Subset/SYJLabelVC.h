//
//  SYJLabelAndInterestVC.h
//  不见不散
//
//  Created by soso on 2017/12/23.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
typedef void(^SYJLabelVCBlock)(void);

@interface SYJLabelVC : SYJBaseViewController
@property(nonatomic,copy)SYJLabelVCBlock block;
@property(nonatomic,strong)NSMutableArray *LabelArr;
@property(nonatomic,strong)NSMutableString *LabelStr;
@end
