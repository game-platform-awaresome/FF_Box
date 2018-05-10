//
//  FFUserModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFUserModel.h"
#import "FFDeviceInfo.h"
#import "FFMapModel.h"

#define FF_UID [FFUserModel currentUser].uid

@interface FFUserModel ()



@end

static FFUserModel *model;

@implementation FFUserModel

+ (FFUserModel *)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFUserModel alloc] init];
        }
    });
    return model;
}

#pragma mark - ================================ 注册和登录 ================================
+ (void)userLoginWithUsername:(NSString *)username Password:(NSString *)password Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"username",@"password",@"channel",@"system",@"machine_code"]));
    Mutable_Dict(pamarasKey.count + 1);
    [dict setObject:username forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    SS_CHANNEL;
    SS_SYSTEM;
    SS_DEVICEID;
    SS_SIGN;

    [FFNetWorkManager postRequestWithURL:Map.USER_LOGIN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        //回调
        NEW_REQUEST_COMPLETION;
#warning login statistics
    }];
}

+ (void)userRegisterWithUserName:(NSString *)userName Code:(NSString *)code PhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)passWord Type:(NSString *)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"username",@"code",@"mobile",@"password",
                   @"channel",@"system",@"maker",@"mobile_model",
                   @"machine_code",@"system_version",@"type"]));
    Mutable_Dict(pamarasKey.count + 1);

    [dict setObject:userName forKey:@"username"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:passWord forKey:@"password"];
    SS_CHANNEL;
    SS_SYSTEM;
    [dict setObject:@"Apple" forKey:@"maker"];
    [dict setObject:[FFDeviceInfo phoneType] forKey:@"mobile_model"];
    SS_DEVICEID;
    [dict setObject:[FFDeviceInfo systemVersion] forKey:@"system_version"];
    [dict setObject:type forKey:@"type"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_REGISTER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
#warning regist statistics
    }];
}

+ (void)userModifyPasswordOldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"id",@"password",@"newpassword"]));
    Mutable_Dict(pamarasKey.count + 1);
    [dict setObject:[FFUserModel currentUser].uid forKey:@"id"];
    [dict setObject:oldPassword forKey:@"password"];
    [dict setObject:newPassword forKey:@"newpassword"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_MODIFYPWD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ================================ 绑定手机 ================================
+ (void)userBindingPhoneNumber:(NSString *)phoneNumber Code:(NSString *)code Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"mobile",@"appid",@"code"]));
    SS_DICT;

    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:AppID forKey:@"appid"];
    [dict setObject:code forKey:@"code"];
    SS_SIGN;

    [FFNetWorkManager postRequestWithURL:Map.USER_BIND_MOBILE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

+ (void)userUnbindingPhoneNumber:(NSString *)phoneNumber Code:(NSString *)code Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"mobile",@"appid",@"code"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:AppID forKey:@"appid"];
    [dict setObject:code forKey:@"code"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_UNBIND_MOBILE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}




@end
