//
//  FFNetWorkManager.h
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//


#import <Foundation/Foundation.h>


#define REQUEST_STATUS NSString *status = content[@"status"]
#define CONTENT_DATA ((content[@"data"]) ? (content[@"data"]) : content)

#define Mutable_Dict(integer) NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:integer]
#define Mutable_dict NSMutableDictionary *dict = [NSMutableDictionary dictionary]
#define Pamaras_Key(key) NSArray *pamarasKey = key
#define SS_DICT Mutable_Dict(pamarasKey.count + 1)


#define REQUEST_COMPLETION \
REQUEST_STATUS;\
if (success) {\
if (status.integerValue == 0) {\
if (completion) {\
completion(content, YES);\
}\
} else {\
if (completion) {\
completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);\
}\
}\
} else {\
if (completion) {\
completion(@{@"status":@"404",@"msg":@"请求超时"},false);\
}\
}

#define NEW_REQUEST_COMPLETION \
REQUEST_STATUS;\
if (success) {\
if (status.integerValue == 1) {\
if (completion){\
completion(content,true);\
}\
} else {\
if (completion){\
completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);\
}\
}\
} else {\
if (completion){\
completion(@{@"status":@"404",@"msg":@"请求超时"},false);\
}\
}

typedef void(^RequestCallBackBlock)(NSDictionary * _Nonnull content, BOOL success);
typedef void(^SuccessBlock)(NSDictionary * _Nonnull content);
typedef void(^FailureBlock)(NSError * _Nonnull error);
typedef void(^UploadProgressBlock)(NSProgress * _Nonnull progress);


typedef NS_ENUM(NSInteger, FFNetworkReachabilityStatus) {
    FFNetworkReachabilityStatusUnknown          = -1,
    FFNetworkReachabilityStatusNotReachable     = 0,
    FFNetworkReachabilityStatusReachableViaWWAN = 1,
    FFNetworkReachabilityStatusReachableViaWiFi = 2,
};


@interface FFNetWorkManager : NSObject

/** post */
+ (void)postRequestWithURL:(NSString * _Nonnull)url
                    Params:(NSDictionary * _Nullable)params
                Completion:(RequestCallBackBlock _Nullable)completion;

/** post */
+ (void)postRequestWithURL:(NSString * _Nonnull)url
                    Params:(NSDictionary * _Nullable)params
                   Success:(SuccessBlock _Nullable)success
                   Failure:(FailureBlock _Nullable)failure;

/** post file */
+ (void)uploadImageWithURL:(NSString * _Nonnull)url
                    Params:(NSDictionary * _Nullable)params
                  FileData:(NSArray<NSData *> *_Nullable)fileDataArray
                  FileName:(NSString * _Nonnull)fileName
                      Name:(NSString * _Nonnull)name
                  MimeType:(NSString * _Nonnull)mimeType
                  Progress:(UploadProgressBlock _Nullable)progress
                   Success:(SuccessBlock _Nullable)success
                   Failure:(FailureBlock _Nullable)failure;


/** network state */
+ (FFNetworkReachabilityStatus)netWorkState;





@end










