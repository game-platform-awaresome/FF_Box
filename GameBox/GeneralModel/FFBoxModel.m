//
//  FFBoxModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBoxModel.h"
#import <UIKit/UIKit.h>
#import "FFDeviceInfo.h"
#import "FFMapModel.h"
#import <UserNotifications/UserNotifications.h>
#import <SDWebImageManager.h>

#import "FFUserModel.h"


@implementation FFBoxModel

#pragma mark - ========================== 检查更新 =====================================
/** 客户端检查更新 */
+ (void)checkBoxVersionCompletion:(void(^_Nullable)(NSDictionary * _Nullable content, BOOL success))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:Channel forKey:@"channel_id"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"CFBundleVersion"]];
    [dict setObject:version forKey:@"version"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_CHECK_CLIENT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

+ (void)boxUpdateWithUrl:(NSString *)url {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:@"游戏有更新,前往更新" preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([FFNetWorkManager netWorkState] == FFNetworkReachabilityStatusReachableViaWiFi) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为流量" message:@"是否前去更新" preferredStyle:UIAlertControllerStyleAlert];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }]];
        }
    }]];
}



+ (BOOL)isFirstLogin {
    //    return YES;
    //第一次登陆
    NSString *isFirstGuide = [[NSUserDefaults standardUserDefaults] stringForKey:@"isFirstGuide"];
    //    return YES;
    //    [FFBoxModel isFirstInstall];
    if (isFirstGuide) {
        return NO;
    } else {
        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isFirstGuide");
        return YES;
    }
}

+ (void)login {
    NSString *username = [FFUserModel UserName];
    NSString *password = [FFUserModel passWord];
    if (username != nil && password != nil && username.length > 0 && password.length > 0) {
        [FFUserModel userLoginWithUsername:username Password:password Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            syLog(@"启动登录  ==%@ ",content);
            if (success) {
                syLog(@"自动登录成功");
            } else {
                syLog(@"自动登录失败  ->  username == %@    password == %@",username,password);
            }
        }];
    }
}

+ (BOOL)isFirstInstall {
    NSString *isFirstInstall = [[NSUserDefaults standardUserDefaults] stringForKey:@"isFirstInstall"];

    syLog(@"uploadFirstInstallSuccess f");

    if (!isFirstInstall) {
        //每次启动统计
        NSString *uploadFirstInstallSuccess = [[NSUserDefaults standardUserDefaults] stringForKey:@"uploadFirstInstallSuccess"];
        syLog(@"uploadFirstInstallSuccess f2");

        if (uploadFirstInstallSuccess) {
            return NO;
        } else {
            syLog(@"uploadFirstInstallSuccess ing ");

            [FFBoxModel gameBoxStarUpWithCompletion:^(NSDictionary * _Nullable content, BOOL success) {
                syLog(@"upload  gamebox star === %@",content);
                [FFBoxModel gameBoxInstallWithCompletion:^(NSDictionary * _Nullable content, BOOL success) {
                    syLog(@"upload  gamebox install === %@",content);
                    if (success) {
                        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isFirstInstall");
                        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"uploadFirstInstallSuccess");
                        [FFUserModel signOut];
                        syLog(@"uploadFirstInstallSuccess success");
                    } else {
                        syLog(@"上传第一次安装失败, 3秒后重新发送请求");
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            syLog(@"重新发送第一次安装请求");
                            [FFBoxModel isFirstInstall];
                        });
                    }

                }];

            }];
        }
        return YES;
    } else {
        //每次启动统计
        [FFBoxModel gameBoxStarUpWithCompletion:nil];
        return NO;
    }
}

/** 盒子启动统计 */
+ (void)gameBoxStarUpWithCompletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [dict setObject:version forKey:@"version"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:[FFDeviceInfo deviceID] forKey:@"code"];
    [dict setObject:[FFDeviceInfo systemVersion] forKey:@"system_version"];
    [dict setObject:[FFDeviceInfo DeviceIP] forKey:@"ip"];

    [FFNetWorkManager postRequestWithURL:Map.GAME_BOX_START_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"启动成功");
        REQUEST_COMPLETION;
    }];
}

/** 盒子安装 */
+ (void)gameBoxInstallWithCompletion:(void (^)(NSDictionary * _Nullable, BOOL))completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [dict setObject:version forKey:@"version"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"ios" forKey:@"maker"];
    [dict setObject:[FFDeviceInfo phoneType] forKey:@"mobile_model"];
    [dict setObject:[FFDeviceInfo deviceID] forKey:@"code"];
    [dict setObject:[FFDeviceInfo systemVersion] forKey:@"system_version"];
    [dict setObject:[FFDeviceInfo DeviceIP] forKey:@"ip"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_BOX_INSTALL_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"安装成功");
        REQUEST_COMPLETION;
    }];
}

+ (void)appAnnouncement {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"cid"];
    [dict setObject:BOX_SIGN(dict, @[@"cid"]) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.APP_NOTICE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success && [(content[@"data"]) isKindOfClass:[NSDictionary class]]) {
            [FFBoxModel addAppAnnouncementWith:(content[@"data"])];
            syLog(@"announcement == %@",content);
        } else {
            syLog(@"没有公告");
        }
    }];
}

