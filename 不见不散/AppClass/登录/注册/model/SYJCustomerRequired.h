//
//  SYJCustomerRequired.h
//  不见不散
//
//  Created by soso on 2017/12/9.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJCustomerRequired : NSObject

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, assign) long long created;

@property (nonatomic, assign) long long expiresIn;

@property (nonatomic, copy) NSString *refreshToken;


@end
