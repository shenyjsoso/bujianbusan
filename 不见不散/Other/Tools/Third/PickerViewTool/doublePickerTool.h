//
//  SexPickerTool.h
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TWOPickBlock)(NSString *pickDate,NSString *pickDatetwo);
@interface doublePickerTool : UIView

@property (nonatomic,strong)TWOPickBlock callBlock;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *minPick;
@property (nonatomic,copy)NSString *maxPick;
@end
