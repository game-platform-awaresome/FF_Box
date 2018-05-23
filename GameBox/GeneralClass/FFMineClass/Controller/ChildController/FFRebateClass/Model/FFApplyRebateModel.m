//
//  FFApplyRebateModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFApplyRebateModel.h"

@implementation FFApplyUserModel

+ (FFApplyUserModel *)modelWithDict:(NSDictionary *)dict {
    FFApplyUserModel *model = [[FFApplyUserModel alloc] init];
    if ([dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        model.all = [NSString stringWithFormat:@"%@",dict[@"all"]];
        model.roleID = [NSString stringWithFormat:@"%@",dict[@"roleid"]];
        model.roleName = [NSString stringWithFormat:@"%@",dict[@"rolename"]];
        model.serverID = [NSString stringWithFormat:@"%@",dict[@"serverID"]];
    }

    return model;
}


@end


@implementation FFApplyRebateModel


+ (NSMutableArray<FFApplyRebateModel *> *)modelArrayWithData:(id)data {
    NSMutableArray *array;
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *dataArray = data;
        array = [NSMutableArray arrayWithCapacity:dataArray.count];

        for (NSDictionary *dict in dataArray) {
            [array addObject:[self modeWithDict:dict]];
        }

    } else {
        array = nil;
    }



    return array;
}

+ (FFApplyRebateModel *)modeWithDict:(NSDictionary *)dict {
    FFApplyRebateModel *model = [[FFApplyRebateModel alloc] init];
    if ([dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        model.amount = [NSString stringWithFormat:@"%@",dict[@"amount"]];
        model.appID = [NSString stringWithFormat:@"%@",dict[@"appid"]];
        model.gameCoin = [NSString stringWithFormat:@"%@",dict[@"game_coin"]];
        model.gameName = [NSString stringWithFormat:@"%@",dict[@"gamename"]];
        [model setUserArray:dict[@"user"]];
    }
    return model;
}


#pragma mark - setter
- (void)setUserArray:(NSArray *)userArray {
    NSMutableArray *array;
    if ([userArray isKindOfClass:[NSArray class]] && userArray.count > 0) {
        array = [NSMutableArray arrayWithCapacity:userArray.count];
        for (NSDictionary *dict in userArray) {
            [array addObject:[FFApplyUserModel modelWithDict:dict]];
        }
    }
    _userArray = [array copy];
    if (_userArray && _userArray.count > 0) {
        self.currentUserModel = _userArray[0];
    }
}





@end









