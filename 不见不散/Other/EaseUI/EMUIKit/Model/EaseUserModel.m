/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseUserModel.h"

@implementation EaseUserModel

- (instancetype)initWithBuddy:(NSString *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        [UserCacheManager getUserInfo:buddy completed:^(UserCacheInfo *userInfo) {
            if (userInfo.nickName) {
                _nickname=userInfo.nickName;
            }
            else
            {
                _nickname = @"";
            }
            if (userInfo.avatarUrl) {
                _avatarURLPath=userInfo.avatarUrl;
                _avatarImage = [UIImage imageNamed:@"默认头像"];
            }
            else
            {
                _avatarImage = [UIImage imageNamed:@"默认头像"];
            }
        }];
        
       // _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    }
    
    return self;
}

@end
