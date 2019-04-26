//
//  SYJWriteViewController.h
//  不见不散
//
//  Created by soso on 2017/12/13.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
typedef void(^SYJWriteViewControllerBlock)(void);

@interface SYJWriteViewController : SYJBaseViewController
@property (nonatomic, strong) UITextView *textView;
@property(nonatomic,copy)SYJWriteViewControllerBlock block;
@property(nonatomic,copy)NSString *String;
@property(nonatomic,copy)NSString *parameters;
@property(nonatomic,assign)NSInteger length;
-(instancetype)initWithString:(NSString*)Str Length:(NSInteger)len Par: (NSString*)parameters;
@end
