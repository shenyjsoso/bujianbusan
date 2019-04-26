//
//  SYJRecommends.h
//  不见不散
//
//  Created by soso on 2017/12/2.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJRecommends : NSObject
//年龄
@property (nonatomic, assign) long age;
//照片
@property (nonatomic, copy) NSString *avatar;
//
@property (nonatomic, assign) long customerId;
//距离
@property (nonatomic, copy) NSString *distance;
//
@property (nonatomic, assign) long gender;
//
@property (nonatomic, assign) long height;
//
@property (nonatomic, copy) NSString *nickName;
//
@property (nonatomic, copy) NSString *place;




@end
