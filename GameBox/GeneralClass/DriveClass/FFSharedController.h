//
//  FFSharedController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedDynamicsSuccess @"SharedDynamicsSuccess"


@interface FFSharedController : NSObject

/** 好友邀请 */
+ (void)inviteFriend;

/** 分享游戏 */
+ (void)sharedGameWith:(id)info;

/** 分享动态 */
+ (void)sharedDynamicsWithDict:(NSDictionary *)dict;



@end
