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


@interface FFBusinessNoticeController : FFBasicViewController

+ (void)refreshNotice;

+ (void)showNoticeWithType:(FFNoticeType)type;




@end
