//
//  FFApplyRebateModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFApplyUserModel : NSObject

@property (nonatomic, strong) NSString *all;
@property (nonatomic, strong) NSString *roleID;
@property (nonatomic, strong) NSString *roleName;
@property (nonatomic, strong) NSString *serverID;

@end



@interface FFApplyRebateModel : NSObject


@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *gameCoin;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) FFApplyUserModel *currentUserModel;
@property (nonatomic, strong) NSArray<FFApplyUserModel *> *userArray;


+ (NSMutableArray<FFApplyRebateModel *> *)modelArrayWithData:(id)data;



@end






