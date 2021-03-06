//
//  FFAppDelegate.m
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFControllerManager.h"

//third library
#import <WXApi.h>
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>

#import <UserNotifications/UserNotifications.h>
#import <FFTools/FFTools.h>

#import "FFMapModel.h"
#import "FFStatisticsModel.h"
#import "FFDeviceInfo.h"

#import "FFMaskView.h"
#import "FFAdvertisingView.h"
#import "FFLaunchScreen.h"
#import "FFShowDiscoutModel.h"
#import "FFBusinessBuyModel.h"


#define WEIXINAPPID @"wx998abec7ee53ed78"
#define QQAPPID @"1106099979"

#import "FFDefaultWindow.h"
#import "FFMainWindow.h"
#import "FFBoxHandler.h"

#import "H5Handler.h"


#import "OpenUDID.h"


#import <TTTracker/TTTracker.h>
#import <TTTracker/TTInstallIDManager.h>
//#import <TTTracker/TTABTestConfFetcher.h>
#import <TTTracker/TTInstallIDManager.h>


@interface FFAppDelegate () <UNUserNotificationCenterDelegate>


@end


@implementation FFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    syLog(@"\n----------------------------------\nchannel === %@\n----------------------------------\n",Channel);
    syLog(@"\n----------------------------------\nbundle ==== %@\n----------------------------------\n",[[NSBundle mainBundle] bundleIdentifier]);


//    NSLog(@"\n----------------------------------\nudid ==== %@\n----------------------------------\n",[OpenUDID value]);


    //检查渠道号
    [FFDeviceInfo cheackChannel];
    self.window = [FFDefaultWindow window];
    [self.window makeKeyAndVisible];
    //获取总接口
    [FFMapModel getMapCompletion:^{
        //登录
        [FFBoxHandler login];
        //盒子初始化
        [FFBoxHandler boxInitWithSuccess:^(NSDictionary *content) {
            syLog(@"box init success === %@",content);
            if ((self.window = [FFMainWindow sharedWindow])) {
                [self.window makeKeyAndVisible];
                [FFDefaultWindow resignWindow];
                //加载蒙版
//                [self addMaskView:[FFBoxHandler isAddmaskView]];
//                [self addMaskView:YES];
                //加载引导页
//                if (/* DISABLES CODE */ (YES)) {
                if ([FFBoxHandler isFirstLogin]) {
                    [self.window addSubview:[FFLaunchScreen new]];
                } else {
                    if ([FFBoxHandler getAdvertisingImage]) {
                        syLog(@"加载广告页");
                        [FFAdvertisingView initWithImage:[FFBoxHandler getAdvertisingImage]];
                    }
                }
            } else {
                self.window = [FFDefaultWindow window];
            }
        } Failure:nil];
    }];
    //初始化数据
    //注册微信
    [WXApi registerApp:WEIXINAPPID];
    //注册QQ
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:nil];
    [oAuth isSessionValid];
    //注册通知
    [self resignNotifacation];

    //test
//    [self setToutiao];


    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //进入后台
    m185StatisticsUploadData();

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - method
- (void)initializeUserInterface {

}


/**
 注册通知
 通知目前只适配了 10.0 以上
 */
- (void)resignNotifacation {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;

        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted == YES) {
                SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:granted], @"NOTIFICATIONSETTING");
            } else {
                SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:NO], @"NOTIFICATIONSETTING");
            }
        }];

        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {

        }];
    } else {

    }
}

- (void)addMaskView:(BOOL)add {
    if (add) {
        [FFMaskView addMaskViewWithWindow:self.window];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString *status = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if (status.integerValue == 6004 || status.integerValue == 9000 || status.integerValue == 8000 || status.integerValue == 5000 ) {
                [UIAlertController showAlertMessage:@"支付成功" dismissTime:0.7 dismissBlock:nil];
            } else {
                //取消订单
                [FFBusinessBuyModel cancelOrder:nil];
            }
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }

    return YES;
}


//配置今日头条
- (void)setToutiao {
    //配置
    NSLog(@"配置头条");

    [[TTTracker sharedInstance] setConfigParamsBlock:^NSDictionary * _Nullable{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"123455" forKey:@"user_unique_id"];

        return [params copy];
    }];

    [[TTTracker sharedInstance] setCustomHeaderBlock:^NSDictionary<NSString *,id> *{
        NSMutableDictionary *customParams = [NSMutableDictionary dictionary];
        [customParams setValue:@(1) forKey:@"user_is_login"];

        return [customParams copy];
    }];

    //DEBUG模式配置
//    [[TTTracker sharedInstance] setIsInHouseVersion:YES];
//    [[TTTracker sharedInstance] setDebugLogServerHost:@"10.2.201.7:10304"];

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //初始化appID和自定义参数
    //    [TTTracker startWithAppID:@"10008" channel:@"local_test" appName:@"_test"];
    //可控制初始化
    [[TTTracker sharedInstance] setSessionEnalbe:NO];
    [TTTracker startWithAppID:@"151823" channel:@"local_test" appName:@"shouyouhezi"];


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //统计埋点
    for (NSUInteger i = 0; i < 10; i++) {
        //        [TTTracker eventV3:@"toutiao" params:@{@"is_log_in":@(1)}];
        // 可控制埋点
        [TTTracker eventV3:@"toutiao" params:@{@"is_log_in":@(1)}];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TTTracker eventV3:@"tracker" params:@{@"user_id":@"123"}];
        });
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//    NSNumber *color = [[TTABTestConfFetcher sharedInstance] getConfig:@"btnColor" defaultValue:@(0)];
//    NSLog(@"color是：%ld",(long)[color longValue]);
//
//
//    [[TTInstallIDManager sharedInstance] setCurrentUserUniqueID:@"1234567" didRetriveSSIDBlock:^(NSString *deviceID, NSString *installID, NSString *ssID) {
//        NSLog(@"当前用户的ssid是：%@",ssID);
//    }];
//
//    [[TTABTestConfFetcher sharedInstance] startFetchABTestConf:^(NSDictionary *allConfigs) {
//        NSLog(@"%@", [allConfigs description]);
//    }];

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Game
    //    [TTTracker registerEventByMethod:@"wechat" isSuccess:YES];
    //    //支付
    //    [TTTracker purchaseEventWithContentType:@"mingwen"
    //                                contentName:@"qiangjian"
    //                                  contentID:@"2345556"
    //                              contentNumber:100
    //                             paymentChannel:@"weixin"
    //                                   currency:@"rmb"
    //                            currency_amount:80000
    //                                  isSuccess:YES];

}






@end
