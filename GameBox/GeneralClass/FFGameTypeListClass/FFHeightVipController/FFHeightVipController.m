//
//  FFHeightVipController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFHeightVipController.h"

@interface FFHeightVipController ()

@end

@implementation FFHeightVipController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"满 V";
}


#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (NSString *)gameType {
    return @"4";
}


@end
