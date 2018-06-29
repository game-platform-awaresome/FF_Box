//
//  FFOpenServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFOpenServerViewController.h"
#import "FFSBTOpenServerViewController.h"
#import "FFSZKOpenServerViewController.h"
#import "FFBoxModel.h"

@interface FFOpenServerViewController ()

@property (nonatomic, strong) NSArray *selectControllerNames;

@end

@implementation FFOpenServerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navBarBGAlpha = @"0.0";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"开服表";
}

- (void)initDataSource {
    [super initDataSource];
    self.homeSelectView.titleArray = [FFBoxModel sharedModel].discount_enabled.boolValue ? @[@"BT服",@"折扣"] : @[@"BT服"] ;
    self.selectChildViewControllers = [FFBoxModel sharedModel].discount_enabled.boolValue ?
    @[[FFSBTOpenServerViewController new], [FFSZKOpenServerViewController new]].mutableCopy:
    @[[FFSBTOpenServerViewController new]].mutableCopy;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.selectView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
//    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame));
//    int i = 0;
//    for (UIViewController *vc in self.selectChildViewControllers) {
//        vc.view.frame = CGRectMake(kSCREEN_WIDTH * i, 0, kSCREEN_WIDTH, self.scrollView.bounds.size.height);
//        i++;
//    }
}



@end
