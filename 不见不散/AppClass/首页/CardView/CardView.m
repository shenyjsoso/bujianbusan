//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"
#define labelwidth 40
#define labelhegiht 18//self.frame.size.height * 0.15/3-4
#define labelY _namelabel.frame.origin.y+_namelabel.frame.size.height
@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageView = [[UIImageView alloc]init];
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.85);
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    [self addSubview:_imageView];

    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(6.0, 6.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
    //喜欢和不喜欢图案
    _dislikeView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"不喜欢"]];
    _dislikeView.frame=CGRectMake(self.frame.size.width-65-10, 10, 65, 65);
    _dislikeView.alpha=0.0;
    [_imageView addSubview:_dislikeView];
    _likeView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"喜欢"]];
    _likeView.frame=CGRectMake(0+10, 10, 65, 65);
    _likeView.alpha=0.0;
    [_imageView addSubview:_likeView];
    //姓名
    _namelabel = [[UILabel alloc]init];
    _namelabel.backgroundColor = [UIColor clearColor];
    _namelabel.frame = CGRectMake(5, self.frame.size.height * 0.85, self.frame.size.width - 10, self.frame.size.height * 0.15/3+5);
    _namelabel.textColor=SYJColor(102, 102, 102, 1);
    _namelabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_namelabel];
    //年龄
    _agelabel=[[UILabel alloc]init];
    _agelabel.backgroundColor=SYJColor(255, 187, 197, 1);
    _agelabel.frame=CGRectIntegral(CGRectMake(5, labelY, labelwidth, labelhegiht));
    _agelabel.textColor=SYJColor(255, 255, 255, 1);
    _agelabel.layer.cornerRadius = 3;
    _agelabel.clipsToBounds = YES;
    _agelabel.font=[UIFont systemFontOfSize:12];
    _agelabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_agelabel];
    //身高
    _heightlabel=[[UILabel alloc]init];
    _heightlabel.backgroundColor=SYJColor(90, 245, 93, 1);
    _heightlabel.frame=CGRectIntegral(CGRectMake(5+labelwidth+5, labelY, labelwidth, labelhegiht));
    _heightlabel.textColor=SYJColor(255, 255, 255, 1);
    _heightlabel.layer.cornerRadius = 3;
    _heightlabel.clipsToBounds = YES;
    _heightlabel.font=[UIFont systemFontOfSize:12];
    _heightlabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_heightlabel];
    //地址
    _addresslabel=[[UILabel alloc]init];
    _addresslabel.backgroundColor=SYJColor(172, 172, 172, 1);
    _addresslabel.textColor=SYJColor(255, 255, 255, 1);
    _addresslabel.layer.cornerRadius = 3;
    _addresslabel.clipsToBounds = YES;
    _addresslabel.font=[UIFont systemFontOfSize:12];
    _addresslabel.textAlignment=NSTextAlignmentCenter;
//   CGSize lblsize= [_addresslabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_addresslabel.font,NSFontAttributeName,nil]];
//   CGFloat addressW=lblsize.width;
    _addresslabel.frame=CGRectIntegral(CGRectMake(5+labelwidth+5+labelwidth+5, labelY, labelwidth, labelhegiht));
    [self addSubview:_addresslabel];

    //距离
    if (isIPhone) {
        _distancelabel=[[UILabel alloc]init];
        _distancelabel.backgroundColor=[UIColor clearColor];
        _distancelabel.frame=CGRectMake(5, labelY+labelhegiht, self.frame.size.width - 10, self.frame.size.height * 0.2/3-10);
        _distancelabel.textColor=SYJColor(102, 102, 102, 1);
        _distancelabel.font=[UIFont systemFontOfSize:12];
        [self addSubview:_distancelabel];
    }

    
}

@end

