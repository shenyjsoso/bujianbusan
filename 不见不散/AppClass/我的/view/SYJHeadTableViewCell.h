//
//  SYJHeadTableViewCell.h
//  不见不散
//
//  Created by soso on 2017/12/10.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SYJHeadTableViewCellBlock)(id sender);
@interface SYJHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *personalityLbl;
@property(nonatomic,copy)SYJHeadTableViewCellBlock block;
-(void)changePersonString:(NSString *)personString;
@end
