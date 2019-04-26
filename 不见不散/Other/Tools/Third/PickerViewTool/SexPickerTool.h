//
//  SexPickerTool.h
//  PickerView
//
//  Created by  zengchunjun on 2017/4/20.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SexPickBlock)(NSString *pickDate);

@interface SexPickerTool : UIView

@property (nonatomic,strong)SexPickBlock callBlock;

@end
