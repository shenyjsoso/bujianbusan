//
//  SYJRemindHeadView.m
//  不见不散
//
//  Created by soso on 2017/12/30.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJRemindHeadView.h"

@implementation SYJRemindHeadView
- (IBAction)Close:(UIButton *)sender {
    [self removeFromSuperview];
    
}
- (IBAction)headPicture:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
