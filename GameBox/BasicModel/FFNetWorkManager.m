//
//  FFNetWorkManager.m
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNetWorkManager.h"
#import <AFNetworking/AFNetworking.h>


@implementation FFNetWorkManager

/** post */
+ (void)postRequestWithURL:(NSString *)url Params:(NSDictionary *)params Completion:(RequestCallBackBlock)completion {
    [self postRequestWithURL:url Params:params Success:^(NSDictionary *content) {
        if (completion) {
            completion(content,true);
        }
    } Failure:^(NSError *error) {
        if (completion) {
            completion(@{@"msg":error.localizedDescription},false);
        }
    }];
}

+ (void)postRequestWithURL:(NSString *)url Params:(NSDictionary *)params Success:(SuccessBlock)success Failure:(FailureBlock)failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
                success(responseObject);
            } else {
                success(@{@"error":@"json serializer error"});
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 上传图片 */
+ (void)uploadImageWithURL:(NSString *)url
                    Params:(NSDictionary *)params
                  FileData:(NSArray<NSData *> *)fileDataArray
                  FileName:(NSString *)fileName
                      Name:(NSString *)name
                  MimeType:(NSString *)mimeType
                  Progress:(UploadProgressBlock)progress
                   Success:(SuccessBlock)success
                   Failure:(FailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    manager.requestSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/gif",
                                                         nil];

    NSURLSessionDataTask *task = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData *data in fileDataArray) {
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

    [task resume];
}

+ (FFNetworkReachabilityStatus)netWorkState {
    return (FFNetworkReachabilityStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}






@end







