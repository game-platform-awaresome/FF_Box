//
//  FFBasicSSTableViewController.h
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"

@interface FFBasicSSTableViewController : FFBasicTableViewController

#pragma mark -
/** BasicScrollSelectController use */
@property (assign, nonatomic) BOOL canScroll;
//判断手指是否离开
@property (nonatomic, assign) BOOL isTouch;

@property (nonatomic, assign) BOOL canRefresh;

- (void)refresh;


@end