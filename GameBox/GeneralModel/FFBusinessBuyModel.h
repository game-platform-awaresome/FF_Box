//
//  FFBusinessBuyModel.h
//  GameBox
//
//  Created by 燚 on 2018/6/26.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFBusinessModel.h"

@interface FFBusinessBuyModel : NSObject


@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *productAmountLimit;


+ (instancetype)sharedModel;

+ (void)cancelOrder:(RequestCallBackBlock)block;


@end
