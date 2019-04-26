//
//  SYJRegisterViewController.h
//  不见不散
//
//  Created by soso on 2017/12/3.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
#import "JKCountDownButton.h"
@interface SYJAlterViewController : SYJBaseViewController
@property (weak, nonatomic) IBOutlet JKCountDownButton *sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property(nonatomic,copy)NSString *phoneStr;
@end
