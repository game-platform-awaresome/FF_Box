//
//  FFGuideViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGuideViewController.h"

@interface FFGuideViewController ()

@end

@implementation FFGuideViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    self.navigationItem.title = @"攻略";
}

#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (FFActivityType)acitvityType {
    return  FFGuide;
}



@end
