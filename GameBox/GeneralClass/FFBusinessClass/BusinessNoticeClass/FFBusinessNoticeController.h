//
//  FFBusinessNoticeController.h
//  GameBox
//
//  Created by 燚 on 2018/6/26.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"

typedef enum : NSUInteger {
    FFNoticeTypeBuy,
    FFNoticeTypeSell
} FFNoticeType;


typedef void(^ClickButtonBLock)(void);

@interface FFBusinessNoticeController : FFBasicViewController

@property (nonatomic, strong) ClickButtonBLock block;

+ (void)refreshNotice;

+ (void)showNoticeWithType:(FFNoticeType)type ClickButtonBLock:(ClickButtonBLock)block;




@end
