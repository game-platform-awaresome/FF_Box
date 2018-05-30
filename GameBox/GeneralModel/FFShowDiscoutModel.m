//
//  FFShowDiscoutModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/30.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFShowDiscoutModel.h"

static FFShowDiscoutModel *model = nil;
@implementation FFShowDiscoutModel

+ (FFShowDiscoutModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFShowDiscoutModel alloc] init];
            model.showDiscount = @"0";
        }
    });
    return model;
}


- (void)setShowDiscount:(NSString *)showDiscount {
    NSString *type = [NSString stringWithFormat:@"%@",showDiscount];
    _showDiscount = [NSString stringWithFormat:@"%u",type.boolValue];
    if (self.block) {
        self.block();
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:ShowDiscountNotificationName object:nil];
}

+ (BOOL)showDiscount {
    return [self sharedModel].showDiscount.boolValue;
}








@end
