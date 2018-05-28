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

/** 初始化统计 */
void initStatisticsModel(void) {
    NSDictionary *dict = @{@"channel":Channel};
    [FFNetWorkManager postRequestWithURL:Map.BOX_INIT Params:@{@"channel":Channel,@"sign":BOX_SIGN(dict, (@[@"channel"]))} Success:^(NSDictionary * _Nonnull content) {
        syLog(@"统计  == =%@", content);
        NSString *status = content[@"status"];
        NSString *box_static = content[@"data"][@"box_static"];
        if (status.integerValue == 1) {
            statisticsModel.registState = (FFStatisticsState)box_static.integerValue;
        }
        [FFStatisticsModel startStatics];
    } Failure:^(NSError * _Nonnull error) {
        statisticsModel.isStartStatistics = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            initStatisticsModel();
        });
    }];
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
