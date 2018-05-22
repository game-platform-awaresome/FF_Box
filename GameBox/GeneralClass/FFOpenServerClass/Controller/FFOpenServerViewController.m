//
//  FFOpenServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFOpenServerViewController.h"
#import "FFBTOpenServerViewController.h"
#import "FFZKOpenServerViewController.h"

@interface FFOpenServerViewController ()

@property (nonatomic, strong) NSArray *selectControllerNames;

@end

@implementation FFOpenServerViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"开服表";
}

- (void)initDataSource {
    self.homeSelectView.titleArray = @[@"BT服",@"折扣"];
    self.selectChildViewControllers = @[[FFBTOpenServerViewController new],
                                        [FFZKOpenServerViewController new]];
}





@end
