//
//  FFDriveModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveModel.h"
#import "FFMapModel.h"
#import "SYKeychain.h"
#import "AFHTTPSessionManager.h"
#import "FFDriveUserModel.h"

#import "UIImage+GIF.h"
#import <Photos/Photos.h>
#import "FFDeviceInfo.h"

@implementation UIImage (ZipSizeAndLength)
- (UIImage *)compressToByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;

    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;

        CGSize size = CGSizeMake(200, 200);
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}
- (UIImage *)zipSize{
    if (self.size.width < 200) {
        return self;
    }
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}

- (UIImage *)zip{
    UIImage *image = [self compressToByte:2*1024*1024];
    return  [image zipSize];
}

@end

@implementation FFDriveModel

/** 发状态 */
+ (void)postDynamicWith:(NSString *)content Images:(NSArray *)imgs Complete:(FFCompleteBlock)completion {

    if ((content == nil || content.length == 0) && (imgs.count == 0)) {
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self userModel].uid forKey:@"uid"];
    [dict setObject:content forKey:@"content"];
    NSLog(@"dict == %@",dict);

    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"content"])) forKey:@"sign"];

    if (imgs.count > 0) {
        [dict setObject:imgs forKey:@"imgs"];
    }

    [FFNetWorkManager postRequestWithURL:Map.PUBLISH_DYNAMICS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


#pragma mark - ======================= 上传头像 =======================
/** 发动态 */
+ (void)userUploadPortraitWithContent:(NSString *)content
                                Image:(NSArray<UIImage *> *)images
                           Completion:(FFCompleteBlock)completion
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的

    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setStringEncoding:NSUTF8StringEncoding];
    manager.requestSerializer = serializer;

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
//                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
//                                                         @"application/octet-stream",
//                                                         @"text/json",
//                                                         @"text/txt",
                                                         @"image/gif",
                                                         nil];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:content forKey:@"content"];
//    NSLog(@"dict == %@",dict);
    [dict setObject:BOX_SIGN(dict, (@[@"uid",@"content"])) forKey:@"sign"];


    NSURLSessionDataTask *task = [manager POST:[FFMapModel map].PUBLISH_DYNAMICS parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

        //上传的多张照片
        for (int i = 0; i < images.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName;

            id image = images[i];

            if ([image isKindOfClass:[PHAsset class]]) {
                fileName = [NSString stringWithFormat:@"%@.gif", str];
//                NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];

                PHImageRequestOptions *options = [PHImageRequestOptions new];
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                options.synchronous = YES;

                [[PHImageManager defaultManager] requestImageDataForAsset:image options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

                    if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                        syLog(@"gif  %@ \n image data === %@",info,imageData);
                        syLog(@"image size == %.2lf M ",imageData.length / 1024.0 / 1024.0);
                        [formData appendPartWithFileData:imageData name:@"imgs[]" fileName:fileName mimeType:@""];
                    }
                }];


            } else {
                fileName = [NSString stringWithFormat:@"%@.png", str];
                UIImage *image = images[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
                syLog(@"image size == %.2lf M ",imageData.length / 1024.0 / 1024.0);
                [formData appendPartWithFileData:imageData name:@"imgs[]" fileName:fileName mimeType:@""];
            }
        }


    } progress:^(NSProgress *_Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        syLog(@"发送成功  ????????");
        if (completion) {
            completion(responseObject, YES);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        syLog(@"发送失败  ?????????");
        if (completion) {
            completion(@{@"msg":[NSString stringWithFormat:@"error : %@",error.localizedDescription]}, NO);
        }
    }];

    [task resume];

}

