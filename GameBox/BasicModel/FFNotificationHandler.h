//
//  FFNotificationHandler.h
//  GameBox
//
//  Created by 燚 on 2018/7/3.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AddCompletion)(NSDictionary *  content, BOOL success);
typedef void (^AddNotiCompletion)(BOOL success);

@interface FFNotificationHandler : NSObject



/** 注册本地通知 */
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(AddCompletion)completion;

/** 添加通知 */
+ (void)addNotificationWithTitle:(NSString *)title
                            Body:(NSString *)body
                            Time:(NSString *)time
                        UserInfo:(NSDictionary *)userInfo
               RequestIdentifier:(NSString *)requestIdentifier
                          Repeat:(BOOL)repeat
                      Completion:(AddNotiCompletion)completion;



@end
