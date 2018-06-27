//
//  FFBusinessBuyModel.m
//  GameBox
//
//  Created by 燚 on 2018/6/26.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBuyModel.h"

@implementation FFBusinessBuyModel



static FFBusinessBuyModel *model = nil;
+ (instancetype)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFBusinessBuyModel alloc] init];
            model.productAmountLimit = @"20";
        }
    });
    return model;
}


+ (void)cancelOrder:(RequestCallBackBlock)block {
    [FFBusinessModel cancelPaymentWithOrderID:[FFBusinessBuyModel sharedModel].orderID Completion:block];
}


- (void)setProductAmountLimit:(NSString *)productAmountLimit {
    productAmountLimit = [NSString stringWithFormat:@"%@",productAmountLimit];
    if (productAmountLimit.integerValue > 0) {
        _productAmountLimit = productAmountLimit;
    } else {
        _productAmountLimit = @"20";
    }
}


@end









