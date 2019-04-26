/**
 *   ┏┓　　　┏┓
 * ┏┛┻━━━┛┻┓
 * ┃　　　　　　　┃
 * ┃　　　━　　　┃
 * ┃　┳┛　┗┳　┃
 * ┃　　　　　　　┃
 * ┃　　　┻　　　┃
 * ┃　　　　　　　┃
 * ┗━┓　　　┏━┛
 *    ┃　　　┃
 *    ┃　　　┃
 *    ┃　　　┗━━━┓
 *    ┃　　　　　　　┣┓
 *    ┃　　　　　　　┏┛
 *    ┗┓┓┏━┳┓┏┛
 *      ┃┫┫　┃┫┫
 *      ┗┻┛　┗┻┛
 *        神兽保佑
 *        代码无BUG!
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock)(id json);
typedef void (^HttpFailureBlock)(NSError * error);
typedef void (^HttpDownloadProgressBlock)(CGFloat progress);
typedef void (^HttpUploadProgressBlock)(CGFloat progress);


@interface HttpTool : NSObject

/**
 *  get网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            hearder:(NSString *)hearder
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;

/**
 *  post网络请求
 *
 *  @param path    url地址
 *  @param params  url参数  NSDictionary类型
 *  @param success 请求成功 返回NSDictionary或NSArray
 *  @param failure 请求失败 返回NSError
 */

+ (void)postWithPath:(NSString *)path
             params:(NSDictionary *)params
            hearder:(NSString *)hearder
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;
//put 网络请求
+ (void)putWithPath:(NSString *)path
              params:(NSDictionary *)params
             hearder:(NSString *)hearder
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

//delete 网络请求
+ (void)deleteWithPath:(NSString *)path
             params:(NSDictionary *)params
            hearder:(NSString *)hearder
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;
/**
 *  下载文件
 *
 *  @param path     url路径
 *  @param success  下载成功
 *  @param failure  下载失败
 *  @param progress 下载进度
 */

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 hearder:(NSString *)hearder
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress;

/**
 *  上传图片
 *
 *  @param path     url地址
 *  @param image    UIImage对象
 *  @param imagekey    imagekey
 *  @param params  上传参数
 *  @param success  上传成功
 *  @param failure  上传失败
 *  @param progress 上传进度
 */

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                    hearder:(NSString *)hearder
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;


@end
