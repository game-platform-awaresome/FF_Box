//
//  FFGameModel.m
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameModel.h"
#import "FFDeviceInfo.h"
#import "FFMapModel.h"

@implementation FFGameModel

+ (FFMapModel *)map {
    return [FFMapModel map];
}

/** recomment Game list */
+ (void)recommentGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //页数
    [dict setObject:page forKey:@"page"];
    //渠道ID
    [dict setObject:Channel forKey:@"channel"];
    //设备ID
    [dict setObject:@"2" forKey:@"system"];
    [self postRequestWithURL:[self map].GAME_INDEX Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION
    }];
}

/** new game list */
+ (void)newGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    
}






@end












