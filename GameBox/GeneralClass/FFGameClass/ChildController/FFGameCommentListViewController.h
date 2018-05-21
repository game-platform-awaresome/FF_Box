//
//  FFGameCommentListViewController.h
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"

@interface FFGameCommentListViewController : FFBasicViewController

/** BasicScrollSelectController use */
@property (assign, nonatomic) BOOL canScroll;
//判断手指是否离开
@property (nonatomic, assign) BOOL isTouch;

@end
