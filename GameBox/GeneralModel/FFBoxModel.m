//
//  FFBoxModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBoxModel.h"
#import <UIKit/UIKit.h>

#import <UserNotifications/UserNotifications.h>

@implementation FFBoxModel



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
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(Completion)completion {
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
