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
#import <CommonCrypto/CommonDigest.h>

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
    [self postRequestWithURL:[self map].NEW_GAME_TYPE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 新游列表 */
+ (void)newGameListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    [self gameListWithPage:page ServerType:serverType GameType:@"1" Completion:completion];
}

/** 排行榜 */
+ (void)rankGameListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    [self gameListWithPage:page ServerType:serverType GameType:@"3" Completion:completion];
}

#pragma makr - bate and reservation (内测和预约游戏)
/** 内测或者预约游戏 */
+ (void)betaAndReservationGameWithPage:(NSString *)page Type:(FFBetaOrReservationType)type Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(5);
    [dict setObject:page forKey:@"page"];           //页数
    SS_CHANNEL;                                     //渠道
    SS_SYSTEM;                                      //系统
    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)type] forKey:@"type"];       //游戏类型
    [self postRequestWithURL:[self map].NEW_GAME_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
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

#pragma mark - game guide and activity list
+ (void)gameGuideAndActivityWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Type:(FFActivityType)type Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    SS_SYSTEM;
    [dict setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:page forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.INDEX_ARTICLE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}
/**
 * 游戏攻略
 */
+ (void)gameGuideListWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    [self gameGuideAndActivityWithPage:page ServerType:serverType Type:FFGuide Completion:completion];
}

/**
 * 游戏活动
 */
+ (void)gameActivityWithPage:(NSString *)page ServerType:(FFGameServersType)serverType Completion:(RequestCallBackBlock)completion {
    Pamaras_Key(@[@"platform"]);
    Mutable_Dict(2);
    [dict setObject:[NSString stringWithFormat:@"%lu",serverType] forKey:@"platform"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.EXCLUSIVE_ACT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        syLog(@"activity ====== %@",content);
        NEW_REQUEST_COMPLETION;;
    }];
}


/** 单一游戏攻略 */
+ (void)gameGuideWithGameID:(NSString *)gameID Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"1" forKey:@"type"];
    SS_CHANNEL;
    [dict setObject:@"1" forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_GONGLUE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/**
 * 单一游戏活动
 */
+ (void)gameActivityWithGameID:(NSString *)gameID
                    Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(4);
    if (gameID == nil) {
        return;
    }
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"2" forKey:@"type"];
    SS_CHANNEL;
    [dict setObject:@"1" forKey:@"page"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_GONGLUE Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - gift (游戏礼包)
/** 根据游戏 id 获取游戏礼包列表 */
+ (void)gameGiftWithGameID:(NSString *)gameID Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(5);
    [dict setObject:gameID forKey:@"game_id"];
    [dict setObject:@"1" forKey:@"page"];
    SS_CHANNEL;
    [dict setObject:[FFUserModel currentUser].username forKey:@"username"];
    [dict setObject:DeviceID forKey:@"device_id"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_PACK Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

+ (void)getGameGiftWithPackageID:(NSString *)packageID Completion:(RequestCallBackBlock)completion {
    Mutable_dict;

    [dict setObject:[FFUserModel currentUser].username forKey:@"username"];
    [dict setObject:[FFDeviceInfo DeviceIP] forKey:@"ip"];
    [dict setObject:@"2" forKey:@"terminal_type"];
    [dict setObject:packageID forKey:@"pid"];
    [dict setObject:[FFDeviceInfo deviceID] forKey:@"device_id"];

    NSString *signStr = [NSString stringWithFormat:@"device_id%@ip%@pid%@terminal_type2username%@",[FFDeviceInfo deviceID],[FFDeviceInfo DeviceIP],packageID,[FFUserModel currentUser].username];

    const char *cstr = [signStr cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *data = [NSData dataWithBytes:cstr length:signStr.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *cha1str = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [cha1str appendFormat:@"%02x", digest[i]];

    NSString *sign = [cha1str uppercaseString]; 
    [dict setObject:sign forKey:@"sign"];
    [dict setObject:Channel forKey:@"channel_id"];

    [FFNetWorkManager postRequestWithURL:Map.PACKS_LINGQU Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}
/**
 * 我的礼包
 */
+ (void)getUserGiftPackageWithPage:(NSString *)page Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(3);
    [dict setObject:Channel forKey:@"channel_id"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:CURRENT_USER.username forKey:@"username"];
    [FFNetWorkManager postRequestWithURL:Map.USER_PACK Params:dict Completion:^(NSDictionary *content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

#pragma mark - get game comment list
/**
 * 游戏评论列表
 */
+ (void)gameCommentListWithGameID:(NSString *)gameID Page:(NSString *)page Completion:(RequestCallBackBlock)completion {
    Mutable_Dict(6);
    Pamaras_Key((@[@"uid",@"channel",@"dynamics_id",@"type",@"page"]));
    [dict setObject:[FFUserModel currentUser].uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:gameID forKey:@"dynamics_id"];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:page forKey:@"page"];
    [dict setObject:@"2" forKey:@"comment_type"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.COMMENT_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - mission center
/**
 * 任务中心
 */
+ (void)missionCenterInfoCompletion:(RequestCallBackBlock)completion {
    Pamaras_Key((@[@"uid",@"channel"]));
    Mutable_Dict(3);
    [dict setObject:CURRENT_USER.uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.TASK_CENTER Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}

#pragma mark - promise
/** 185游戏承诺 */
+ (void)gamePromiseCompletion:(RequestCallBackBlock _Nullable)completion {
    Pamaras_Key((@[@"channel"]));
    Mutable_Dict(2);
    [dict setObject:Channel forKey:@"channel"];
    SS_SIGN;
    [FFNetWorkManager postRequestWithURL:Map.APP_PROMISE Params:dict Completion:^(NSDictionary *content, BOOL success) {
        NEW_REQUEST_COMPLETION;
    }];
}






@end













