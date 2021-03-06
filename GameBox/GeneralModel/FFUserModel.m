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
#import "SYKeychain.h"
#import <UIKit/UIKit.h>
#import "FFStatisticsModel.h"

#define FF_UID [FFUserModel currentUser].uid

#define IS_LOGIN    if (FF_UID == nil || [FF_UID isEqualToString:@"0"]) {\
                        return NO;\
                    }

#define KEYCHAINSERVICE @"tenoneTec.com"
#define DEVICEID @"CurrentUid"

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

#pragma mark - class method
+ (BOOL)setUID:(NSString *)uid {
    return [SYKeychain setPassword:uid forService:KEYCHAINSERVICE account:DEVICEID];
}
+ (NSString *)uid {
    return SSKEYCHAIN_UID;
}
+ (BOOL)deleteUID {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:DEVICEID];
}

+ (NSString *)UserName {
    return [SYKeychain passwordForService:KEYCHAINSERVICE account:USER_NAME];
}
+ (BOOL)setUserName:(NSString *)userName {
    return [SYKeychain setPassword:userName forService:KEYCHAINSERVICE account:USER_NAME];
}
+ (BOOL)deleteUserName {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:USER_NAME];
}


+ (BOOL)setPassWord:(NSString *)passWord {
    return [SYKeychain setPassword:passWord forService:KEYCHAINSERVICE account:USER_PASSWORDK];
}
+ (NSString *)passWord {
    return [SYKeychain passwordForService:KEYCHAINSERVICE account:USER_PASSWORDK];
}
+ (BOOL)deletePassWord {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:USER_PASSWORDK];
}

+ (void)signOut {
//    NSArray *keys = OBJECT_FOR_USERDEFAULTS(USER_INFO_KEYS);
//    //移除 keychain 中的数据
//    [keys enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
//        [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:key];
//    }];


    //移除 UID
    [FFUserModel deleteUID];
    //移除 userName
    [FFUserModel deleteUserName];
    //清空密码
    [FFUserModel deletePassWord];

    //移除所有 key
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_INFO_KEYS];

    //清空 usermodel
    [model setAllPropertyWithDict:nil];

    //删除头像
//    [[NSFileManager defaultManager] removeItemAtPath:[FFUserModel avatarDataPath] error:nil];
    [FFUserModel currentUser].isLogin = NO;
}

#pragma mark - getter
- (NSString *)username {
    if (!_username) {
        _username = @"";
    }
    return _username;
}

- (NSString *)uid {
    if (!_uid) {
        _uid = @"0";
    }
    return _uid;
}

- (NSString *)platform_money {
    if (!_platform_money) {
        _platform_money = @"0";
    }
    return _platform_money;
}

- (NSString *)coin {
    if (!_coin) {
        _coin = @"0";
    }
    return _coin;
}

- (NSString *)recom_bonus {
    if (!_recom_bonus) {
        _recom_bonus = @"0";
    }
    return _recom_bonus;
}


- (BOOL)isLogin {
    return (![self.uid isEqualToString:@"0"]);
}

#pragma mark - ================================ 注册和登录 ================================
/** 登录 */
+ (void)userLoginWithUsername:(NSString *)username Password:(NSString *)password Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"username",@"password",@"channel",@"system",@"machine_code"]));
    Mutable_Dict(pamarasKey.count + 1);
    [dict setObject:username forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:[FFDeviceInfo cheackChannel] forKey:@"random"];
    SS_CHANNEL;
    SS_SYSTEM;
    SS_DEVICEID;
    SS_SIGN;

    [FFNetWorkManager postRequestWithURL:Map.USER_LOGIN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        //回调
        NEW_REQUEST_COMPLETION;

        syLog(@"login content == %@",content);
        if (success && (status.integerValue == 1)) {
            NSDictionary *dict = CONTENT_DATA;
            //设置用户模型
            [[FFUserModel currentUser] setAllPropertyWithDict:dict];
            //保存 UID
            [FFUserModel setUID:[FFUserModel currentUser].uid];
            [FFUserModel setUserName:[FFUserModel currentUser].username];
            [FFUserModel setPassWord:password];
            
            BoxstatisticsLogin([FFUserModel currentUser].username);
        }
    }];
}

