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
#import "SYKeychain.h"

#define SS_Client [dict setObject:@"1" forKey:@"client"];

#define KEYCHAINSERVICE @"tenoneTec.com"
#define Business_uid @"Business_uid"
#define Business_username @"Business_username"
#define Business_password @"Business_password"

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

+ (FFBusinessUserModel *)sharedModel {
    currentUser() -> uid = [self uid] ? [[self uid] UTF8String] : NULL;
    return currentUser();
}


+ (NSString *)uid {
    return [SYKeychain passwordForService:KEYCHAINSERVICE account:Business_uid];
}
+ (BOOL)setUid:(NSString *)uid {
    return [SYKeychain setPassword:uid forService:KEYCHAINSERVICE account:Business_uid];
}
+ (BOOL)deleteUid {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:Business_uid];
}
+ (NSString *)username {
    return [SYKeychain passwordForService:KEYCHAINSERVICE account:Business_username];
}
+ (BOOL)setUsername:(NSString *)username {
    return [SYKeychain setPassword:username forService:KEYCHAINSERVICE account:Business_username];
}
+ (BOOL)deleteUsername {
    return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:Business_username];
}
+ (NSString *)password {
    return [SYKeychain passwordForService:KEYCHAINSERVICE account:Business_password];
}
+ (BOOL)setPassword:(NSString *)password {
    return [SYKeychain setPassword:password forService:KEYCHAINSERVICE account:Business_password];
}
+ (BOOL)deletePassword {
        return [SYKeychain deletePasswordForService:KEYCHAINSERVICE account:Business_password];
}

+ (BOOL)signOut {
    [self deleteUid];
    [self deleteUsername];
    [self deletePassword];
    return YES;
}

+ (void)loginSuccessWith:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        syLog(@"login dict === %@",dict);
        NSString *uid = dict[@"uid"];
        [self setUid:uid];
    }
}

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
    [dict setObject:[self uid] forKey:@"uid"];
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
    if (![self uid]) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_USERINFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 编辑账号资料 */
