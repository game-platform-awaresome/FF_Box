//
//  FFZKRankViewController.m
//  GameBox
//
//  Created by 燚 on 2018/7/27.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFZKRankViewController.h"

@interface FFZKRankViewController ()

@end

@implementation FFZKRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (FFGameServersType)gameServerType {
    return ZK_SERVERS;
}

@end
