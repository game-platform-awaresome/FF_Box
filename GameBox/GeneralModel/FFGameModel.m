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
#import "FFUserModel.h"


#define SS_SERVER_TYPE [dict setObject:[NSString stringWithFormat:@"%ld",serverType] forKey:@"platform"]

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

#pragma mark - game servers
/**
 * 主页的游戏服列表
 * @parma type 服务器类型;
 * @parma page 页数.起始页为1;
 */
+ (void)GameServersWithType:(FFGameServersType)serverType Page:(NSString *)page Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    [dict setObject:page forKey:@"page"];
    SS_CHANNEL;
    SS_SERVER_TYPE;
    SS_SYSTEM;
    [FFNetWorkManager postRequestWithURL:Map.GAME_NEWINDEX Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - game list with type (新游/热门/排行)
/** 游戏列表 : 类型 */
+ (void)gameListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType GameType:(NSString *)gameType Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(5);
    [dict setObject:page forKey:@"page"];           //页数
    SS_CHANNEL;                                     //渠道
    SS_SYSTEM;                                      //系统
    SS_SERVER_TYPE;                                 //服务器类型
    [dict setObject:gameType forKey:@"type"];       //游戏类型
    [self postRequestWithURL:[self map].GAME_TYPE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 新游列表 */
+ (void)newGameListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    [self gameListWithPage:page ServerType:serverType GameType:@"0" Completion:completion];
}

/** 排行榜 */
+ (void)rankGameListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    [self gameListWithPage:page ServerType:serverType GameType:@"2" Completion:completion];
}

#pragma mark - open servers
/**
 * 开服表
 * @parma page          页数.起始页为1;
 * @parma serverType    服务器类型;
 * @parma openType      开服的时间
 */
+ (void)openServersListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType OpenType:(FFOpenServerType)openType Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(5);
    SS_SYSTEM;
    SS_CHANNEL;
    SS_SERVER_TYPE;
    [dict setObject:[NSString stringWithFormat:@"%ld",openType] forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.OPEN_SERVER Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/**
 * BT 服开服表
 * @parma page          页数.起始页为1;
 * @parma openType      开服的时间
 */
+ (void)BTopenServersListWithPage:(NSString *)page OpenType:(FFOpenServerType)openType Completion:(RequestCallBackBlock)completion {
    [FFGameModel openServersListWithPage:page ServerType:BT_SERVERS OpenType:openType Completion:completion];
}

/**
 * 折扣 服开服表
 * @parma page          页数.起始页为1;
 * @parma openType      开服的时间
 */
+ (void)ZKopenServersListWithPage:(NSString *)page OpenType:(FFOpenServerType)openType Completion:(RequestCallBackBlock)completion {
    [FFGameModel openServersListWithPage:page ServerType:ZK_SERVERS OpenType:openType Completion:completion];
}

/**
 * 单一游戏开服列表
 */
+ (void)openServersWithGameID:(NSString *)gameID Completion:(RequestCallBackBlock)completion {
    [FFNetWorkManager postRequestWithURL:Map.GAME_OPEN_SERVER Params:@{@"gid":gameID} Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - Game details infomation
/**
 * 游戏详情
 * @parma gameID        游戏 ID
 */
+ (void)gameDetailsWithGameID:(NSString *)gameID Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    [dict setObject:gameID forKey:@"gid"];
    [dict setObject:(([FFUserModel currentUser].username) ?
                     [FFUserModel currentUser].username : @"") forKey:@"username"];
    SS_SYSTEM;
    SS_CHANNEL;
    [FFNetWorkManager postRequestWithURL:Map.GAME_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - collection game
/**
 * 游戏收藏
 * @parma gameID        游戏 ID
 */
+ (void)collectionGameWithGameID:(NSString *)gameID CollectionType:(FFCollectionType)collectionType Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    [dict setObject:gameID forKey:@"gid"];
    [dict setObject:[NSString stringWithFormat:@"%ld",collectionType] forKey:@"type"];
    SS_SYSTEM;
    [dict setObject:[FFUserModel currentUser].username forKey:@"username"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_COLLECT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - game classify
/**
 * 游戏分类
 * @parma page          页数.起始页为1;
 * @parma serverType    服务器类型
 */
+ (void)gameClassifyListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    SS_CHANNEL;
    SS_SYSTEM;
    [dict setObject:page forKey:@"page"];
    SS_SERVER_TYPE;
    [FFNetWorkManager postRequestWithURL:Map.GAME_CLASS Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/**
 * 单个游戏分类详情
 * @parma classifyID    分类 ID;
 * @parma serverType    服务器类型
 * @parma page          页数.起始页为1;
 */
+ (void)gameclassifyWithClassifyID:(NSString *)classifyID Page:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(5);
    [dict setObject:classifyID forKey:@"classId"];
    SS_CHANNEL;
    SS_SYSTEM;
    SS_SERVER_TYPE;
    [dict setObject:page forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_CLASS_INFO Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - get channel download game url
/**
 * 获取子渠道下载地址
 * @parma gameTag        游戏的 TAG 标签
 */
+ (void)getGameDownloadUrlWithTag:(NSString *)gameTag Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(3);
    SS_SYSTEM;
    SS_CHANNEL;
    [dict setObject:gameTag forKey:@"tag"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_CHANNEL_DOWNLOAD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - game guide list
/**
 * 游戏攻略
 */
+ (void)gameGuideListWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    SS_SYSTEM;
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:page forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.INDEX_ARTICLE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}








@end













