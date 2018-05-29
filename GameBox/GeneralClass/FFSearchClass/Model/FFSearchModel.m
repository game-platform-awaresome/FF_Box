//
//  FFSearchModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSearchModel.h"
#import "FFMapModel.h"
#import "FFDeviceInfo.h"

@implementation FFSearchModel

/** 热门游戏 */ 
+ (void)hotGameWithPlatform:(NSUInteger)platform Completion:(void (^)(NSDictionary *, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:[NSString stringWithFormat:@"%lu",platform] forKey:@"platform"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_GETHOT Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 搜索游戏 */
+ (void)searchGameWithKeyword:(NSString *)keyword Completion:(void (^)(NSDictionary * _Nullable, BOOL))completion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:@"2" forKey:@"system"];
    [dict setObject:keyword forKey:@"keyword"];
    [FFNetWorkManager postRequestWithURL:Map.GAME_SEARCH_LIST Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}

/** 获取路径 */
+ (NSString *)getPlistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [path stringByAppendingPathComponent:@"searchPlist"];
    return plistPath;
}

/** 获取搜索历史 */
+ (NSArray *)getSearchHistory {
    NSArray *array = [NSArray arrayWithContentsOfFile:[FFSearchModel getPlistPath]];
    return array;
}

/** 添加历史记录 */
+ (void)addSearchHistoryWithKeyword:(NSString *)keyword {
    NSMutableArray *array = [[FFSearchModel getSearchHistory] mutableCopy];

    if (!array) {
        array = [NSMutableArray array];
        [array addObject:keyword];
    } else {
        NSInteger i = 0;
        for (; i < array.count; i++) {
            if ([array[i] isEqualToString:keyword]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:0];
                [array writeToFile:[FFSearchModel getPlistPath] atomically:YES];
                break;
            }
        }

        if (i < array.count) {
            return;
        }

        if (array.count >= 50) {
            [array replaceObjectAtIndex:0 withObject:keyword];
        } else {
            [array insertObject:keyword atIndex:0];
        }
    }

    [array writeToFile:[FFSearchModel getPlistPath] atomically:YES];
}

/** 清楚历史记录 */
+ (BOOL)clearSearchHistory {
    NSArray *array = nil;
    [array writeToFile:[FFSearchModel getPlistPath] atomically:YES];

    BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:[FFSearchModel getPlistPath] error:nil];

    return delete;

}

#pragma mark =====================================================
/** 获取礼包路径 */
+ (NSString *)getGiftPlistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [path stringByAppendingPathComponent:@"packageSearchPlist"];
    return plistPath;
}

/** 获取礼包搜索历史 */
+ (NSArray *)getGiftSearchHistory {
    NSArray *array = [NSArray arrayWithContentsOfFile:[FFSearchModel getGiftPlistPath]];
    return array;
}

/** 添加礼包历史记录 */
+ (void)addGiftSearchHistoryWithKeyword:(NSString *)keyword {
    NSMutableArray *array = [[FFSearchModel getGiftSearchHistory] mutableCopy];

    if (!array) {
        array = [NSMutableArray array];
        [array addObject:keyword];
    } else {
        NSInteger i = 0;
        for (; i < array.count; i++) {
            if ([array[i] isEqualToString:keyword]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:0];
                [array writeToFile:[FFSearchModel getGiftPlistPath] atomically:YES];
                break;
            }
        }
        if (i < array.count) {
            return;
        }
        if (array.count >= 50) {
            [array replaceObjectAtIndex:0 withObject:keyword];
        } else {
            [array insertObject:keyword atIndex:0];
        }
    }

    [array writeToFile:[FFSearchModel getGiftPlistPath] atomically:YES];
}

/** 清除礼包历史记录 */
+ (BOOL)clearGiftSearchHistory {
    NSArray *array = nil;
    [array writeToFile:[FFSearchModel getGiftPlistPath] atomically:YES];

    BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:[FFSearchModel getGiftPlistPath] error:nil];

    return delete;

}


+ (void)UnreadMessagesWithUid:(NSString *)uid Completion:(void (^)(NSDictionary *, BOOL))completion {
    if (uid == nil || uid.length < 1) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:Channel forKey:@"channel"];
    [dict setObject:(BOX_SIGN(dict, (@[@"uid",@"channel"]))) forKey:@"sign"];
    [FFNetWorkManager postRequestWithURL:Map.MESSAGE_UNREAD Params:dict Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        REQUEST_COMPLETION;
    }];
}


@end
