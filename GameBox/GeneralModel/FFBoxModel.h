//
//  FFBoxModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNetWorkManager.h"

#define NOTI_SET_DISCOUNT_VIEW @"NOTI_SET_DISCOUNT_VIEW"

typedef void (^MapCompletion)(void);
typedef void (^NotiCompletion)(NSDictionary *  content, BOOL success);
typedef void (^BoxInitCallBackBlock)(NSDictionary *content, BOOL success);


@interface FFBoxModel : FFNetWorkManager

@property (nonatomic, strong) NSString *update_url;         //盒子更新地址
@property (nonatomic, strong) NSString *start_page;         //启动页
@property (nonatomic, strong) NSDictionary *app_notice;     //盒子通知
@property (nonatomic, strong) NSString *box_static;         //盒子统计
@property (nonatomic, strong) NSString *discount_enabled;   //折扣服开启关闭
@property (nonatomic, strong) NSString *qq_zixun;           //qq 资讯

+ (FFBoxModel *)sharedModel;

/** 盒子初始化 V2 */
+ (void)BoxInit;

/** 是否是第一次安装 */
+ (BOOL)FirstInstall;
/** 是否第一次登陆 */
+ (BOOL)isFirstLogin;

/** 获取广告页 */
+ (NSData *)getAdvertisingImage;





+ (NSArray *)notificationList;

/** 注册本地通知 */
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(NotiCompletion)completion;
/** is add notification */
+ (BOOL)isAddNotificationWithDict:(NSDictionary *)dict;
/** notification identifier */
+ (NSString *)notificationIdentifierWithUserInfo:(NSDictionary *)dict;

+ (NSArray *)allNotifications;

+ (void)deleteNotificationWith:(id)dict;
+ (void)deleteAllNotification;





@end
