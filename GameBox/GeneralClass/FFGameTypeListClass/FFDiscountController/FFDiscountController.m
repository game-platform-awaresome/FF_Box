//
//  FFDiscountController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFDiscountController.h"

@interface FFDiscountController ()

@end

@implementation FFDiscountController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"超低折扣";
}

#pragma mark - getter
- (FFGameServersType)gameServerType {
    return ZK_SERVERS;
}


- (NSString *)gameType {
    return @"5";
}



@end
