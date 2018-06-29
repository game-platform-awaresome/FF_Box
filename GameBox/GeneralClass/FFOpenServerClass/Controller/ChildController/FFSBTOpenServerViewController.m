//
//  FFSBTOpenServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFSBTOpenServerViewController.h"

@interface FFSBTOpenServerViewController ()

@end

@implementation FFSBTOpenServerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, self.view.bounds.size.height - CGRectGetMaxY(self.selectView.frame));
    CGRect frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.frame.size.height);
    self.layout.itemSize = frame.size;
    self.todayOpenServerController.view.frame = frame;
    self.yesterdayOpenServeController.view.frame = frame;
    self.tomorrowOpenserverController.view.frame = frame;
}

@end