+ (void)userDeletePortraitWithDynamicsID:(NSString *)dynamicsID Completion:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (SSKEYCHAIN_UID) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        return;
    }
    [dict setObject:dynamicsID forKey:@"id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"id"]))) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.DEL_DYNAMIC Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** get dynamic */
+ (void)getDynamicWithType:(DynamicType)type Page:(NSString *)page CheckUid:(NSString *)buid Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (SSKEYCHAIN_UID) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    }
    if (type == CheckUserDynamic && buid) {
        [dict setObject:buid forKey:@"buid"];
    }
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"type",@"page"]))) forKey:@"sign"];


    [FFNetWorkManager postRequestWithURL:Map.GET_DYNAMICS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** like or dislike */
+ (void)userLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id type:(LikeOrDislike)type Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        if (completion) {
            completion(@{@"status":@"没有登录"},NO);
        }
        return;
    }
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:dynamics_id forKey:@"dynamics_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type"]))) forKey:@"sign"];


    syLog(@"send like or dis like === %@",dict);

    [FFNetWorkManager postRequestWithURL:Map.DYNAMICS_LIKE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)userCancelLikeOrDislikeWithDynamicsID:(NSString *)dynamics_id type:(LikeOrDislike)type Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        if (completion) {
            completion(@{@"status":@"没有登录"},NO);
        }
        return;
    }

    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:dynamics_id forKey:@"dynamics_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type"]))) forKey:@"sign"];

    syLog(@"send cancel like=== %@",dict);
    [FFNetWorkManager postRequestWithURL:Map.CANCEL_DYNAMICS_LIKE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}



/** comment  */
+ (void)userComeentListWithDynamicsID:(NSString *)dynamicsID type:(CommentType)type page:(NSString *)page Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID != nil && SSKEYCHAIN_UID.length != 0) {
        [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    } else {
        [dict setObject:@"0" forKey:@"uid"];
    }
    syLog(@"comment uid === %@",dict);
    [dict setObject:Channel forKey:@"channel"];
    if (dynamicsID == nil) {
        return;
    }
    [dict setObject:dynamicsID forKey:@"dynamics_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(NSUInteger)type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"dynamics_id",@"type",@"page"]))) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.COMMENT_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** 发布评论 */
+ (void)userSendCommentWithjDynamicsID:(NSString *)dynamicsID ToUid:(NSString *)toUid Comment:(NSString *)comment Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];

    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    (toUid != nil) ? [dict setObject:toUid forKey:@"to_uid"] : [dict setObject:@"0" forKey:@"to_uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:dynamicsID forKey:@"dynamics_id"];
    [dict setObject:comment forKey:@"content"];

    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"to_uid",@"channel",@"dynamics_id",@"content"]))) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.COMMENT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 赞或者踩评论 */
+ (void)userLikeOrDislikeComment:(NSString *)comment_id Type:(LikeOrDislike)type Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:comment_id forKey:@"comment_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];

    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id",@"type"]))) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.COMMENT_LIKE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** 取消评论的赞 */
