//
//  SYJheadCollectionViewCell.m
//  不见不散
//
//  Created by soso on 2017/12/19.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJheadCollectionViewCell.h"
#import "YTAnimation.h"
@interface SYJheadCollectionViewCell()<CAAnimationDelegate>
@end

@implementation SYJheadCollectionViewCell
{}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setCell];
        
    }
    return self;
}

#pragma mark - setAnimationType
- (void)setAnimationType
{
    //[YTAnimation toMiniAnimation:self];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    CABasicAnimation *rotationAni = [CABasicAnimation animation];
    rotationAni.keyPath = @"transform.rotation";
    rotationAni.toValue = @(M_PI_2*3);
    CABasicAnimation *scaleAni = [CABasicAnimation animation];
    scaleAni.keyPath = @"transform.scale";
    scaleAni.toValue = @(0.01);
    group.duration = 0.03;
    group.animations = @[rotationAni, scaleAni];
    [group setValue:@"toMini" forKey:@"animType"];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:group forKey:nil];
}
//the following methods ,you just need copy ~ paste
- (void)setCell{
    [self addDeleteButton];
    [self addLongPressGesture];
}
- (void)addLongPressGesture{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    [self addGestureRecognizer:lpgr];
}
- (void)longClick:(UILongPressGestureRecognizer *)lpgr
{
    [self.delegate showAllDeleteBtn];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([anim valueForKey:@"animType"] ){
        [self.delegate deleteCellAtIndexpath:_indexPath cellView:self];
    }
}
- (void)addDeleteButton{
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, 0, 20, 20);
    [_deleteBtn setImage:[UIImage imageNamed:@"photodelete"] forState:UIControlStateNormal];
    _deleteBtn.hidden = YES;
    [_deleteBtn addTarget:self action:@selector(setAnimationType) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
}
@end
