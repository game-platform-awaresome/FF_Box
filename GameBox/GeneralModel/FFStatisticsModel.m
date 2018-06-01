//
//  FFStatisticsModel.m
//  GameBox
//
//  Created by 燚 on 2018/4/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFStatisticsModel.h"
#import "FFNetWorkManager.h"
#import "FFDeviceInfo.h"
#import "FFMapModel.h"
#import "TrackingIO.h"

#define TrackingIOID @"ffcaffb5979b3df9ff12751857fc88fa"
#define TrackingIOToken @"506D348071C391675943F5754F6AF056"

#define GDTActionID         @"1106853768"                           //数据源 ID
#define GDTActionSecretKey  @"9fde0f5c7ea574a9edb962d745834243"     //数据源 Key

#define TrackingStart if ([self SharedModel].isStartStatistics == NO) {\
return;\
}\

#define statisticsModel [FFStatisticsModel sharedModel]

typedef enum : NSUInteger {
    other = 0,
    selfBackGround = 1,
    reyun = 2,
    guangdiantong = 3,
} FFStatisticsState;


@interface FFStatisticsModel ()

@property (nonatomic, assign) BOOL isStartStatistics;

@property (nonatomic, assign) FFStatisticsState registState;


@end


static FFStatisticsModel *model = nil;
@implementation FFStatisticsModel


+ (FFStatisticsModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFStatisticsModel alloc] init];
            model.isStartStatistics = NO;
            model.registState = other;
        }
    });
    return model;
}

/** 开始统计 */
+ (void)startStatics {
    syLog(@"是否开启统计 : %lu",[self sharedModel].registState);
    switch ([self sharedModel].registState) {
        case other: return;
        case selfBackGround: break;
        case reyun:  [TrackingIO initWithappKey:TrackingIOID withChannelId:Channel]; break;
        case guangdiantong:  break;
        default: break;
    }
}

/** app install statistic */
+ (void)installStatistic {


}

/** app start statistic */
+ (void)startStatistic {

}

@end

/** 初始化统计 */
void initStatisticsModel(initBoxCallBack callback) {
    NSDictionary *dict = @{@"channel":Channel,@"system":@"2"};
    [FFNetWorkManager postRequestWithURL:Map.BOX_INIT Params:@{@"channel":Channel,@"system":@"2",@"sign":BOX_SIGN(dict, (@[@"channel",@"system"]))} Success:^(NSDictionary * _Nonnull content) {
        syLog(@"统计  === %@", content);
        NSString *status = content[@"status"];

        if (status.integerValue == 1) {
        NSString *box_static = content[@"data"][@"box_static"];
        NSString *showdiscount = CONTENT_DATA[@"discount_enabled"];
            statisticsModel.registState = (FFStatisticsState)box_static.integerValue;
            if (callback) {
                callback(showdiscount);
            }
        } else {
            if (callback) {
                callback(@"0");
            }
        }
        [FFStatisticsModel startStatics];
    } Failure:^(NSError * _Nonnull error) {
        statisticsModel.isStartStatistics = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            initStatisticsModel(callback);
        });
    }];
}


/** 注册统计 */
void statisticsRegistered(NSString *account) {
    switch (statisticsModel.registState) {
        case other:
            return;
        case selfBackGround:
            break;
        case reyun: {
            [TrackingIO setRegisterWithAccountID:account];
            break;
        }
        case guangdiantong: {
            break;
        }

        default:
            break;
    }
    syLog(@"注册统计");
}


/** 登录统计 */
void statisticsLogin(NSString * account) {
    switch (statisticsModel.registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setLoginWithAccountID:account];
            break;
        }
        case guangdiantong: {
            break;
        }
        default:
            break;
    }
    syLog(@"登录统计");
}

/** 开始支付统计 */
void statisticsPayStart(NSString *_Nonnull transactionID, NSString * _Nonnull payMentType, NSString * _Nonnull amount) {
    syLog(@"准备支付统计");
    /** typedef enum : NSUInteger {
     AliQRcode = 1,
     Alipay = 2,
     WechatQRcode = 3,
     WechatPay = 4,
     TenPay = 6,
     ChinaMobile = 7,
     ChinaTelecom = 8,
     ChinaUnicom = 9,
     platformCoin = 10
     } PayType; */
    NSString *pay;
    switch (payMentType.integerValue) {
        case 1:
        case 2: pay = @"alipay";
            break;
        case 3:
        case 4: pay = @"weixinpay";
            break;
        default:
            break;
    }

    switch (statisticsModel.registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setryzfStart:transactionID ryzfType:pay currentType:@"CNY" currencyAmount:amount.floatValue];
            break;
        }
        case guangdiantong: {

            break;
        }

        default:
            break;
    }
}

void statisticsPayCallBack(NSString *_Nonnull transactionID, NSString * _Nonnull payMentType, NSString * _Nonnull amount) {
    syLog(@"支付回调统计");
    /** typedef enum : NSUInteger {
     AliQRcode = 1,
     Alipay = 2,
     WechatQRcode = 3,
     WechatPay = 4,
     TenPay = 6,
     ChinaMobile = 7,
     ChinaTelecom = 8,
     ChinaUnicom = 9,
     platformCoin = 10
     } PayType; */
    NSString *pay;
    switch (payMentType.integerValue) {
        case 1:
        case 2: pay = @"alipay";
            break;
        case 3:
        case 4: pay = @"weixinpay";
            break;
        default:
            break;
    }

    switch (statisticsModel.registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setryzf:transactionID ryzfType:pay currentType:@"CNY" currencyAmount:amount.floatValue];
            break;
        }
        case guangdiantong: {

            break;
        }

        default:
            break;
    }
}

/** 自定义 */
void customEvents(NSString * _Nonnull name, NSDictionary * _Nullable extra) {
    syLog(@"自定义统计 : %@",name);
    switch (statisticsModel.registState) {
        case other:
            return;
        case selfBackGround:
            break;
        case reyun: {
            [TrackingIO setEvent:name andExtra:extra];
            break;
        }
        case guangdiantong: {
            break;
        }
        default:
            break;
    }
}

/** 用户统计 */
void userProfile(NSDictionary * _Nonnull dataDict) {
    syLog(@"用户统计 : %@",dataDict);
    switch (statisticsModel.registState) {
        case other:
            return;
        case selfBackGround:

            break;
        case reyun: {
            [TrackingIO setProfile:dataDict];
            break;
        }
        case guangdiantong: {

            break;
        }

        default:
            break;
    }
}


