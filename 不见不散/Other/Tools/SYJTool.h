//
//  SYJTool.h
//  不见不散
//
//  Created by soso on 2017/12/9.
//  Copyright © 2017年 soso. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^cleanCacheBlock)(void);
@interface SYJTool : NSObject
//保存token
+(void)saveaccessToken:(NSString*)token;
//取userdefault里的值
+(NSString*)getforkey:(NSString*)key;
//向userdefault保存
+(void)saveUserDefault:(NSString*)info forkey:(NSString*)key;
//取error的code信息
+(NSDictionary*)code1011:(NSError*)error;
//警告框
+(UIAlertController*)showAlterYesOrNo:(NSString*)warning;
//时间戳->日期
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
//日期转毫秒
+(long long)getagetime:(NSString*)time;

/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;
/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;
//字典转json
+(NSString *)convertToJsonData:(NSDictionary *)dict;
@end
