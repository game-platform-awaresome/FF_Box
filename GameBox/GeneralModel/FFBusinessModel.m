//
//  FFBusinessModel.m
//  GameBox
//
//  Created by 燚 on 2018/6/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessModel.h"
#import "FFDeviceInfo.h"
#import "FFMapModel.h"
#import <UIKit/UIKit.h>

#define SS_Client [dict setObject:@"1" forKey:@"client"];


static FFBusinessUserModel *_user = NULL;
FFBusinessUserModel * currentUser(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_user) {
            _user = malloc(sizeof(FFBusinessUserModel));
        }
    });
    return _user;
}


@implementation FFBusinessModel

/** 发送验证码 */
+ (void)sendMessageWithPhoneNumber:(NSString *)number type:(FFSendMessageType)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"mobile",@"type",@"client"]));
    SS_DICT;
    [dict setObject:number forKey:@"mobile"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    SS_Client;
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_SENDMSG Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 注册交易账号 */
+ (void)registAccountWithPhoneNumber:(NSString *)number Code:(NSString *)code Password:(NSString *)password Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"code",@"mobile",@"password",@"system",
                   @"maker",@"mobile_model",@"machine_code",
                   @"system_version",@"client"]));
    SS_DICT;
    [dict setObject:number forKey:@"mobile"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:password forKey:@"password"];
    SS_SYSTEM;
    [dict setObject:@"Apple" forKey:@"maker"];
    [dict setObject:[FFDeviceInfo phoneType] forKey:@"mobile_model"];
    [dict setObject:[FFDeviceInfo deviceID] forKey:@"machine_code"];
    [dict setObject:[FFDeviceInfo systemVersion] forKey:@"system_version"];
    SS_Client;
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_REGISTER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 登录交易账号 */
+ (void)loginAccountWithUserName:(NSString *)userName Password:(NSString *)password Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"username",@"password",@"system",
                   @"machine_code",@"client"]));
    SS_DICT;
    [dict setObject:userName forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    SS_SYSTEM;
    [dict setObject:[FFDeviceInfo deviceID] forKey:@"machine_code"];
    SS_Client;
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_LOGIN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 修改交易账号密码 */
+ (void)modifyPasswordWithPassword:(NSString *)password NewPassword:(NSString *)newPassword Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"password",@"newpassword"]));
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:newPassword forKey:@"newpassword"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_MODIFYPWD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 找回密码 */
+ (void)recoverPasswordWithPhoneNumber:(NSString *)number Code:(NSString *)code NewPassword:(NSString *)newPassword Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"mobile",@"code",@"password"]));
    SS_DICT;
    [dict setObject:number forKey:@"mobile"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:newPassword forKey:@"password"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_FORGETPWD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 账号资料 */
+ (void)getUserInfoWithCompletion:(RequestCallBackBlock)completion {
    if (currentUser() -> uid == NULL) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_USERINFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 编辑账号资料 */
+ (void)editUserInfoWithQQ:(NSString *)qq AlipayAccount:(NSString *)alipayAccount Icon:(id)icon Completion:(RequestCallBackBlock)completion {
    if (currentUser() -> uid == NULL) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    NSMutableArray *pamarasKey = [NSMutableArray array];
    [pamarasKey addObject:@"uid"];
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    if (qq) {
        [pamarasKey addObject:@"qq"];
        [dict setObject:qq forKey:@"qq"];
    } else {

    }
    if (alipayAccount) {
        [pamarasKey addObject:@"alipay_account"];
        [dict setObject:alipayAccount forKey:@"alipay_account"];
    }
    SS_SIGN;
    if (icon) {
        [FFNetWorkManager uploadImageWithURL:Map.BSP_EDITUSER Params:dict FileData:@[UIImagePNGRepresentation(icon)] FileName:@"userAvatar" Name:@"img" MimeType:@"image/png" Progress:nil Success:^(NSDictionary * _Nonnull content) {
            REQUEST_STATUS;
            if (status.integerValue == 1) {
                if (completion){
                    completion(content,true);
                }
            } else {
                if (completion){
                    completion(@{@"status":content[@"status"],@"msg":content[@"msg"]},false);
                }
            }
        } Failure:^(NSError * _Nonnull error) {
            if (completion) {
                completion(@{@"msdg" : error.localizedDescription}, NO);
            }
        }];
    } else {
        [FFNetWorkManager postRequestWithURL:Map.BSP_EDITUSER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            NEW_REQUEST_COMPLETION
        }];
    }
}

/** 验证用户信息完整 */
+ (void)verifyUserInfoWithCompletion:(RequestCallBackBlock)completion {
    if (currentUser() -> uid == NULL) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }

    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_COMPLETEINFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关联 SDK 账号 */
+ (void)linkSDKAccountWithSDKAccount:(NSString *)sdkAccount SDKPassword:(NSString *)adkPassword Completion:(RequestCallBackBlock)completion {
    if (currentUser() -> uid == NULL) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }

    Pamaras_Key((@[@"uid",@"sdk_username",@"sdk_password"]));
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    [dict setObject:sdkAccount forKey:@"sdk_username"];
    [dict setObject:adkPassword forKey:@"sdk_password"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BIND_SDKUSER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 取消关联 SDK 账号 */
+ (void)cancelLinkSDKAccountWithSDKAccount:(NSString *)sdkAccount Completion:(RequestCallBackBlock)completion {
    if (currentUser() -> uid == NULL) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid",@"sdk_username"]));
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    [dict setObject:sdkAccount forKey:@"sdk_username"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.UNBIND_SDKUSER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关联 SDK 账号列表 */
+ (void)linkSDKAccountListCompletion:(RequestCallBackBlock)completion {
    if (currentUser() -> uid == NULL) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:[NSString stringWithUTF8String:currentUser() -> uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.SDKUSER_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}



@end











