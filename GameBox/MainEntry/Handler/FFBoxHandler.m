//
//  FFBoxHandler.m
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBoxHandler.h"
#import "FFDeviceInfo.h"
#import "FFMapModel.h"
#import <objc/runtime.h>
#import "FFStatisticsModel.h"
#import <UIKit/UIKit.h>
#import <SDWebImageManager.h>
#import "FFUserModel.h"

@interface FFBoxHandler ()

@property (nonatomic, strong) NSString *firstInstall;

@end

static FFBoxHandler *instance = nil;
@implementation FFBoxHandler

/** 单例 */
+ (FFBoxHandler *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[FFBoxHandler alloc] init];
        }
    });
    return instance;
}


#pragma mark - 属性赋值
////(这个跟基类的有点不同 , 基类的是全部转成 string 或者 对有些 UID 和 ID 关键字进行了处理)
///后续可以优化下
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
    NSArray *names = [FFBoxHandler getAllPropertyWithClass:self];
    if (dict != nil && dict.count > 0) {
        NSArray *mapArray = [dict allKeys];
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

#pragma mark - setter
/** 盒子更新 */
- (void)setUpdate_url:(NSString *)update_url {
    if (![update_url isKindOfClass:[NSNull class]]) {
        _update_url = [NSString stringWithFormat:@"%@",update_url];
        syLog(@"\n-----------------\n盒子有更新,地址 == %@\n-----------------\n",_update_url);
        [self boxUpdate];
    } else {
        syLog(@"\n-----------------\n盒子无更新\n-----------------\n");
    }
}
/** 启动页 */
- (void)setStart_page:(NSString *)start_page {
    if ([start_page isKindOfClass:[NSNull class]]) {
        syLog(@"\n-----------------\n无广告页\n-----------------\n");
    } else {
        _start_page = [NSString stringWithFormat:@"%@",start_page];
        syLog(@"\n-----------------\n保存广告页\n-----------------\n");
        [FFBoxHandler saveAdvertisingImage:_start_page];
    }
}
/** 启动页链接 */
- (void)setStart_page_link:(NSString *)start_page_link {
    if ([start_page_link isKindOfClass:[NSNull class]]) {
        syLog(@"\n-----------------\n无广告页链接\n-----------------\n");
    } else {
        _start_page_link = [NSString stringWithFormat:@"%@",start_page_link];
        syLog(@"\n-----------------\n保存广告页链接\n-----------------\n");
    }
}
/** 盒子通知 */
- (void)setApp_notice:(NSDictionary *)app_notice {
    if ([app_notice isKindOfClass:[NSDictionary class]]) {
        syLog(@"\n-----------------\n发布公告\n-----------------\n");
//        [FFBoxModel addAppAnnouncementWith:app_notice];
    } else {
        syLog(@"\n-----------------\n没有公告\n-----------------\n");
    }
}
/** 统计开关 */
- (void)setBox_static:(NSString *)box_static {
    if (box_static) {
        _box_static = [NSString stringWithFormat:@"%@",box_static];
        syLog(@"\n-----------------\n开启统计\n-----------------\n");
        BoxinitStatisticsModel(_box_static.integerValue);
    }
}
/** QQ 资讯 */
- (void)setQq_zixun:(NSString *)qq_zixun {

}
/** 折扣开关 */
- (void)setDiscount_enabled:(NSString *)discount_enabled {
    syLog(@"\n-----------------\n折扣服开关 : %@\n-----------------\n",discount_enabled);
    _discount_enabled = [NSString stringWithFormat:@"%@",discount_enabled];
}
/** 交易系统开关 */
- (void)setBusiness_enbaled:(NSString *)business_enbaled {

    _business_enbaled = [NSString stringWithFormat:@"%@",business_enbaled];
    syLog(@"\n-----------------\n交易系统开关 : %@\n-----------------\n",business_enbaled);

}

#pragma mark - method
/** 盒子初始化 */
+ (void)boxInitWithSuccess:(BoxSuccessBlock)successBlock Failure:(BoxFailureBlock)failureBlock {
    [self FirstInstall];
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
    [dict setObject:[self sharedInstance].firstInstall forKey:@"is_first_boot"];
    SS_SIGN;
    syLog(@"init dict == %@",dict);
    syLog(@"box init start with first install == %@",[self sharedInstance].firstInstall);
    [FFNetWorkManager postRequestWithURL:Map.BOX_INIT_V2 Params:dict Success:^(NSDictionary * _Nonnull content) {
        REQUEST_STATUS;
        if (status.integerValue == 1) {
            [[self sharedInstance] setAllPropertyWithDict:CONTENT_DATA];
            SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isFirstInstall");
            SAVEOBJECT_AT_USERDEFAULTS(@"1", @"uploadFirstInstallSuccess");
            if (successBlock) {
                successBlock(content);
            }
        } else {
            if (failureBlock) failureBlock(content);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                syLog(@"box init failure and reinit == %@",content[@"msg"]);
                [self boxInitWithSuccess:successBlock Failure:failureBlock];
            });
        }
    } Failure:^(NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(@{@"msg":error.localizedDescription});
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            syLog(@"box init failure and reinit == %@",error.localizedDescription);
            [self boxInitWithSuccess:successBlock Failure:failureBlock];
        });

    }];
}

