//
//  SexPickerTool.h
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickBlock)(NSString *pickDate);

@interface PickerTool : UIView

@property (nonatomic,strong)PickBlock callBlock;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *sexPick;
@end
