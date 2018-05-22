//
//  FFBoxModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNetWorkManager.h"

typedef void (^MapCompletion)(void);
typedef void (^NotiCompletion)(NSDictionary *  content, BOOL success);


@interface FFBoxModel : FFNetWorkManager

/** check box version */
+ (void)checkBoxVersionCompletion:(void(^)(NSDictionary *  content, BOOL success))completion;

/** update box */
+ (void)boxUpdateWithUrl:(NSString *)url;

/** first login */
+ (BOOL)isFirstLogin;

/** first install */
+ (BOOL)isFirstInstall;

/** app  announcement */
+ (void)appAnnouncement;

+ (void)login;
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

/** advertising  */
+ (void)postAdvertisingImage;

+ (id *)addAdvertisinImage;

+ (NSData *)getAdvertisingImage;

+ (void)UnreadMessagesWithCompletion:(MapCompletion)completion;


@end
