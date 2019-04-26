//
//  SYJTabBar.h
//  不见不散
//
//  Created by soso on 2017/12/15.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJTabBar : UITabBar
/** 记录上一次被点击按钮的tag */
@property (nonatomic, assign) NSInteger previousClickedTag;
@end
