//
//  DatePickerTool.h
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DatePickBlock)(NSString *pickDate);

@interface DatePickerTool : UIView

@property (nonatomic,strong)DatePickBlock callBlock;

@end
