//
//  FFSearchModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFSearchModel : NSObject

/** 搜索热门 */
+ (void)hotGameWithCompletion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 搜索游戏 */
+ (void)searchGameWithKeyword:(NSString *)keyword Completion:(void (^)(NSDictionary * content, BOOL success))completion;

/** 获取搜索历史 */
+ (NSArray *)getSearchHistory;

/** 添加搜索记录 */
+ (void)addSearchHistoryWithKeyword:(NSString *)keyword;

/** 清空搜索记录 */
+ (BOOL)clearSearchHistory;

/** 礼包搜索记录 */
+ (NSArray *)getGiftSearchHistory;

/** 添加礼包搜索记录 */
+ (void)addGiftSearchHistoryWithKeyword:(NSString *)keyword;

/** 清空搜索记录 */
+ (BOOL)clearGiftSearchHistory;

/** 未读消息 */
+ (void)UnreadMessagesWithUid:(NSString *)uid Completion:(void (^)(NSDictionary * content, BOOL success))completion;




@end
