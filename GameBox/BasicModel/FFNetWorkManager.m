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
        syLog(@"request error : %@",error.localizedDescription);
    }];
}

+ (void)postRequestWithURL:(NSString *)url Params:(NSDictionary *)params Success:(SuccessBlock)success Failure:(FailureBlock)failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10;
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
    [self uploadImageWithURL:url Params:params FileDict:@{name:fileDataArray} FileName:fileName MimeType:mimeType Progress:progress Success:success Failure:failure];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //接收类型
//    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
//    [serializer setStringEncoding:NSUTF8StringEncoding];
//    manager.requestSerializer = serializer;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
//                                                         @"application/json",
//                                                         @"image/jpeg",
//                                                         @"image/png",
//                                                         nil];
//
//    NSURLSessionDataTask *task = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (NSData *data in fileDataArray) {
//            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        if (progress) {
//            progress(uploadProgress);
//        }
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//
//    [task resume];
}

+ (void)uploadImageWithURL:(NSString *)url Params:(NSDictionary *)params FileDict:(NSDictionary<NSString *,NSArray<NSData *> *> *)fileDict FileName:(NSString *)fileName MimeType:(NSString *)mimeType Progress:(UploadProgressBlock)progress Success:(SuccessBlock)success Failure:(FailureBlock)failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    manager.requestSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         nil];

    NSURLSessionDataTask *task = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSArray *allkeys = [fileDict allKeys];
        for (NSString *key in allkeys) {

            NSArray<NSData *> *fileDataArray = [fileDict objectForKey:key];

            for (NSData *data in fileDataArray) {
                syLog(@"key === %@",key);
                [formData appendPartWithFileData:data name:key fileName:fileName mimeType:mimeType];
            }
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

/*
+ (void)postRequestWithURL:(NSString *)url
                    params:(NSDictionary *)dicP
                completion:(void(^)(NSDictionary * content,BOOL success))completion {

    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if (dicP && dicP.count) {
        NSArray *arrKey = [dicP allKeys];
        NSMutableArray *pValues = [NSMutableArray array];
        for (id key in arrKey) {
            [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,dicP[key]]];
        }
        NSString *strP = [pValues componentsJoinedByString:@"&"];
        [request setHTTPBody:[strP dataUsingEncoding:NSUTF8StringEncoding]];
    }

    request.timeoutInterval = 5.f;

    [request setHTTPMethod:@"POST"];

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {

            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            syLog(@"%@",obj);
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil,false);
                    }
                });
                syLog(@"NSJSONSerialization error");

            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion((NSDictionary *)obj,true);
                        }
                    });
                }
            }
        } else {
            syLog(@"Request Failed...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,false);
                }
            });
        }
    }];
    [task resume];
}
*/




@end







