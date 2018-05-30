//
//  FFShowDiscoutModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/30.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ShowDiscountNotificationName @"ShowDiscountNotificationName"

typedef void(^RefreshBlock)(void);

@interface FFShowDiscoutModel : NSObject

@property (nonatomic, strong) NSString *showDiscount;
@property (nonatomic, strong) RefreshBlock block;


+ (FFShowDiscoutModel *)sharedModel;

+ (BOOL)showDiscount;



@end
