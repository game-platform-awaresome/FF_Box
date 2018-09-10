//
//  M185StaticModel.m
//  GameBox
//
//  Created by 燚 on 2018/9/7.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185StatisticsModel.h"
#import "FFMapModel.h"
#import "FFNetWorkManager.h"
#import "FFDeviceInfo.h"
#import "FFBoxHandler.h"


#define ssLog(format, ...)
//#define ssLog(format, ...) NSLog(format, ## __VA_ARGS__)



#define m185StatisticsModelUpload @"m185StatisticsModelUpload"
#define m185StatisticsModelMessage @"m185StatisticsModelMessage"

@interface M185StatisticsModel ()


@property (nonatomic, assign) NSUInteger currentNumber;



void uploadData(void);


@end




@implementation M185StatisticsModel




M185StatisticsModel * m185StatisticsModel(void) {
    static M185StatisticsModel * model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!model) {
            model = [[M185StatisticsModel alloc] init];
        }
    });
    return model;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _currentNumber = 0;
    }
    return self;
}

BOOL isUpload(void) {
    NSString *upload = OBJECT_FOR_USERDEFAULTS(m185StatisticsModelUpload);
    return upload ? YES : NO;
}




void m185Statistics(NSString * message , FFGameServersType type) {
    if (![FFBoxHandler sharedInstance].actstatic_enabled.boolValue) {
        return;
    }

    if (isUpload()) {
        return;
    }

    NSString *Prefix = (type == BT_SERVERS) ? @"BT_" : (type == ZK_SERVERS) ? @"折扣_" : (type == H5_SERVERS) ? @"H5_" : @"";

    message = [NSString stringWithFormat:@"%@%@",Prefix,message];

    ssLog(@"统计 === %@",message);
    [m185StatisticsModel().dataArray addObject:message];

    if (m185StatisticsModel().dataArray.count == 20) {
        uploadData();
        ssLog(@"统计够20条  == %@",[m185StatisticsModel().dataArray componentsJoinedByString:@","]);
    }

    if ([message hyb_isContainString:@"完成注册"]) {
        uploadData();
    }
}


void m185StatisticsUploadData(void) {
    uploadData();
}



void uploadData(void) {
    if (![FFBoxHandler sharedInstance].actstatic_enabled.boolValue) {
        return;
    }

    if (isUpload()) {
        return;
    }

    //先从缓存中获取是否有统计值
    NSString *upString = OBJECT_FOR_USERDEFAULTS(m185StatisticsModelMessage);

    //如果缓存中有值则,直接上传, 如果没有, 拼接当前内存中的统计, 并保存在缓存中, 然后上传.
    if (!upString) {
        if (m185StatisticsModel().dataArray.count > 0) {
            upString = [m185StatisticsModel().dataArray componentsJoinedByString:@","];
            SAVEOBJECT_AT_USERDEFAULTS(upString, m185StatisticsModelMessage);
        }
    }

    //如果上报的字符串长度小于1 返回.
    if (upString.length < 1) {
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:DeviceID forKey:@"machine_code"];
    [dict setObject:upString forKey:@"actions"];
    [dict setObject:BOX_SIGN(dict, (@[@"channel",@"machine_code",@"actions"])) forKey:@"sign"];

    ssLog(@"上报数据 == %@",dict);
    [FFNetWorkManager postRequestWithURL:Map.ACT_STATIC
                                  Params:dict
                                 Success:^(NSDictionary * _Nonnull content) {
                                     NSString *status = content[@"status"];
                                     if (status.integerValue == 1) {
                                         ssLog(@"上报数据成功 === %@",content);
                                         SAVEOBJECT_AT_USERDEFAULTS(@"1", m185StatisticsModelUpload);
                                     } else {
                                         ssLog(@"上报数据失败");
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             uploadData();
                                         });
                                     }

                                 }
                                 Failure:^(NSError * _Nonnull error) {
                                     ssLog(@"上报数据失败 == %@",error.localizedDescription);
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         uploadData();
                                     });
                                 }];

}





#pragma mark - getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _dataArray;
}









@end

















