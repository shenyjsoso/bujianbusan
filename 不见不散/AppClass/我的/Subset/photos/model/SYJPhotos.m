//
//  SYJPhotos.m
//  不见不散
//
//  Created by soso on 2017/12/19.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJPhotos.h"

@implementation SYJPhotos
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idField" : @"id",
             @"descriptionField" : @"description"
             };
}
@end
