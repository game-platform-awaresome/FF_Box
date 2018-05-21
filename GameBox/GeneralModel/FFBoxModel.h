//
//  FFBoxModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"

typedef void (^Completion)(NSDictionary *  content, BOOL success);



@interface FFBoxModel : FFBasicModel


/** 注册本地通知 */
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(Completion)completion;
/** is add notification */
+ (BOOL)isAddNotificationWithDict:(NSDictionary *)dict;
/** notification identifier */
+ (NSString *)notificationIdentifierWithUserInfo:(NSDictionary *)dict;

+ (NSArray *)allNotifications;

+ (void)deleteNotificationWith:(id)dict;
+ (void)deleteAllNotification;




@end
