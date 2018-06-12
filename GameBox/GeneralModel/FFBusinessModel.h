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


typedef struct FFbusinessUserModel {
    const char *uid;
} FFBusinessUserModel;

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




@end

















