//
//  SYJPushButton.m
//  
//
//  Created by soso on 2017/11/21.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJPushButton.h"
#define animateDelay 0.05   //默认动画执行时间
#define defaultScale 0.95    //默认缩小的比率
@implementation SYJPushButton
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (SYJPushButton *)buttonWithType:(UIButtonType)type
frame:(CGRect)frame
title:(NSString *)title
titleColor:(UIColor *)color
backgroundColor:(UIColor *)backgroundColor
backgroundImage:(NSString *)image
andBlock:(ClickBlock)tempBlock
{
SYJPushButton * pushBtn = [SYJPushButton buttonWithType:type];
pushBtn.frame = frame;
    [pushBtn setTitle:title forState:UIControlStateNormal];
    [pushBtn setTitleColor:color forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:backgroundColor];
    [pushBtn addTarget:pushBtn action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [pushBtn addTarget:pushBtn action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [pushBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    //给按钮的block赋值
    pushBtn.clickBlock = tempBlock;
    
    return pushBtn;
}

+ (SYJPushButton *)touchUpOutsideCancelButtonWithType:(UIButtonType)type
                                                  frame:(CGRect)frame
                                                  title:(NSString *)title
                                             titleColor:(UIColor *)color
                                        backgroundColor:(UIColor *)backgroundColor
                                        backgroundImage:(NSString *)image
                                               andBlock:(ClickBlock)tempBlock
{
    SYJPushButton * pushBtn = [SYJPushButton buttonWithType:type];
    pushBtn.frame = frame;
    [pushBtn setTitle:title forState:UIControlStateNormal];
    [pushBtn setTitleColor:color forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:backgroundColor];
    [pushBtn addTarget:pushBtn action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [pushBtn addTarget:pushBtn action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [pushBtn addTarget:pushBtn action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [pushBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [pushBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateDisabled];
    
    //给按钮的block赋值
    pushBtn.clickBlock = tempBlock;
    
    return pushBtn;
}

//按钮的压下事件 按钮缩小
- (void)pressedEvent:(SYJPushButton *)btn
{
    //缩放比例必须大于0，且小于等于1
    CGFloat scale = (_buttonScale && _buttonScale <=1.0) ? _buttonScale : defaultScale;
    
    [UIView animateWithDuration:animateDelay animations:^{
        btn.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}
//点击手势拖出按钮frame区域松开，响应取消
- (void)cancelEvent:(SYJPushButton *)btn
{
    [UIView animateWithDuration:animateDelay animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(SYJPushButton *)btn
{
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.5;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [btn.layer addAnimation:animation forKey:nil];
//    if (self.clickBlock) {
//        self.clickBlock();
//    }
        [UIView animateWithDuration:animateDelay animations:^{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            //执行动作响应
            if (self.clickBlock) {
                self.clickBlock();
            }
        }];
}

//此方法重写为空，可以将image按钮的点击灰色去掉
//- (void)setHighlighted:(BOOL)highlighted
//{
//
//}
@end