/** 注册 */
+ (void)userRegisterWithUserName:(NSString *)userName Code:(NSString *)code PhoneNumber:(NSString *)phoneNumber PassWord:(NSString *)passWord Type:(NSString *)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"username",@"code",@"mobile",@"password",
                   @"channel",@"system",@"maker",@"mobile_model",
                   @"machine_code",@"system_version",@"type"]));
    Mutable_Dict(pamarasKey.count + 1);

    [dict setObject:userName forKey:@"username"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:passWord forKey:@"password"];
    [dict setObject:[FFDeviceInfo cheackChannel] forKey:@"random"];
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
        BoxstatisticsRegistered(userName);
    }];
}

/** 修改密码 */
+ (void)userModifyPasswordOldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"id",@"password",@"newpassword"]));
    Mutable_Dict(pamarasKey.count + 1);
    [dict setObject:FF_UID forKey:@"id"];
    [dict setObject:oldPassword forKey:@"password"];
    [dict setObject:newPassword forKey:@"newpassword"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_MODIFYPWD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma makr - ================================ 签到 ================================
/** 签到初始化 */
+ (BOOL)signInitWithCompletion:(RequestCallBackBlock)completion {
    if (FF_UID == nil || FF_UID.length < 1) {
        return NO;
    }
    Pamaras_Key((@[@"uid",@"channel"]));
    Mutable_Dict(pamarasKey.count + 1);
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.SIGN_INIT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 签到 */
+ (BOOL)doSignWithCompletion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"channel"]));
    Mutable_Dict(pamarasKey.count + 1);
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.DO_SIGN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

#pragma mark - ================================ 绑定手机 ================================
/** 绑定手机 */
+ (BOOL)userBindingPhoneNumber:(NSString *)phoneNumber Code:(NSString *)code Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
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
    return YES;
}

/** 解绑手机 */ 
+ (BOOL)userUnbindingPhoneNumber:(NSString *)phoneNumber Code:(NSString *)code Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
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
    return YES;
}

#pragma mark - ======================= 获取 vip 选项 =======================
+ (void)vipGetOptionWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    [FFNetWorkManager postRequestWithURL:Map.VIP_OPTION Params:nil Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 邀请好友 =======================
+ (BOOL)inviteFriendWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.FRIEND_RECOM_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

#pragma mark - ======================= 客服中心 =======================
+ (void)customerServiceWithCompletion:(void (^)(NSDictionary *, BOOL))completion {
    Mutable_Dict(2);
    SS_CHANNEL;
    [dict setObject:BOX_SIGN(dict, (@[@"channel"])) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.CUSTOMER_SERVICE Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 我的收藏 =======================
+ (BOOL)myCollectionGameWithPage:(NSString *)page Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    IS_LOGIN;
    Mutable_dict;
    SS_SYSTEM;
    [dict setObject:[FFUserModel currentUser].username forKey:@"username"];
    [dict setObject:page forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_MY_COLLECT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
    return YES;
}


#pragma mark - ======================= 找回密码 =======================
/** 获取手机验证码 */
+ (void)userSendMessageWithPhoneNumber:(NSString *)phoneNumber Type:(NSString *)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"mobile",@"type"]));
    SS_DICT;
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:type forKey:@"type"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_SENDMSG Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}
/** 检验验证码 */
+ (void)userCheckMessageWithPhoneNumber:(NSString *)phoneNumber MessageCode:(NSString *)messageCode Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"mobile",@"code"]));
    SS_DICT;
    [dict setObject:phoneNumber forKey:@"mobile"];
    [dict setObject:messageCode forKey:@"code"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_CHECKMSG Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 重置密码 */
+ (void)userForgetPasswordWithUserID:(NSString *)userID Password:(NSString *)password RePassword:(NSString *)rePassword Token:(NSString *)token Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"id",@"password",@"token"]));
    SS_DICT;
    [dict setObject:userID forKey:@"id"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:token forKey:@"token"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_FINDPWD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - ======================= 修改昵称 =======================
/** 修改昵称 */
+ (BOOL)userModifyNicknameWithUserID:(NSString *)userID NickName:(NSString *)nickName Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"id",@"nick_name"]));
    SS_DICT;
    [dict setObject:userID forKey:@"id"];
    [dict setObject:nickName forKey:@"nick_name"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_MODIFYNN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

#pragma mark - ======================= 上传头像 =======================
/** 上传头像 */
+ (BOOL)userUploadPortraitWithImage:(id)image Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    [FFNetWorkManager uploadImageWithURL:Map.USER_UPLOAD Params:@{@"id":FF_UID} FileData:@[UIImagePNGRepresentation(image)] FileName:@"userAvatar.png" Name:@"img" MimeType:@"" Progress:nil Success:^(NSDictionary * _Nonnull content) {
        if (completion) {
            completion(content, YES);
        }
    } Failure:^(NSError * _Nonnull error) {
        if (completion) {
            completion(@{@"msg" : error.localizedDescription}, NO);
        }
    }];
    return YES;
}

