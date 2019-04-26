//
//  SYJHeadTableViewCell.m
//  不见不散
//
//  Created by soso on 2017/12/10.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJHeadTableViewCell.h"

@implementation SYJHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.personalityLbl addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)]];
    
}
-(void)changePersonString:(NSString *)personString
{
    NSTextAttachment *attch=[[NSTextAttachment alloc]init];
    attch.image=[UIImage imageNamed:@"写字"];
    attch.bounds=CGRectMake(0, 0, 12, 12);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:personString];
    
    //NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)
    //NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]};
   // [attributedString setAttributes:dic range:NSMakeRange(0, attributedString.length)];
    
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
    self.personalityLbl.attributedText = attributedString;
}
- (IBAction)changeHead:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}
-(void)labelTap:(UITapGestureRecognizer *)recognizer
{
    UILabel *label=(UILabel*)recognizer.view;
    if (self.block) {
        self.block(label);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
