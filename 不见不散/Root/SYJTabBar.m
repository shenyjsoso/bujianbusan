//
//  SYJTabBar.m
//  不见不散
//
//  Created by soso on 2017/12/15.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJTabBar.h"

@implementation SYJTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
[super layoutSubviews];
self.translucent=NO;
NSInteger i = 0;
for (UIButton *tabbarButton in self.subviews) {
if ([tabbarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
    //绑定tag 标识
    tabbarButton.tag = i;
    i++;
    
//监听tabbar的点击.
    [tabbarButton addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
}
    
}
#pragma mark -- tabbar按钮的点击
- (void)tabbarButtonClick:(UIControl *)tabbarBtn{
    //判断当前按钮是否为上一个按钮
    if (self.previousClickedTag == tabbarBtn.tag) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"TabbarButtonClickDidRepeatNotification" object:nil];
    }
    self.previousClickedTag = tabbarBtn.tag;
}

@end
