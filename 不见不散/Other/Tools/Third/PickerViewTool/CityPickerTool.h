//
//  SexPickerTool.h
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnePickBlock)(NSString *pickDate,NSString *pickDatetwo);

@interface CityPickerTool : UIView
@property (nonatomic,copy)OnePickBlock callBlock;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,copy)NSString *provincePick;
@property (nonatomic,copy)NSString *cityPick;
@end
