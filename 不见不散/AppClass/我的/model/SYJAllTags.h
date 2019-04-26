//
//  SYJAllTags.h
//  不见不散
//
//  Created by soso on 2017/12/29.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJAllTags : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger tagType;
@property (nonatomic, assign) NSInteger choiceType;
@property (nonatomic, strong) NSString * descriptionField;
@property(nonatomic,strong)NSMutableArray *tags;
@end