+ (void)addAppAnnouncementWith:(NSDictionary *)dict {
    if (@available(iOS 10.0, *)) {
        UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = dict[@"title"];
        content.body = dict[@"content"];
        content.badge = @666;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = @{@"box notification ":@"app announcement"};
        NSString *requestIdentifier = [NSString stringWithFormat:@"%@app announcement",dict[@"add_time"]];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
}

+ (void)postAdvertisingImage {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:BOX_SIGN(dict, (@[@"system",@"channel"])) forKey:@"sign"];
    //    BOX_SIGN(dict, @[@"system",@"channel"])
    [FFNetWorkManager postRequestWithURL:Map.GAME_GET_START_IMGS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_STATUS;
        if (success && status.integerValue == 1) {
#warning advertising image
            syLog(@"advertising image === %@",content);
            [FFBoxModel saveAdvertisingImage:content[@"data"]];
        }
    }];
}

+ (NSData *)getAdvertisingImage {
    NSData *data = [NSData dataWithContentsOfFile:[FFBoxModel AdvertisingImagePath]];
    return data;
}

+ (void)saveAdvertisingImage:(NSString *)url {
    if ([url isKindOfClass:[NSString class]] && url.length > 0) {
        [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:(SDWebImageDownloaderLowPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (finished) {
                [data writeToFile:[FFBoxModel AdvertisingImagePath] atomically:YES];
            }
        }];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:[FFBoxModel AdvertisingImagePath] error:nil];
    }
}

+ (NSString *)AdvertisingImagePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"AdvertisingImage"];
    return filePath;
}

#pragma mark - =========================== push notification ===========================
//使用 UNNotification 本地通知
+ (void)registerNotification:(NSInteger )alerTime {

    // 使用 UNUserNotificationCenter 来管理通知
    if (@available(iOS 10.0, *)) {
        // 设置触发条件 UNNotificationTrigger
        UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:alerTime repeats:NO];
        // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Dely 时间提醒 - title";
        content.subtitle = [NSString stringWithFormat:@"Dely 装逼大会竞选时间提醒 - subtitle"];
        content.body = @"Dely 装逼大会总决赛时间到，欢迎你参加总决赛！希望你一统X界 - body";
        content.badge = @666;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};

        // 创建通知标示
        NSString *requestIdentifier = @"Dely.X.time";

        // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];

        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        // 将通知请求 add 到 UNUserNotificationCenter
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {

        }];
    }

}



#pragma mark - add local notification
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(NotiCompletion)completion {
    syLog(@"添加");
    syLog(@"dict === %@",dict);

    //    return;
    if (@available(iOS 10.0, *)) {
        NSString *time = dict[@"start_time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = [FFBoxModel year:date];
        components.month = [FFBoxModel month:date];
        components.day = [FFBoxModel day:date];
        components.hour = [FFBoxModel hour:date];
        components.minute = [FFBoxModel minute:date];
        components.second = [FFBoxModel second:date];
        UNCalendarNotificationTrigger *timeTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString stringWithFormat:@"%@ - %@服   即将开启",dict[@"gamename"],dict[@"server_id"]];
        content.body = [NSString stringWithFormat:@"%@ - %@ 即将开服，快快来游玩！希望你一统%@",dict[@"gamename"],dict[@"server_id"],dict[@"gamename"]];
        content.badge = @666;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = dict;
        NSString *requestIdentifier = [FFBoxModel notificationIdentifierWithUserInfo:dict];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                if (completion) {
                    completion(nil,YES);
                }
            }
        }];
    } else {

    }
}


+ (BOOL)isAddNotificationWithDict:(NSDictionary *)dict {
    NSArray *array = [FFBoxModel allNotifications];
    for (NSDictionary *info in array) {
        if ([info[@"gamename"] isEqualToString:dict[@"gamename"]] && [info[@"server_id"] isEqualToString:dict[@"server_id"]] && [info[@"start_time"] isEqualToString:dict[@"start_time"]]) {
            return YES;
        }
    }
    return NO;
}


+ (void)addNotificationAtlist:(NSDictionary *)dict {

}

+ (NSDateFormatter *)dateFromatter {

    return [[NSDateFormatter alloc] init];
}

+ (NSInteger)year:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)month:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)day:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)hour:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)minute:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mm";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSInteger)second:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ss";
    NSString *year = [formatter stringFromDate:date];
    return year.integerValue;
}

+ (NSArray *)allNotifications {
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:notificaitons.count];
    for (UILocalNotification *notiy in notificaitons) {
        [array addObject:notiy.userInfo];
    }

    [array sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        if (((NSString *)obj1[@"start_time"]).integerValue > ((NSString *)obj2[@"start_time"]).integerValue) {
            return NSOrderedDescending;
        } else if (((NSString *)obj1[@"start_time"]).integerValue == ((NSString *)obj2[@"start_time"]).integerValue) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
    return array;
}


+ (NSString *)notificationIdentifierWithUserInfo:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@-%@-%@",dict[@"gamename"],dict[@"server_id"],dict[@"start_time"]];
}

+ (void)deletAllNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[]];
    } else {

    }
}

+ (void)deleteNotificationWith:(NSDictionary *)dict {

    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[[FFBoxModel notificationIdentifierWithUserInfo:dict]]];
    } else {
        NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if (!array || array.count <= 0)  return;
        for (UILocalNotification *notiy in array) {
            if ([[notiy.userInfo objectForKey:@"gamename"] isEqualToString:dict[@"gamename"]] &&
                [[notiy.userInfo objectForKey:@"server_id"] isEqualToString:dict[@"server_id"]] &&
                [[notiy.userInfo objectForKey:@"start_time"] isEqualToString:dict[@"start_time"]]) {
                //取消一个特定的通知
                //            [[UIApplication sharedApplication] cancelLocalNotification:notiy];
                [[UIApplication sharedApplication] cancelLocalNotification:notiy];
                syLog(@"删除!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                break;
            }
        }
    }
}

@end
