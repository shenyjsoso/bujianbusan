//
//  SYJMyInfo.m
//  不见不散
//
//  Created by soso on 2017/12/14.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJMyInfo.h"

@implementation SYJMyInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id",
             @"descriptionField" : @"description"
             };
}
@end
