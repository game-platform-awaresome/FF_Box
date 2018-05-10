//
//  FFUserModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"


@interface FFUserModel : FFBasicModel

/** 是否登录 */
@property (nonatomic, strong) NSString *isLogin;
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

/** 当前用户 */
+ (FFUserModel *)currentUser;

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
 * 修改密码
 * @param oldPassword   旧密码
 * @param newPassword   新密码
 */
+ (void)userModifyPasswordOldPassword:(NSString *)oldPassword
                          NewPassword:(NSString *)newPassword
                           Completion:(RequestCallBackBlock)completion;
#pragma makr - ================================ 签到 ================================

#pragma mark - ================================ 绑定手机 ================================
/** 绑定手机 */
+ (void)userBindingPhoneNumber:(NSString *)phoneNumber
                          Code:(NSString *)code
                    Completion:(RequestCallBackBlock)completion;

/** 解绑手机 */
+ (void)userUnbindingPhoneNumber:(NSString *)phoneNumber
                            Code:(NSString *)code
                      Completion:(RequestCallBackBlock)completion;


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







