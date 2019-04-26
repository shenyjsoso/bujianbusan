//
//  SYJTool.m
//  不见不散
//
//  Created by soso on 2017/12/9.
//  Copyright © 2017年 soso. All rights reserved.
//

#import "SYJTool.h"

@implementation SYJTool
+(void)saveaccessToken:(NSString*)token
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:token forKey:@"accessToken"];
    [userDefault synchronize];
}
+(void)saveUserDefault:(NSString*)info forkey:(NSString*)key
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:info forKey:key];
    [userDefault synchronize];
}

+(NSString*)getforkey:(NSString*)key
{
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    return [user objectForKey:key];
}

+(NSDictionary*)code1011:(NSError *)error
{
    NSDictionary * errorInfo = error.userInfo;
    if ([[errorInfo allKeys] containsObject: @"com.alamofire.serialization.response.error.data"]){
        NSData * errorData = errorInfo[@"com.alamofire.serialization.response.error.data"];
        NSDictionary * errorDict =  [NSJSONSerialization JSONObjectWithData: errorData options:NSJSONReadingAllowFragments error:nil];
        return errorDict;
    }
    return nil;
}
//
+(UIAlertController*)showAlterYesOrNo:(NSString*)warning
{
    UIAlertController *alterController=[UIAlertController alertControllerWithTitle:@"提示" message:warning preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alterController addAction:cancelAction];
    return alterController;
}
//时间戳->日期
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
//日期转毫秒
+(long long)getagetime:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date1=[dateFormatter dateFromString:time];
    return [date1 timeIntervalSince1970]*1000;
}
/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
//        NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//
//        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
//
//        for (NSString *subPath in subpaths) {
//            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
//            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//        }
        //SDWebImage的清除功能
        //[[SDImageCache sharedImageCache] clearMemory]; 可有可无？
        [[SDImageCache sharedImageCache] clearDisk];
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
    
}
/**
 *  计算整个目录大小
 */
+(float)folderSizeAtPath
{
    
//    NSString *folderPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//
//    NSFileManager * manager=[NSFileManager defaultManager ];
//    if (![manager fileExistsAtPath :folderPath]) {
//        return 0 ;
//    }
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
//    NSString * fileName;
    long long folderSize = 0 ;
//    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
//        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
//        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
//    }
    folderSize+=[[SDImageCache sharedImageCache]getSize];
    return folderSize/( 1024.0 * 1024.0 );
}
/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
    
}
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
@end
