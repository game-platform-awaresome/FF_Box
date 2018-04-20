//
//  FFDriveViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFDriveViewController.h"

@interface FFDriveViewController ()

@end

@implementation FFDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = [NSString stringWithFormat:@"秋名山"];
}


- (void)initDataSource {
    [super initDataSource];
    self.selectView.headerTitleArray = @[@"全部",@"热门",@"关注",@"我的",@"消息"];
}













@end
