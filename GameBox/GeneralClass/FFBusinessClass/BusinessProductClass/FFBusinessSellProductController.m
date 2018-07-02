//
//  FFBusinessSellProductController.m
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSellProductController.h"

@interface FFBusinessSellProductController ()

@end

@implementation FFBusinessSellProductController


+ (instancetype)initwithDict:(NSDictionary *)dict {
    FFBusinessSellProductController * controller = [self init];
    controller.productInfo = dict;
    controller.isEdit = YES;
    controller.postType = YES;
    controller.gameCollectionView.imagesArray = nil;
    controller.tradeCollectionView.imagesArray = nil;
    return controller;
}










@end