/** 第一次安装 */
+ (BOOL)FirstInstall {
    NSString *firstInstall = OBJECT_FOR_USERDEFAULTS(@"isFirstInstall");
    NSString *uploadFirstInstallSuccess = OBJECT_FOR_USERDEFAULTS(@"uploadFirstInstallSuccess");
    if (firstInstall && uploadFirstInstallSuccess) {
        [self sharedInstance].firstInstall = @"0";
        return NO;
    } else {
        [self sharedInstance].firstInstall = @"1";
        return YES;
    }
}

//- (void)setFirstInstall:(NSString *)firstInstall {
//    _firstInstall = firstInstall;
////    SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isFirstInstall");
//}

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

/** 是否加载过蒙版 */
+ (BOOL)isAddmaskView {
    NSString *addMaskView = OBJECT_FOR_USERDEFAULTS(@"isAddmaskView");
    if (addMaskView) {
        return NO;
    } else {
        SAVEOBJECT_AT_USERDEFAULTS(@"1", @"isAddmaskView");
        return YES;
    }
}

/** 盒子更新 */
- (void)boxUpdate {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:@"游戏有更新,前往更新" preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.update_url]];
        }]];
    });
}

/** 保存广告图片 */
const NSString *AdvertisingKey = @"AdvertisingKey";
+ (void)saveAdvertisingImage:(NSString *)url {
    NSString *hasAdvertisingImage = OBJECT_FOR_USERDEFAULTS(@"hasAdvertisingImage");
    if ([url isKindOfClass:[NSString class]] && url.length > 0) {
        if (![hasAdvertisingImage isEqualToString:url]) {
            [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:(SDWebImageDownloaderLowPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (finished) {
                    [data writeToFile:[self AdvertisingImagePath] atomically:YES];
                    SAVEOBJECT_AT_USERDEFAULTS(url, @"hasAdvertisingImage");
                }
            }];
        } else {
            syLog(@"\n-----------------\n广告页已存在\n-----------------\n");
        }
    } else {
        if (hasAdvertisingImage) {
            [[NSFileManager defaultManager] removeItemAtPath:[self AdvertisingImagePath] error:nil];
        }
    }
}
/** 获取广告页本地缓存 */
+ (NSData *)getAdvertisingImage {
    NSData *data = [NSData dataWithContentsOfFile:[self AdvertisingImagePath]];
    return data;
}
/** 广告业到本地 */
+ (NSString *)AdvertisingImagePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"AdvertisingImage"];
    return filePath;
}

/** 自动登录 */
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



@end

