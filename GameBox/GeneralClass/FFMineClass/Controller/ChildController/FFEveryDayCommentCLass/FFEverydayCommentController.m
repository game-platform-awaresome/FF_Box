//
//  FFEverydayCommentController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFEverydayCommentController.h"

@interface FFEverydayCommentController ()

@end

@implementation FFEverydayCommentController

- (FFGameViewController *)init {
    [FFEverydayCommentController getCommentGame];
    return (FFEverydayCommentController *)[FFGameViewController sharedController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
}

+ (void)getCommentGame {
    [[FFGameViewController sharedController] startWaiting];
    [FFGameModel rankGameListWithPage:@"1" ServerType:BT_SERVERS Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [[FFGameViewController sharedController] stopWaiting];
        if (success) {
            NSArray *array = content[@"data"];
            [self setGameDict:array.firstObject];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

+ (void)setGameDict:(NSDictionary *)dict {
    [FFGameViewController sharedController].gid = dict[@"id"];
}



@end
