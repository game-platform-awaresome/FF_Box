//
//  FFStatisticsModel.h
//  GameBox
//
//  Created by 燚 on 2018/4/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 初始化统计 */
void initStatisticsModel(void);
/** 注册统计 */
void statisticsRegistered(NSString *account);




@interface FFStatisticsModel : NSObject


/** app install statistic */
+ (void)installStatistic;

/** app start statistic */
+ (void)startStatistic;


/** 注册统计 */
+ (void)statisticsRegistrationWithAccount:(NSString *)account;

/** 登录统计 */
+ (void)statisticsLoginWithAccount:(NSString *)account;

/** 支付统计 */
+ (void)statisticsPayWithTransactionID:(NSString *)transactionID
                           paymentType:(NSString *)payMentType
                        currencyAmount:(NSString *)amount;

/** 支付回调统计 */
+ (void)statisticsPayCallBackWithTransactionID:(NSString *)transactionID
                                   paymentType:(NSString *)payMentType
                                currencyAmount:(NSString *)amount;

/** 自定义事件统计 */
+ (void)customEventsWith:(NSString *)name Extra:(NSDictionary *)dict;


/** 用户事件统计 */
+ (void)profile:(NSDictionary*)dataDic;



@end
