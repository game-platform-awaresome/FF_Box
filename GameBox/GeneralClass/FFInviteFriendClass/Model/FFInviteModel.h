//
//  FFInviteModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFNetWorkManager.h"

typedef enum : NSUInteger {
    TodayFirst,
    YesterdatFirst,
} First_list_enum;

typedef void(^FFInviewRefresCompletion)(BOOL success,First_list_enum listEnum);
typedef void(^FFinviteRewardCompletion)(BOOL success);
typedef void(^FFInviteUserRankingList)(BOOL success, NSDictionary *content);
typedef void(^FFInviewNotesCompleteBlock)(BOOL success, NSDictionary *content);

@interface FFInviteModel : FFNetWorkManager


@property (nonatomic, strong) NSArray *todayList;
@property (nonatomic, strong) NSArray *yesterDayList;
@property (nonatomic, strong) FFInviewRefresCompletion completion;
@property (nonatomic, strong) FFinviteRewardCompletion rewardBlock;
@property (nonatomic, strong) FFInviteUserRankingList userRankingList;

+ (instancetype)sharedModel;

- (void)refreshList;

- (void)gotInviteReward;

- (void)getUserRankingListWithType:(NSString *)type;

+ (void)getNoticeWithBlock:(FFInviewNotesCompleteBlock)completion;


@end
