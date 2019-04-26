//
//  SYJSelectViewController.h
//  不见不散
//
//  Created by soso on 2017/12/6.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
typedef void (^SelectBlock)(void);
@interface SYJSelectViewController : SYJBaseViewController
@property(nonatomic,copy)SelectBlock block;
@end
