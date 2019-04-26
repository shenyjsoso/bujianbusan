//
//  SYJheadCollectionViewCell.h
//  不见不散
//
//  Created by soso on 2017/12/19.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYJheadCollectionViewCell;
@protocol CellDelegate <NSObject>

-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath cellView:(SYJheadCollectionViewCell *)cell;
-(void)showAllDeleteBtn;
-(void)hideAllDeleteBtn;
@end
@interface SYJheadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak) id<CellDelegate>delegate;
@end
