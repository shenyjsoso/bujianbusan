//
//  CardView.h
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLCardView.h"

@interface CardView : YSLCardView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *agelabel;
@property (nonatomic, strong) UILabel *heightlabel;
@property (nonatomic, strong) UILabel *addresslabel;
@property (nonatomic, strong) UILabel *distancelabel;
//@property (nonatomic, strong) UIView *selectedView;
@property(nonatomic,strong)UIImageView * dislikeView;
@property(nonatomic,strong)UIImageView * likeView;
//@property(nonatomic,assign)long userid;
@end

