//
//  SYJPhotos.h
//  不见不散
//
//  Created by soso on 2017/12/19.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYJPhotos : NSObject
//"id": 1,
//"customerId": 2,
//"name": "2_1512386284013.png",
//"created": 1512386284027,
//"description": null
@property (nonatomic, assign) long long created;

@property (nonatomic, assign) NSInteger idField;

@property (nonatomic, assign) NSInteger customerId;

@property(nonatomic,copy)NSString *name;

@property (nonatomic, copy) NSString * descriptionField;

@end
