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

#import "HttpTool.h"
#import <AFNetworking/AFNetworking.h>   //第三方_网络请求AFN

static NSString * kBaseUrl = SERVER_HOST;

@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient {
    
    static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:configuration];
        //请求头
        //[client.requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif",@"image/jpeg",@"image/png",@"multipart/form-data", nil];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 15;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    return client;
}

@end

@implementation HttpTool

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
             hearder:(NSString *)hearder
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
    if (hearder) {
        [[AFHttpClient sharedClient].requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
    }
   // AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [[AFHttpClient sharedClient] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (void)postWithPath:(NSString *)path
             params:(NSDictionary *)params
             hearder:(NSString *)hearder
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];

    if (hearder) {
        [[AFHttpClient sharedClient].requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
    }
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//put 网络请求
+ (void)putWithPath:(NSString *)path
             params:(NSDictionary *)params
            hearder:(NSString *)hearder
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure
{
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
    if (hearder) {
        [[AFHttpClient sharedClient].requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
    }
    [[AFHttpClient sharedClient] PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)deleteWithPath:(NSString *)path
                params:(NSDictionary *)params
               hearder:(NSString *)hearder
               success:(HttpSuccessBlock)success
               failure:(HttpFailureBlock)failure
{
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
    if (hearder) {
        [[AFHttpClient sharedClient].requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
    }
    [[AFHttpClient sharedClient] DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    

}

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 hearder:(NSString *)hearder
                 failure:(HttpFailureBlock)failure
                 progress:(HttpDownloadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
    if (hearder) {
        [[AFHttpClient sharedClient].requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
    }
    //下载
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];
    
}

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                    hearder:(NSString *)hearder
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
    if (hearder) {
        [[AFHttpClient sharedClient].requestSerializer setValue:hearder forHTTPHeaderField:@"Authorization"];
    }
    //NSData * data = UIImagePNGRepresentation(image);
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        // 设置时间格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:imagekey fileName:fileName mimeType:@"image/png"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        progress(uploadProgress.fractionCompleted);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(error);

    }];
}

@end
