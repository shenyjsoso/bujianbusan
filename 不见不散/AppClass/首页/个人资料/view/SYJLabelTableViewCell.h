//
//  SYJLabelTableViewCell.h
//  不见不散
//
//  Created by soso on 2017/12/24.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYJLabelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *commonLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property(nonatomic,copy)NSString *dataStr;
@end
