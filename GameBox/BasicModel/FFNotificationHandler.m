//
//  FFNotificationHandler.m
//  GameBox
//
//  Created by 燚 on 2018/7/3.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNotificationHandler.h"
#import <UserNotifications/UserNotifications.h>

@implementation FFNotificationHandler

#pragma mark - add local notification
+ (void)addNotificationWithDict:(NSDictionary *)dict Completion:(AddCompletion)completion {
    syLog(@"添加");
    syLog(@"dict === %@",dict);

    //    return;
    if (@available(iOS 10.0, *)) {
        NSString *time = dict[@"start_time"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];

        NSDateComponents *components = [[NSDateComponents alloc] init];

        components.year = [self year:date];
        components.month = [self month:date];
        components.day = [self day:date];
        components.hour = [self hour:date];
        components.minute = [self minute:date];
        components.second = [self second:date];

        UNCalendarNotificationTrigger *timeTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString stringWithFormat:@"%@ - %@服   即将开启",dict[@"gamename"],dict[@"server_id"]];
        content.body = [NSString stringWithFormat:@"%@ - %@ 即将开服，快快来游玩！希望你一统%@",dict[@"gamename"],dict[@"server_id"],dict[@"gamename"]];
        content.badge = @666;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = dict;
        NSString *requestIdentifier = [self notificationIdentifierWithUserInfo:dict];
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

/** 添加通知 */
+ (void)addNotificationWithTitle:(NSString *)title
                            Body:(NSString *)body
                            Time:(NSString *)time
                        UserInfo:(NSDictionary *)userInfo
               RequestIdentifier:(NSString *)requestIdentifier
                          Repeat:(BOOL)repeat
                      Completion:(AddNotiCompletion)completion {

    //    return;
    if (@available(iOS 10.0, *)) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];

        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = [self year:date];
        components.month = [self month:date];
        components.day = [self day:date];
        components.hour = [self hour:date];
        components.minute = [self minute:date];
        components.second = [self second:date];

        UNCalendarNotificationTrigger *timeTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:repeat];
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = title;
        content.body = body;
        content.badge = @666;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = userInfo;

        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                if (completion) {
                    completion(YES);
                }
            }
        }];
    } else {

    }


}








+ (NSString *)notificationIdentifierWithUserInfo:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"%@-%@-%@",dict[@"gamename"],dict[@"server_id"],dict[@"start_time"]];
}



#pragma mark - time
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

@end