#pragma mark - ======================= 用户币 =======================
/** 用户的各种币 */
+ (BOOL)userCoinWithCompletion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.USER_CENTER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 金币中心 */
+ (BOOL)coinCenterWithCompletion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.MY_COIN Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 金币明细 */
+ (BOOL)coinDetailWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel",@"page"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.COIN_LOG Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 兑换平台币信息 */
+ (BOOL)coinExchangeInfoCompletion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.COIN_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 兑换平台币 */
+ (BOOL)coinExchangePlatformCounts:(NSString *)platform_counts Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel",@"platform_counts"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:platform_counts forKey:@"platform_counts"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.PLAT_EXCHANGE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 平台币明细 */
+ (BOOL)coinPlatformDetailWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel",@"page"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.PLAT_LOG Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 我的奖品 */
+ (BOOL)myPrizeCompletion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.MY_PRIZE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

#pragma mark - ======================= 申请转游 =======================
/** 申请转游戏 */
+ (BOOL)transferGameApplyWithOriginAppName:(NSString *)origin_appname OriginServerName:(NSString *)origin_servername OriginRoleName:(NSString *)origin_rolename NewAppName:(NSString *)new_appname NewServerName:(NSString *)new_servername NewRoleName:(NSString *)new_rolename QQNumber:(NSString *)qq Mobile:(NSString *)mobile Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel",@"origin_appname",
                   @"origin_servername",@"origin_rolename",@"new_appname",
                   @"new_servername",@"new_rolename",@"qq",
                   @"mobile"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:origin_appname forKey:@"origin_appname"];
    [dict setObject:origin_servername forKey:@"origin_servername"];
    [dict setObject:origin_rolename forKey:@"origin_rolename"];
    [dict setObject:new_appname forKey:@"new_appname"];
    [dict setObject:new_servername forKey:@"new_servername"];
    [dict setObject:new_rolename forKey:@"new_rolename"];
    [dict setObject:qq forKey:@"qq"];
    [dict setObject:mobile forKey:@"mobile"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.CHANGEGAME_APPLY Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 转游戏记录 */
+ (BOOL)transferGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    IS_LOGIN;
    Pamaras_Key((@[@"uid",@"channel",@"page"]));
    SS_DICT;
    [dict setObject:FF_UID forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:page forKey:@"page"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.CHANGEGAME_LOG Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
    return YES;
}

/** 转游须知 */
+ (void)transferGameoticeCompletion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"channel"]));
    SS_DICT;
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.CHANGEGAME_NOTICE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}




@end











