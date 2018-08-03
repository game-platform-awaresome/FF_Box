//
//  FFBoxHandler.h
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"

typedef void(^BoxSuccessBlock)(NSDictionary *content);
typedef void(^BoxFailureBlock)(NSDictionary *content);


@interface FFBoxHandler : NSObject

@property (nonatomic, strong) NSString *update_url;         //盒子更新地址
@property (nonatomic, strong) NSString *start_page;         //启动页
@property (nonatomic, strong) NSString *start_page_link;    //启动页广告链接
@property (nonatomic, strong) NSDictionary *app_notice;     //盒子通知
@property (nonatomic, strong) NSString *box_static;         //盒子统计
@property (nonatomic, strong) NSString *qq_zixun;           //qq 资讯
@property (nonatomic, strong) NSString *discount_enabled;   //折扣服开启关闭
@property (nonatomic, strong) NSString *business_enbaled;   //交易系统开关

/** 单例 */
+ (FFBoxHandler *)sharedInstance;


/** 请求盒子初始化 */
+ (void)boxInitWithSuccess:(BoxSuccessBlock)successBlock
                   Failure:(BoxFailureBlock)failureBlock;

/** 是否是第一次安装 */
+ (BOOL)FirstInstall;
/** 是否第一次登陆 */
+ (BOOL)isFirstLogin;

/** 是否加载过蒙版 */
+ (BOOL)isAddmaskView;


/** 自动登录 */
+ (void)login;
/** 获取广告页本地缓存 */
+ (NSData *)getAdvertisingImage;




@end
