//
//  FFGameDetailGuideModel.m
//  GameBox
//
//  Created by 燚 on 2018/8/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailGuideModel.h"

FFGameDetailGuideModel *_gameDetailGuideModel = nil;
@implementation FFGameDetailGuideModel


+ (FFGameDetailGuideModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_gameDetailGuideModel) {
            _gameDetailGuideModel = [[FFGameDetailGuideModel alloc] init];
        }
    });
    return _gameDetailGuideModel;
}



@end





