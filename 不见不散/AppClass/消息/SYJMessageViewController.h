//
//  SYJMessageViewController.h
//  不见不散
//
//  Created by soso on 2017/11/28.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJBaseViewController.h"
#import "ConversationListController.h"
@interface SYJMessageViewController : SYJBaseViewController
@property (nonatomic,assign)NSInteger tag;
@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)ConversationListController *ListView;
@end
