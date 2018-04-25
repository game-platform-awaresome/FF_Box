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
        REQUEST_COMPLETION;
    }];
}

//=======================================================================================//
/** game list with type */
+ (void)gameListWithPage:(NSString *)page GameType:(NSString *)gameType Completion:(RequestCallBackBlock)completion {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //页数
    [dict setObject:page forKey:@"page"];
    //渠道
    [dict setObject:Channel forKey:@"channel"];
    //系统
    [dict setObject:@"2" forKey:@"system"];
    //游戏类型
    [dict setObject:gameType forKey:@"type"];

    /**  */
    [self postRequestWithURL:[self map].GAME_TYPE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** new game list */
+ (void)newGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    [self gameListWithPage:page GameType:@"0" Completion:completion];
}

/** rank game list */
+ (void)rankGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    [self gameListWithPage:page GameType:@"2" Completion:completion];
}

//=======================================================================================//
+ (void)gameGuideListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:page forKey:@"page"];
    [self postRequestWithURL:[self map].INDEX_ARTICLE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

//=======================================================================================//
/** classify game list */ 
+ (void)classifyGameListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:page forKey:@"page"];
    [self postRequestWithURL:[self map].GAME_CLASS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** classify with id */
+ (void)classifyWithID:(NSString *)classifyID Page:(NSString *)page Completion:(RequestCallBackBlock)completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:classifyID forKey:@"classId"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:page forKey:@"page"];
    [self postRequestWithURL:[self map].GAME_CLASS_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}



@end












