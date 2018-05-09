//
//  FFHomeViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFHomeViewController.h"

#import "FFRecommentViewController.h"
#import "FFNewGameViewController.h"
#import "FFGameGuideViewController.h"
#import "FFClassifyViewController.h"

#import "FFBasicSelectView.h"

@interface FFHomeViewController ()

/** 4 sub-controllers */
@property (nonatomic, strong) FFRecommentViewController *hRecommentVC;
@property (nonatomic, strong) FFNewGameViewController   *hNewGameVC;
@property (nonatomic, strong) FFGameGuideViewController *hGameGuideVC;
@property (nonatomic, strong) FFClassifyViewController  *hClassifyVC;

@property (nonatomic, strong) FFBasicSelectView *homeSelectView;


@end

@implementation FFHomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    syLog(@"home nav = %@",self.navigationController);
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [FFWaitingManager stopWatiting];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.homeSelectView];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - CGRectGetHeight(self.tabBarController.tabBar.frame));
    int idx = 0;
    for (UIViewController *vc in self.selectChildViewControllers) {
        vc.view.frame = CGRectMake(kSCREEN_WIDTH * idx, 0, kSCREEN_WIDTH, self.scrollView.bounds.size.height);
        idx++;
    }
}
 
- (void)initDataSource {
    [super initDataSource];
    self.selectView.headerTitleArray = @[@"推荐",@"新游",@"攻略",@"分类"];
    self.selectChildViewControllers = @[self.hRecommentVC,self.hNewGameVC,self.hGameGuideVC,self.hClassifyVC];
}



#pragma mark - getter
- (FFRecommentViewController *)hRecommentVC {
    if (!_hRecommentVC) {
        _hRecommentVC = [[FFRecommentViewController alloc] init];
    }
    return _hRecommentVC;
}

- (FFNewGameViewController *)hNewGameVC {
    if (!_hNewGameVC) {
        _hNewGameVC =[[FFNewGameViewController alloc] init];
    }
    return _hNewGameVC;
}

- (FFGameGuideViewController *)hGameGuideVC {
    if (!_hGameGuideVC) {
        _hGameGuideVC = [[FFGameGuideViewController alloc] init];
    }
    return _hGameGuideVC;
}

- (FFClassifyViewController *)hClassifyVC {
    if (!_hClassifyVC) {
        _hClassifyVC = [FFClassifyViewController new];
    }
    return _hClassifyVC;
}


- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 64)];
        _navigationView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    return _navigationView;
}


- (FFBasicSelectView *)homeSelectView {
    if (!_homeSelectView) {
        _homeSelectView = [[FFBasicSelectView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, self.selectViewHight)];
        _homeSelectView.delegate = self;
        _homeSelectView.lineColor = [UIColor clearColor];
    }
    return _homeSelectView;
}






@end
