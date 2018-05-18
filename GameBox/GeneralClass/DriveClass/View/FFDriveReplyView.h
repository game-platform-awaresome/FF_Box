//
//  FFDriveReplyView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/22.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SendCommentNotificationName @"SendCommentNotificationName"

@interface FFDriveReplyView : UIWindow


+ (void)showReplyViewWithDynamicID:(NSString *)dynamicID;

+ (void)showReplyViewWithDynamicID:(NSString *)dynamicID
                             ToUid:(NSString *)toUid;




@end
