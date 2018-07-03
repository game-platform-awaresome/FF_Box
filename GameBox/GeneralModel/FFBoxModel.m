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
#import <objc/runtime.h>

#import "FFUserModel.h"
#import "FFStatisticsModel.h"

@interface FFBoxModel()

@property (nonatomic, strong) NSString *firstInstall;

@end



@implementation FFBoxModel

static FFBoxModel *model = nil;
+ (FFBoxModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFBoxModel alloc] init];
            model.firstInstall = @"0";
        }
    });
    return model;
}


#pragma mark - method
/** 盒子初始化  V2  */
+ (void)BoxInit {
    [self FirstInstall];  //获取初始化;
    Pamaras_Key((@[@"system",@"version",@"channel",@"maker",
                   @"machine_code",@"mobile_model",@"system_version",
                   @"mac",@"is_first_boot"]));
    SS_DICT;
    
    SS_SYSTEM;
    [dict setObject:[FFDeviceInfo cheackVersion] forKey:@"version"];
    SS_CHANNEL;
    [dict setObject:@"Apple" forKey:@"maker"];
    SS_DEVICEID;
    [dict setObject:[FFDeviceInfo phoneType] forKey:@"mobile_model"];
    [dict setObject:[FFDeviceInfo systemVersion] forKey:@"system_version"];
    [dict setObject:@" " forKey:@"mac"];
    [dict setObject:[self sharedModel].firstInstall forKey:@"is_first_boot"];

    SS_SIGN;

    syLog(@"init dict == %@",dict);

    syLog(@"box init start with first install == %@",[self sharedModel].firstInstall);
    [FFNetWorkManager postRequestWithURL:Map.BOX_INIT_V2 Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"box init v2 === %@",content);
        REQUEST_STATUS;
        if (success && status.integerValue == 1) {
            SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isFirstInstall");
            SAVEOBJECT_AT_USERDEFAULTS(@"1", @"uploadFirstInstallSuccess");
            [[self sharedModel] setAllPropertyWithDict:CONTENT_DATA];
        } else {
            syLog(@"box init failure");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                syLog(@"box reinit");
                [self BoxInit];
            });
        }
    }];
}

/** 第一次安装 */
+ (BOOL)FirstInstall {
    NSString *firstInstall = OBJECT_FOR_USERDEFAULTS(@"isFirstInstall");
    NSString *uploadFirstInstallSuccess = OBJECT_FOR_USERDEFAULTS(@"uploadFirstInstallSuccess");
    if (firstInstall && uploadFirstInstallSuccess) {
        [self sharedModel].firstInstall = @"0";
        return NO;
    } else {
        [self sharedModel].firstInstall = @"1";
        return YES;
    }
}

/** 盒子更新 */
- (void)boxUpdate {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:@"游戏有更新,前往更新" preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.update_url]];
    }]];
}

/** 是否是第一次登陆 */
+ (BOOL)isFirstLogin {
    NSString *isFirstGuide = OBJECT_FOR_USERDEFAULTS(@"isFirstGuide");
    if (isFirstGuide) {
        return NO;
    } else {
        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isFirstGuide");
        return YES;
    }
}



/** 添加公告 */
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


#pragma mark - 属性赋值
/** 获取类的所有属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType {
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([classType class], &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    return [mArray copy];
}

/** 对类的属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    WeakSelf;
    NSArray *names = [FFBoxModel getAllPropertyWithClass:self];
    if (dict != nil && dict.count > 0) {
        NSArray *mapArray = [dict allKeys];
        syLog(@"inpute property count %ld",mapArray.count);
        syLog(@"original property count %ld",names.count);
        NSMutableSet *namesSet = [NSMutableSet setWithArray:names];
        NSMutableSet *mapSet = [NSMutableSet setWithArray:mapArray];
        NSString *className = NSStringFromClass([weakSelf class]);
        if (namesSet.count > mapSet.count) {
            [namesSet minusSet:mapSet];
            syLog(@"%@ 没有添加的属性 %@",className, namesSet);
        } else {
            [mapSet minusSet:namesSet];
            syLog(@"%@ 多余的属性 %@",className, mapSet);
        }
    }
    if (dict == nil) {
        for (NSString *name in names) {
            [weakSelf setValue:nil forKey:name];
        }
    } else {
        for (NSString *name in names) {
            //如果字典中的值为空，赋值可能会出问题
            if (!name) {
                continue;
            }
            if(dict[name]) {
                [weakSelf setValue:dict[name] forKey:name];
            }
        }
    }
}






@end