+ (void)userCancelLikeOrDislikeComment:(NSString *)comment_id Type:(LikeOrDislike)type Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:comment_id forKey:@"comment_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id",@"type"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.CANCEL_COMMENT_LIKE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 删除评论 */
+ (void)userDeleteCommentWith:(NSString *)comment_id Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:comment_id forKey:@"comment_id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"comment_id"]))) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.COMMENT_DEL Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关注用户 */
+ (void)userAttentionWith:(NSString *)attentionUid Type:(AttentionType)type Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:attentionUid forKey:@"buid"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"buid",@"type"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.FOLLOW_OR_CANCEL Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 分享 */
+ (void)userSharedDynamics:(NSString *)Dynamics Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:Dynamics forKey:@"id"];
    [dict setObject:(BOX_SIGN(dict, (@[@"id"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.SHARE_DYNAMICS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关注 / 粉丝 */
+ (void)userFansAndAttettionWithUid:(NSString *)uid Page:(NSString *)page Type:(FansOrAttention)type Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:uid forKey:@"uid"];
    NSString *vis;
    if (SSKEYCHAIN_UID == nil) {
        vis = @"0";
    } else {
        vis = SSKEYCHAIN_UID;
    }
    [dict setObject:vis forKey:@"visit_uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"visit_uid",@"channel",@"type",@"page"]))) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.FOLLOW_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}

/** 查询用户信息 */
+ (void)userInfomationWithUid:(NSString *)uid fieldType:(FieldType)type Complete:(FFCompleteBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:SSKEYCHAIN_UID forKey:@"visit_uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"field_type"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"visit_uid",@"channel",@"field_type"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.USER_DESC Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 编辑信息 */
+ (void)userEditInfoMationWithNickName:(NSString *)nick_name
                                   sex:(NSString *)sex
                               address:(NSString *)address
                                  desc:(NSString *)desc
                                 birth:(NSString *)birth
                                    qq:(NSString *)qq
                                 email:(NSString *)email
                              Complete:(FFCompleteBlock)completion
{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];

    if (!nick_name) {
        nick_name = @"";
    }
    [dict setObject:nick_name forKey:@"nick_name"];

    if (!sex) {
        sex = @"";
    }
    [dict setObject:sex forKey:@"sex"];

    if (!address) {
        address = @"";
    }
    [dict setObject:address forKey:@"address"];

    if (!desc) {
        desc = @"";
    }
    [dict setObject:desc forKey:@"desc"];

    if (!birth) {
        birth = @"";
    }
    [dict setObject:birth forKey:@"birth"];

    if (!qq) {
        qq = @"";
    }
    [dict setObject:qq forKey:@"qq"];

    if (!email) {
        email = @"";
    }
    [dict setObject:email forKey:@"email"];

    NSArray *para = @[@"uid",@"channel",@"nick_name",@"sex",@"address",@"desc",@"birth",@"qq",@"email"];
    [dict setObject:(BOX_SIGN(dict, para)) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.USER_EDIT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)userEditInfoMationWIthDict:(NSDictionary *)dict Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *redict = [@{@"uid":SSKEYCHAIN_UID,
                                     @"channel":Channel,
                                     @"nick_name":@"",
                                     @"sex":@"",
                                     @"address":@"",
                                     @"desc":@"",
                                     @"birth":@"",
                                     @"qq":@"",
                                     @"email":@""
                                   } mutableCopy];

    NSArray *allKeys = dict.allKeys;
    [allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [redict setObject:dict[obj] forKey:obj];
    }];

    NSArray *para = @[@"uid",@"channel",@"nick_name",@"sex",@"address",@"desc",@"birth",@"qq",@"email"];
    [redict setObject:(BOX_SIGN(redict, para)) forKey:@"sign"];

    [FFNetWorkManager postRequestWithURL:Map.USER_EDIT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


+ (FFDriveUserModel *)userModel {
    return [FFDriveUserModel sharedModel];
}



+ (void)myNewNumbersComplete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    if (SSKEYCHAIN_UID == nil || SSKEYCHAIN_UID.length < 1) {
        if (completion) {
            completion(nil,NO);
        }
        return;
    }
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.USER_NEW_UP Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)myNewsWithType:(MyNewsType)type page:(NSString *)page Complete:(FFCompleteBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if (SSKEYCHAIN_UID == nil || SSKEYCHAIN_UID.length < 1) {
        if (completion) {
            completion(nil,NO);
        }
        return;
    }
    [dict setObject:SSKEYCHAIN_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel",@"type",@"page"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.USER_COMMENT_ZAN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


//压缩图片
+ (NSData *)zipGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval duration = 0.0f;
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        duration += [self sd_frameDurationAtIndex:i source:source];
        UIImage *ima = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        ima = [ima zip];
        [images addObject:ima];
        CGImageRelease(image);
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return UIImagePNGRepresentation(animatedImage);
}



//+ (UIImage *)sd_animatedGIFWithData:(NSData *)data {
//    if (!data) {
//        return nil;
//    }
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
//    size_t count = CGImageSourceGetCount(source);
//    UIImage *staticImage;
//
//    if (count <= 1) {
//        staticImage = [[UIImage alloc] initWithData:data];
//    } else {
//        CGFloat scale = 1;
//        scale = [UIScreen mainScreen].scale;
//
//        CGImageRef CGImage = CGImageSourceCreateImageAtIndex(source, 0, NULL);
//#if SD_UIKIT || SD_WATCH
//        UIImage *frameImage = [UIImage imageWithCGImage:CGImage scale:scale orientation:UIImageOrientationUp];
//        staticImage = [UIImage animatedImageWithImages:@[frameImage] duration:0.0f];
//#endif
//        CGImageRelease(CGImage);
//    }
//
//    CFRelease(source);
//
//    return staticImage;
//}


+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {

        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }

    CFRelease(cfFrameProperties);
    return frameDuration;
}



@end



