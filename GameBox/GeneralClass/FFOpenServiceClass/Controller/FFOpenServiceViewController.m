//
//  FFOpenServiceViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFOpenServiceViewController.h"

#import "FFOSChildViewController.h"

@interface FFOpenServiceViewController ()

@property (nonatomic, strong) FFOSChildViewController *todayOpenVC;
@property (nonatomic, strong) FFOSChildViewController *alredayOpenVC;
@property (nonatomic, strong) FFOSChildViewController *soonOpenVC;


@end

@implementation FFOpenServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)initUserInterface {
    [super initUserInterface];

    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
}

- (void)initDataSource {
    self.selectView.headerTitleArray = @[@"今日开服",@"即将开服",@"已经开服"];
    self.selectChildViewControllers = @[self.todayOpenVC,self.soonOpenVC,self.alredayOpenVC];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 44);
    CGFloat hight = kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame) - self.tabBarController.tabBar.frame.size.height;
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, hight);
    if (self.selectChildViewControllers.count > 0) {
        [self.scrollView setContentSize:CGSizeMake(kSCREEN_WIDTH * self.selectView.headerTitleArray.count, hight)];
        int index = 0;
        for (UIViewController *vc in self.selectChildViewControllers) {
            vc.view.frame = CGRectMake(kSCREEN_WIDTH * index++, 0, kSCREEN_WIDTH, hight);
        }
    }
}





#pragma mark - getter
- (FFOSChildViewController *)todayOpenVC {
    if (!_todayOpenVC) {
        _todayOpenVC = [[FFOSChildViewController alloc] init];
    }
    return _todayOpenVC;
}

- (FFOSChildViewController *)soonOpenVC {
    if (!_soonOpenVC) {
        _soonOpenVC = [[FFOSChildViewController alloc] init];
    }
    return _soonOpenVC;
}

- (FFOSChildViewController *)alredayOpenVC {
    if (!_alredayOpenVC) {
        _alredayOpenVC = [[FFOSChildViewController alloc] init];
    }
    return _alredayOpenVC;
}





@end
