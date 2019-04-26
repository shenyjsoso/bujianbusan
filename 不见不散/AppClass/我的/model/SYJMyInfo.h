//
//  SYJMyInfo.h
//  不见不散
//
//  Created by soso on 2017/12/14.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJMyInfo : NSObject
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, assign) long long created;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * realName;

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString * annualIncome;

@property (nonatomic, strong) NSString * belief;
@property (nonatomic, assign) long long birthday;
@property (nonatomic, strong) NSString * blood;
@property (nonatomic, strong) NSString * car;
@property (nonatomic, strong) NSString * censusCity;
@property (nonatomic, strong) NSString * censusProvince;
@property (nonatomic, strong) NSString * children;
@property (nonatomic, strong) NSString * constellation;


@property (nonatomic, strong) NSString * education;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString * house;

@property (nonatomic, strong) NSString * interest;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * marriage;
@property (nonatomic, assign) long long * marriedTime;

@property (nonatomic, strong) NSString * nationality;

@property (nonatomic, strong) NSString * nowCity;
@property (nonatomic, strong) NSString * nowProvince;
@property (nonatomic, strong) NSString * profession;

@property (nonatomic, strong) NSString * signature;

@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, strong) NSString * zodiac;
@end
