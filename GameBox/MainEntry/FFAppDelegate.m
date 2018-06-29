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


@interface FFAppDelegate () <UNUserNotificationCenterDelegate>


@end


@implementation FFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    syLog(@"\n-----------------------------------------\nchannel === %@\n-----------------------------------------\n",Channel);
    syLog(@"\n-----------------------------------------\nbundle ==== %@\n-----------------------------------------\n",[[NSBundle mainBundle] bundleIdentifier]);

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
            
            if (![FFMainWindow showWindowWithOriWindw:self.window]) {
                syLog(@"main window error");
                self.window = [FFDefaultWindow window];
            } else {
                 //加载蒙版
                 [self addMaskView:[FFBoxHandler FirstInstall]];
                 //加载引导页
                 if ([FFBoxHandler isFirstLogin]) {
                     [self.window addSubview:[FFLaunchScreen new]];
                 } else {
                     if ([FFBoxHandler getAdvertisingImage]) {
                         syLog(@"加载广告页");
                         [FFAdvertisingView initWithImage:[FFBoxHandler getAdvertisingImage]];
                     }
                 }
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
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


/** 注册通知 */
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

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString *status = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if (status.integerValue == 6004 || status.integerValue == 9000 || status.integerValue == 8000 || status.integerValue == 5000 ) {
                [UIAlertController showAlertMessage:@"支付成功" dismissTime:0.7 dismissBlock:nil];
            } else {
                //取消订单 ??
                [FFBusinessBuyModel cancelOrder:nil];
            }
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }

    return YES;
}










@end
