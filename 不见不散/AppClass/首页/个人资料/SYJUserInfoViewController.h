//
//  SYJUserInfoViewController.h
//  不见不散
//
//  Created by soso on 2017/12/2.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"

@interface SYJUserInfoViewController : SYJBaseViewController
@property(nonatomic,assign)long customerId;
@property(nonatomic,assign)long gender;

@property (nonatomic, strong) UITableView  *tableView;

@property(nonatomic,strong)UIImageView *heardImage;

//@property(nonatomic,strong)UIButton *likeOrNoBtn;

//@property (nonatomic, strong) UIView *bottomView;

//@property(nonatomic,strong)UIButton *chatBtn;
@property(nonatomic,strong)UIButton *bottomBtn;

@property(nonatomic,copy)NSString *signatureStr;
@property (nonatomic, copy) NSString * blood;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, copy) NSString * nowCity;
@property (nonatomic, copy) NSString * nowProvince;

@property (nonatomic, copy) NSString * marriage;
@property (nonatomic, copy) NSString * house;
@property (nonatomic, copy) NSString * profession;
@property (nonatomic, copy) NSString * car;
@property (nonatomic, copy) NSString * censusCity;
@property (nonatomic, copy) NSString * censusProvince;
@property (nonatomic, copy) NSString * children;
@property (nonatomic, copy) NSString * education;
@property (nonatomic, copy) NSString * annualIncome;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * interest;

@property(nonatomic,assign)BOOL isChat;
@end
