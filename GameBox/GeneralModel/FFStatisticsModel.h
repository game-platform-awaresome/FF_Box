//
//  FFStatisticsModel.h
//  GameBox
//
//  Created by 燚 on 2018/4/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^initBoxCallBack)(NSString * _Nonnull showdiscount);

/** 初始化统计 */
void BoxinitStatisticsModel(NSUInteger state);
/** 注册统计 */
void BoxstatisticsRegistered(NSString * _Nonnull account);
/** 登录统计 */
void BoxstatisticsLogin(NSString * _Nonnull account);
/** 开始支付统计 */
void BoxstatisticsPayStart(NSString * _Nonnull transactionID, NSString * _Nonnull payMentType, NSString * _Nonnull amount);
/** 支付回调统计 */
void BoxstatisticsPayCallBack(NSString * _Nonnull transactionID, NSString * _Nonnull payMentType, NSString * _Nonnull amount);
/** 自定义事件统计 */
void BoxcustomEvents(NSString * _Nonnull name, NSDictionary * _Nullable extra);
/** 用户事件 */
void BoxuserProfile(NSDictionary * _Nonnull dataDict);

@interface FFStatisticsModel : NSObject

/** app install statistic */
+ (void)installStatistic;

/** app start statistic */
+ (void)startStatistic;





@end
