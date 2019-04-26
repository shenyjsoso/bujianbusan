//
//  SYJBasicInfoTableViewCell.h
//  不见不散
//
//  Created by soso on 2017/12/17.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJBasicInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sexLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageLbl;
@property (weak, nonatomic) IBOutlet UILabel *heightLbl;
@property (weak, nonatomic) IBOutlet UILabel *weightLbl;
@property (weak, nonatomic) IBOutlet UILabel *bloodLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;

@end
