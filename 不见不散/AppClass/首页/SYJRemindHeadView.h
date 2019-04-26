//
//  SYJRemindHeadView.h
//  不见不散
//
//  Created by soso on 2017/12/30.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RemindheadBlock)(void);
@interface SYJRemindHeadView : UIView
@property(nonatomic,copy)RemindheadBlock block;


@end
