//
//  FFUserModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"

#define CURRENT_USER [FFUserModel currentUser]

@interface FFUserModel : FFBasicModel

/** 是否登录 */
//@property (nonatomic, strong) NSString *isLogin;
/** uid */
@property (nonatomic, strong) NSString *uid;
/** 用户名 */
@property (nonatomic, strong) NSString *username;
/** 手机号码 */
@property (nonatomic, strong) NSString *mobile;
/** 平台币 */
@property (nonatomic, strong) NSString *platform_money;
/** 金币 */
@property (nonatomic, strong) NSString *coin;
/** 头像地址 */
@property (nonatomic, strong) NSString *icon_url;
/** 昵称 */
@property (nonatomic, strong) NSString *nick_name;
/** 邀请奖励 */
@property (nonatomic, strong) NSString *recom_bonus;

@property (nonatomic, assign) BOOL isLogin;

/** 当前用户 */
+ (FFUserModel *)currentUser;

#pragma mark - 类方法
+ (BOOL)setUID:(NSString *)uid;
+ (NSString *)uid;
+ (BOOL)deleteUID;

+ (BOOL)setUserName:(NSString *)userName;
+ (NSString *)UserName;
+ (BOOL)deleteUserName;

+ (BOOL)setPassWord:(NSString *)passWord;
+ (NSString *)passWord;
+ (BOOL)deletePassWord;


#pragma mark - ================================ 注册和登录 ================================
/**
 * 用户登录
 * @param username 用户名(或者手机号码)
 @ @param password 密码
 */
+ (void)userLoginWithUsername:(NSString *)username
                     Password:(NSString *)password
                   Completion:(RequestCallBackBlock)completion;
/**
 * 用户注册接口
 * @param userName      用户名
 * @param code          短信验证码
 * @param phoneNumber   手机号码
 * @param passWord      密码
 * @param type          注册类型
 */
+ (void)userRegisterWithUserName:(NSString * )userName
                            Code:(NSString * )code
                     PhoneNumber:(NSString * )phoneNumber
                        PassWord:(NSString * )passWord
                            Type:(NSString * )type
                      Completion:(RequestCallBackBlock)completion;
/**
 * 用户 - 修改密码
 * @param oldPassword   旧密码
 * @param newPassword   新密码
 */
+ (void)userModifyPasswordOldPassword:(NSString *)oldPassword
                          NewPassword:(NSString *)newPassword
                           Completion:(RequestCallBackBlock)completion;
#pragma makr - ================================ 签到 ================================
/** 用户 - 签到初始化 */
+ (BOOL)signInitWithCompletion:(RequestCallBackBlock)completion;
/** 用户 - 签到 */
+ (BOOL)doSignWithCompletion:(RequestCallBackBlock)completion;

#pragma mark - ================================ 绑定手机 ================================
/** 用户 - 绑定手机 */
+ (BOOL)userBindingPhoneNumber:(NSString *)phoneNumber
                          Code:(NSString *)code
                    Completion:(RequestCallBackBlock)completion;

/** 用户 - 解绑手机 */
+ (BOOL)userUnbindingPhoneNumber:(NSString *)phoneNumber
                            Code:(NSString *)code
                      Completion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 获取 vip 选项 =======================
/** 用户 - 获取 VIP 选项 */
+ (void)vipGetOptionWithCompletion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 邀请好友 =======================
/** 用户 - 邀请好友 */
+ (BOOL)inviteFriendWithCompletion:(RequestCallBackBlock)completion;


#pragma mark - ======================= 客服中心 =======================
/** 客服中心 */
+ (void)customerServiceWithCompletion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 我的收藏 =======================
/** 用户 - 我的收藏 */
+ (BOOL)myCollectionGameWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 找回密码 =======================
/** 获取手机验证码 */
+ (void)userSendMessageWithPhoneNumber:(NSString *)phoneNumber
                                  Type:(NSString *)type
                            Completion:(RequestCallBackBlock)completion;
/** 检验验证码 */
+ (void)userCheckMessageWithPhoneNumber:(NSString *)phoneNumber
                            MessageCode:(NSString *)messageCode
                             Completion:(RequestCallBackBlock)completion;

/** 重置密码 */
+ (void)userForgetPasswordWithUserID:(NSString *)userID
                            Password:(NSString *)password
                          RePassword:(NSString *)rePassword
                               Token:(NSString *)token
                          Completion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 修改昵称 =======================
/** 修改昵称 */
+ (BOOL)userModifyNicknameWithUserID:(NSString *)userID
                            NickName:(NSString *)nickName
                          Completion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 上传头像 =======================
/** 用户 - 上传头像 */
+ (BOOL)userUploadPortraitWithImage:(id)image Completion:(RequestCallBackBlock)completion;


#pragma mark - ======================= 用户币 =======================
/** 用户 - 各种币 */
+ (BOOL)userCoinWithCompletion:(RequestCallBackBlock)completion;

/** 用户 - 金币中心 */
+ (BOOL)coinCenterWithCompletion:(RequestCallBackBlock)completion;

/** 用户 - 金币明细 */
+ (BOOL)coinDetailWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion;

/** 用户 - 兑换平台币信息 */
+ (BOOL)coinExchangeInfoCompletion:(RequestCallBackBlock)completion;

/** 用户 - 兑换平台币 */
+ (BOOL)coinExchangePlatformCounts:(NSString *)platform_counts
                        Completion:(RequestCallBackBlock)completion;

/** 用户 - 平台币明细 */
+ (BOOL)coinPlatformDetailWithPage:(NSString *)page
                        Completion:(RequestCallBackBlock)completion;

/** 用户 - 我的奖品 */
+ (BOOL)myPrizeCompletion:(RequestCallBackBlock)completion;

#pragma mark - ======================= 申请转游 =======================
/** 用户 - 申请转游戏 */
+ (BOOL)transferGameApplyWithOriginAppName:(NSString *)origin_appname
                          OriginServerName:(NSString *)origin_servername
                            OriginRoleName:(NSString *)origin_rolename
                                NewAppName:(NSString *)new_appname
                             NewServerName:(NSString *)new_servername
                               NewRoleName:(NSString *)new_rolename
                                  QQNumber:(NSString *)qq
                                    Mobile:(NSString *)mobile
                                Completion:(RequestCallBackBlock)completion;

/** 用户 - 转游戏记录 */
+ (BOOL)transferGameListWithPage:(NSString *)page
                      Completion:(RequestCallBackBlock)completion;

/** 转游须知 */
+ (void)transferGameoticeCompletion:(RequestCallBackBlock)completion;



///** 登录 */
//+ (void)login:(NSDictionary *)dict;
///** 登出 */
//+ (void)signOut;
//+ (NSDictionary *)getUserDict;
///** uid */
//+ (NSString *)uid;
//+ (BOOL)setUID:(NSString *)uid;
//+ (NSString *)getUID;
//+ (BOOL)deleteUID;
///** username */
//+ (BOOL)setUserName:(NSString *)userName;
//+ (NSString *)getUserName;
//+ (BOOL)deleteUserName;
//+ (NSString *)UserName;
///** password */
//+ (BOOL)setPassWord:(NSString *)passWord;
//+ (NSString *)getPassWord;
//+ (BOOL)deletePassWord;
///** avatar */
//+ (NSData *)getAvatarData;
//+ (void)setAvatarData:(NSData *)data;





@end