+ (void)editUserInfoWithQQ:(NSString *)qq AlipayAccount:(NSString *)alipayAccount Icon:(id)icon Name:(NSString *)name Completion:(RequestCallBackBlock)completion {
    if (![self uid]) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    NSMutableArray *pamarasKey = [NSMutableArray array];
    [pamarasKey addObject:@"uid"];
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    if (qq) {
        [pamarasKey addObject:@"qq"];
        [dict setObject:qq forKey:@"qq"];
    } else {
        [pamarasKey addObject:@"qq"];
        [dict setObject:@"" forKey:@"qq"];
    }

    [dict setObject:name forKey:@"real_name"];

    if (alipayAccount) {
        [pamarasKey addObject:@"alipay_account"];
        [dict setObject:alipayAccount forKey:@"alipay_account"];
    } else {
        [pamarasKey addObject:@"alipay_account"];
        [dict setObject:@"" forKey:@"alipay_account"];
    }

    SS_SIGN;

    if (icon) {
        [FFNetWorkManager uploadImageWithURL:Map.BSP_EDITUSER Params:dict FileData:@[UIImagePNGRepresentation(icon)] FileName:@"userAvatar" Name:@"icon_url" MimeType:@"image/png" Progress:nil Success:^(NSDictionary * _Nonnull content) {
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
    if ([self uid] == nil) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }

    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BSP_COMPLETEINFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关联 SDK 账号 */
+ (void)linkSDKAccountWithSDKAccount:(NSString *)sdkAccount SDKPassword:(NSString *)adkPassword Completion:(RequestCallBackBlock)completion {
    if ([self uid] == nil) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid",@"sdk_username",@"sdk_password"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:sdkAccount forKey:@"sdk_username"];
    [dict setObject:adkPassword forKey:@"sdk_password"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BIND_SDKUSER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 取消关联 SDK 账号 */
+ (void)cancelLinkSDKAccountWithSDKAccount:(NSString *)sdkAccount Completion:(RequestCallBackBlock)completion {
    if ([self uid] == nil) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid",@"sdk_username"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:sdkAccount forKey:@"sdk_username"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.UNBIND_SDKUSER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 关联 SDK 账号列表 */
+ (void)linkSDKAccountListCompletion:(RequestCallBackBlock)completion {
    if ([self uid] == nil) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"uid"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.SDKUSER_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 发起支付 */
+ (void)payStartWithProductID:(NSString *)productID Uid:(NSString *)uid Type:(FFBusinessPayType)type Completion:(RequestCallBackBlock)completion {
    if ([self uid] == nil) {
        completion ? completion(@{@"msg":@"尚未登录"}, false) : 0;
        return;
    }
    Pamaras_Key((@[@"proid",@"buy_id",@"type"]));
    SS_DICT;
    [dict setObject:productID forKey:@"proid"];
    [dict setObject:[self uid] forKey:@"buy_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.START_PAYMENT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 取消支付 */
+ (void)cancelPaymentWithOrderID:(NSString *)orderID Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"id"]));
    SS_DICT;
    [dict setObject:orderID forKey:@"id"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.CANCEL_PAYMENT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 商品列表 */
+ (void)productListWithGameName:(NSString *)gameName Page:(NSString *)page System:(FFBusinessSystemType)systemType OrderType:(FFBusinessOrderType)orderType OrderMethod:(FFBusinessOrderMethod)orderMethod Completion:(RequestCallBackBlock)completion {

    Pamaras_Key((@[@"game_name",@"system",@"order",@"order_type",@"page"]));
    SS_DICT;
    gameName = gameName ?: @"0";
    [dict setObject:gameName forKey:@"game_name"];
    page = page ?: @"1";
    [dict setObject:page forKey:@"page"];
    systemType = systemType ?: 0;
    [dict setObject:[NSString stringWithFormat:@"%lu",systemType] forKey:@"system"];
    orderType = orderType ?: 0;
    [dict setObject:[NSString stringWithFormat:@"%lu",orderType] forKey:@"order"];
    orderMethod = orderMethod ?: 0;
    [dict setObject:[NSString stringWithFormat:@"%lu",orderMethod] forKey:@"order_type"];
    SS_SIGN;

    [FFNetWorkManager postRequestWithURL:Map.PRODUCT_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];

}


/** 出售商品 */
+ (void)sellProductWithAppID:(NSString *)appid Title:(NSString *)title SDKUsername:(NSString *)SDKUsername Price:(NSString *)price Description:(NSString *)description SystemType:(FFBusinessSystemType)systemType ServerName:(NSString *)serverName EndTime:(NSString *)endTime Images:(NSArray *)images TradeImgs:(NSArray *)trade_imgs Completion:(RequestCallBackBlock)completion {
    if ([self uid] == nil) {
        if (completion) {
            completion(@{@"msg":@"请登录"},NO);
        }
        return;
    }

    Pamaras_Key((@[@"uid",@"appid",@"title",@"sdk_username",
                   @"price",@"desc",@"system",@"server_name",
                   @"end_time"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:appid forKey:@"appid"];
    [dict setObject:title forKey:@"title"];
    [dict setObject:SDKUsername forKey:@"sdk_username"];
    [dict setObject:price forKey:@"price"];
    [dict setObject:description forKey:@"desc"];
    [dict setObject:[NSString stringWithFormat:@"%lu",systemType] forKey:@"system"];
    [dict setObject:serverName forKey:@"server_name"];
    [dict setObject:endTime forKey:@"end_time"];
    SS_SIGN;

    //上传的多张照片
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:images.count];
    for (int i = 0; i < images.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(images[i], 0.9);
        [dataArray addObject:imageData];
    }

    NSMutableArray *trade_data = [NSMutableArray arrayWithCapacity:trade_imgs.count];
    for (int i = 0; i < images.count; i++) {
        NSData *imageData = UIImageJPEGRepresentation(trade_imgs[i], 0.9);
        [trade_data addObject:imageData];
    }

    [FFNetWorkManager uploadImageWithURL:Map.SELL_PRODUCTS Params:dict FileDict:@{@"imgs[]":dataArray,@"trade_imgs[]":trade_data} FileName:@"sellProduct.png" MimeType:@"" Progress:nil Success:^(NSDictionary * _Nonnull content) {
        REQUEST_STATUS;
        if (status.integerValue == 1) {
            if (completion) {
                completion(content,YES);
            }
        } else {
            if (completion) {
                completion(content,NO);
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        if (completion) {
            completion(@{@"msg":error.localizedDescription},NO);
        }
    }];

//    [FFNetWorkManager uploadImageWithURL:Map.SELL_PRODUCTS Params:dict FileData:dataArray FileName:@"sellProduct.png" Name:@"imgs[]" MimeType:@"" Progress:nil Success:^(NSDictionary * _Nonnull content) {
//        REQUEST_STATUS;
//        if (status.integerValue == 1) {
//            if (completion) {
//                completion(content,YES);
//            }
//        } else {
//            if (completion) {
//                completion(content,NO);
//            }
//        }
//    } Failure:^(NSError * _Nonnull error) {
//        if (completion) {
//            completion(@{@"msg":error.localizedDescription},NO);
//        }
//    }];
}


/** 商品详情 */
+ (void)ProductInfoWithProductID:(NSString *)pid WithUid:(BOOL)useUid Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"product_id",@"system",@"uid"]));
    SS_DICT;
    [dict setObject:pid forKey:@"product_id"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:useUid ? [self uid] : @"0" forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.PRODUCT_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** 客服中心 */
+ (void)customerWithCompletion:(RequestCallBackBlock)completion {
    [FFNetWorkManager postRequestWithURL:Map.PRODUCT_CUSTOMER Params:nil Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}


/** 买家记录 */
+ (void)userButRecordWithType:(FFBusinessUserBuyType)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"type"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.BUYER_RECORD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 卖家记录 */
+ (void)userSellRecordWithPage:(NSString *)page Type:(FFBusinessUserSellType)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"status",@"page"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"status"];
    [dict setObject:page forKey:@"page"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.PRODUCT_BYUSER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 下载商品 */
+ (void)dropOffProductWithID:(NSString *)productID Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"product_id"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:productID forKey:@"product_id"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.WITHDRAW_PRODUCTS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 上架商品 */
+ (void)dropOnProductWithProductID:(NSString *)productID Title:(NSString *)title Price:(NSString *)price Description:(NSString *)description SystemType:(FFBusinessSystemType)systemType ServerName:(NSString *)serverName EndTime:(NSString *)endTime Images:(NSArray *)images TradeImgs:(NSArray *)trade_imgs Completion:(RequestCallBackBlock)completion {
    if ([self uid] == nil) {
        if (completion) {
            completion(@{@"msg":@"请登录"},NO);
        }
        return;
    }

    Pamaras_Key((@[@"uid",@"product_id",@"title",@"price",
                   @"desc",@"system",@"server_name",@"end_time"]));
    SS_DICT;
    [dict setObject:[self uid] forKey:@"uid"];
    [dict setObject:productID forKey:@"product_id"];
    [dict setObject:title forKey:@"title"];
    [dict setObject:price forKey:@"price"];
    [dict setObject:description forKey:@"desc"];
    [dict setObject:[NSString stringWithFormat:@"%lu",systemType] forKey:@"system"];
    [dict setObject:serverName forKey:@"server_name"];
    [dict setObject:endTime forKey:@"end_time"];
    SS_SIGN;

    //上传的多张照片
    NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
    if (images && images.count > 0) {
        NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:images.count];
        for (int i = 0; i < images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.9);
            [dataArray addObject:imageData];
        }
        [imageDict setObject:dataArray forKey:@"imgs[]"];
    }

    if (trade_imgs != nil && trade_imgs.count > 0) {
        NSMutableArray *trade_data = [NSMutableArray arrayWithCapacity:trade_imgs.count];
        for (int i = 0; i < images.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(trade_imgs[i], 0.9);
            [trade_data addObject:imageData];
        }
        [imageDict setObject:trade_data forKey:@"trade_imgs[]"];
    }

    [FFNetWorkManager uploadImageWithURL:Map.PRODUCT_ONSALE Params:dict FileDict:imageDict FileName:@"sellProduct.png" MimeType:@"" Progress:nil Success:^(NSDictionary * _Nonnull content) {
        REQUEST_STATUS;
        if (status.integerValue == 1) {
            if (completion) {
                completion(content,YES);
            }
        } else {
            if (completion) {
                completion(content,NO);
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        if (completion) {
            completion(@{@"msg":error.localizedDescription},NO);
        }
    }];
}

/** 购买商品 */
+ (void)buyProductWithID:(NSString *)productID payType:(FFBusinessPayType)type Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"proid",@"buy_id",@"type"]));
    SS_DICT;
    [dict setObject:productID forKey:@"proid"];
    [dict setObject:[self uid] forKey:@"buy_id"];
    [dict setObject:[NSString stringWithFormat:@"%lu",type] forKey:@"type"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.START_PAYMENT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 须知 */
+ (void)businessNotice:(RequestCallBackBlock)completion {
    [FFNetWorkManager postRequestWithURL:Map.TRADE_NOTES Params:nil Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

/** 删除商品 */
+ (void)deleteProductWIthProductID:(NSString *)productID Completion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"product_id"]));
    SS_DICT;
    [dict setObject:productID forKey:@"product_id"];
    [dict setObject:[self uid] forKey:@"uid"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.DELETE_PRODUCTS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}



@end











