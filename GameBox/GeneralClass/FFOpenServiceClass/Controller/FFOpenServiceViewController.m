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
}

- (void)initDataSource {
    [super initDataSource];
    self.selectView.headerTitleArray = @[@"今日开服",@"即将开服",@"已经开服"];
    self.selectChildViewControllers = @[self.todayOpenVC,self.soonOpenVC,self.alredayOpenVC];
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
