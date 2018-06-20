//
//  FFBusinessRecordViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessRecordViewController.h"

@interface FFBusinessRecordViewController ()

@end

@implementation FFBusinessRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    self.selectView.headerTitleArray = @[@"已购买",@"审核中",@"出售中",@"已出售",@"仓库中"];
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.navigationItem.title = @"交易记录";
    [self.view addSubview:self.selectView];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 44);
}






@end









