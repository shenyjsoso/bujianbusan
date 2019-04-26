//
//  UIView+SYJUIView.m
//  不见不散
//
//  Created by soso on 2017/12/15.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "UIView+SYJUIView.h"

@implementation UIView (SYJUIView)
/** 判断self和anotherView是否重叠 */
- (BOOL)hu_intersectsWithAnotherView:(UIView *)anotherView
{
    
    //如果anotherView为nil，那么就代表keyWindow
    if (anotherView == nil) anotherView = [UIApplication sharedApplication].keyWindow;
    
    
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    
    CGRect anotherRect = [anotherView convertRect:anotherView.bounds toView:nil];
    
    //CGRectIntersectsRect是否有交叉
    return CGRectIntersectsRect(selfRect, anotherRect);
}

@end
