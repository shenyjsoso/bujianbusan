//
//  SYJFunctionTableViewCell.m
//  不见不散
//
//  Created by soso on 2017/12/12.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJFunctionTableViewCell.h"

@implementation SYJFunctionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)VIPVC:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}
- (IBAction)selectMateVC:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}
- (IBAction)personVC:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
