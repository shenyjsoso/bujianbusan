//
//  SYJLabelAndInterestVC.h
//  不见不散
//
//  Created by soso on 2017/12/23.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
typedef void(^SYJInterestVCBlock)(void);

@interface SYJInterestVC : SYJBaseViewController
@property(nonatomic,copy)SYJInterestVCBlock block;
@property(nonatomic,strong)NSMutableArray *interestArr;
@property(nonatomic,strong)NSMutableString *interestStr;
@end
