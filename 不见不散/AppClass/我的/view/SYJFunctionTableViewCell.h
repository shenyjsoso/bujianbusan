//
//  SYJFunctionTableViewCell.h
//  不见不散
//
//  Created by soso on 2017/12/12.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FunctionTableViewCellBlock)(UIButton *sender);
@interface SYJFunctionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *VIPbtn;
@property (weak, nonatomic) IBOutlet UIButton *selectMatebtn;
@property (weak, nonatomic) IBOutlet UIButton *personPhotobtn;

@property(nonatomic,copy)FunctionTableViewCellBlock block;
@end
