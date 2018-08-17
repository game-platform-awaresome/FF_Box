//
//  FFGameBusinessViewController.m
//  GameBox
//
//  Created by 燚 on 2018/8/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameBusinessViewController.h"

@interface FFGameBusinessViewController ()

@end

@implementation FFGameBusinessViewController

+ (UINavigationController *)GameBusiness {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[FFGameBusinessViewController new]];
    return nav;
}

+ (FFGameBusinessViewController *)showWithGameName:(NSString *)gameName {
    FFGameBusinessViewController *controller = [[FFGameBusinessViewController alloc] init];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:kBlackColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}








@end
