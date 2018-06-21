//
//  FFBusinessModel.h
//  GameBox
//
//  Created by 燚 on 2018/6/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"
#import "FFNetWorkManager.h"

#define FFBusinessRegistSuccess @"FFBusinessRegistSuccess"

typedef enum : NSUInteger {
    FFBusinessTypeRegist = 1,
    FFBusinessTypePassword
} FFSendMessageType;

typedef enum : NSUInteger {
    FFBusinessPayAlipay = 1,
    FFBusinessPayWechat
}FFBusinessPayType;

typedef enum : NSUInteger {
    FFBusinessSystemTypeAndroid = 1,
    FFBusinessSystemTypeIOS
} FFBusinessSystemType;

typedef struct FFbusinessUserModel {
    const char *uid;
} FFBusinessUserModel;

typedef enum : NSUInteger {
    FFBusinessOrderTypeTime = 1,
    FFBusinessOrderTypePrice
} FFBusinessOrderType;

typedef enum : NSUInteger {
    FFBusinessOrderMethodDescending = 1,
    FFBusinessOrderMethodAscending,
} FFBusinessOrderMethod;

typedef enum : NSUInteger {
    FFBusinessUserBuyTypePaySuccess = 1,
    FFBusinessUserBuyTypeCancel = 2,
    FFBusinessUserBuyTypeBuySuccess = 4,
    FFBusinessUserBuyTypeAll = 5
} FFBusinessUserBuyType;

typedef enum : NSUInteger {
    FFBusinessUserSellTypeAll = 0,
    FFBusinessUserSellTypeUnderReview,
    FFBusinessUserSellTypeSelling,
    FFBusinessUserSellTypeTransacton,
    FFBusinessUserSellTypeSold,
    FFBusinessUserSellTypeCancel
} FFBusinessUserSellType;


FFBusinessUserModel * currentUser(void);


@interface FFBusinessModel : FFBasicModel

+ (FFBusinessUserModel *)sharedModel;


+ (NSString *)uid;
+ (BOOL)setUid:(NSString *)uid;
+ (BOOL)deleteUid;
+ (NSString *)username;
+ (BOOL)setUsername:(NSString *)username;
+ (BOOL)deleteUsername;
+ (NSString *)password;
+ (BOOL)setPassword:(NSString *)password;
+ (BOOL)deletePassword;

+ (BOOL)signOut;

+ (void)loginSuccessWith:(NSDictionary *)dict;

/** 发送短信验证码 */
+ (void)sendMessageWithPhoneNumber:(NSString *)number
                              type:(FFSendMessageType)type
                        Completion:(RequestCallBackBlock)completion;

/** 注册交易账号 */
+ (void)registAccountWithPhoneNumber:(NSString *)number
                                Code:(NSString *)code
                            Password:(NSString *)password
                          Completion:(RequestCallBackBlock)completion;

/** 登录交易账号 */
+ (void)loginAccountWithUserName:(NSString *)userName
                        Password:(NSString *)password
                      Completion:(RequestCallBackBlock)completion;

/** 修改交易账号密码 */
+ (void)modifyPasswordWithPassword:(NSString *)password
                       NewPassword:(NSString *)newPassword
                        Completion:(RequestCallBackBlock)completion;

/** 找回密码 */
+ (void)recoverPasswordWithPhoneNumber:(NSString *)number
                                  Code:(NSString *)code
                           NewPassword:(NSString *)newPassword
                            Completion:(RequestCallBackBlock)completion;

/** 账号资料 */
+ (void)getUserInfoWithCompletion:(RequestCallBackBlock)completion;

/** 编辑账号资料 */
+ (void)editUserInfoWithQQ:(NSString *)qq
             AlipayAccount:(NSString *)alipayAccount
                      Icon:(id)icon
                Completion:(RequestCallBackBlock)completion;

/** 验证交易账号信息完整 */
+ (void)verifyUserInfoWithCompletion:(RequestCallBackBlock)completion;

/** 关联 SDK 账号 */
+ (void)linkSDKAccountWithSDKAccount:(NSString *)sdkAccount
                         SDKPassword:(NSString *)adkPassword
                          Completion:(RequestCallBackBlock)completion;

/** 取消关联 SDK 账号 */
+ (void)cancelLinkSDKAccountWithSDKAccount:(NSString *)sdkAccount
                                Completion:(RequestCallBackBlock)completion;

/** 关联 SDK 账号列表 */
+ (void)linkSDKAccountListCompletion:(RequestCallBackBlock)completion;

/** 发起支付 */
+ (void)payStartWithProductID:(NSString *)productID
                          Uid:(NSString *)uid
                         Type:(FFBusinessPayType)type
                   Completion:(RequestCallBackBlock)completion;

/** 取消支付 */
+ (void)cancelPaymentWithOrderID:(NSString *)orderID
                      Completion:(RequestCallBackBlock)completion;

/** 商品列表 */
+ (void)productListWithGameName:(NSString *)gameName
                           Page:(NSString *)page
                         System:(FFBusinessSystemType)systemType
                      OrderType:(FFBusinessOrderType)orderType
                    OrderMethod:(FFBusinessOrderMethod)orderMethod
                     Completion:(RequestCallBackBlock)completion;

/** 提交商品,出售商品 */
+ (void)sellProductWithAppID:(NSString *)appid
                       Title:(NSString *)title
                 SDKUsername:(NSString *)SDKUsername
                       Price:(NSString *)price
                 Description:(NSString *)description
                  SystemType:(FFBusinessSystemType)systemType
                  ServerName:(NSString *)serverName
                     EndTime:(NSString *)endTime
                      Images:(NSArray *)images
                  Completion:(RequestCallBackBlock)completion;

/** 商品详情 */
+ (void)ProductInfoWithProductID:(NSString *)pid
                      Completion:(RequestCallBackBlock)completion;

/** 客服中心 */
+ (void)customerWithCompletion:(RequestCallBackBlock)completion;

/** 买家记录 */
+ (void)userButRecordWithType:(FFBusinessUserBuyType)type
                   Completion:(RequestCallBackBlock)completion;

/** 卖家记录 */
+ (void)userSellRecordWithPage:(NSString *)page
                          Type:(FFBusinessUserSellType)type
                    Completion:(RequestCallBackBlock)completion;

/** 下架商品 */
+ (void)dropOffProductWithID:(NSString *)productID
                  Completion:(RequestCallBackBlock)completion;

@end

















