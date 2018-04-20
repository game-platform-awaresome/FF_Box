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

@interface FFHomeViewController ()

/** 4 sub-controllers */
@property (nonatomic, strong) FFRecommentViewController *hRecommentVC;
@property (nonatomic, strong) FFNewGameViewController   *hNewGameVC;
@property (nonatomic, strong) FFGameGuideViewController *hGameGuideVC;
@property (nonatomic, strong) FFClassifyViewController  *hClassifyVC;


@end

@implementation FFHomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    syLog(@"home nav = %@",self.navigationController);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
}
 
- (void)initDataSource {
    self.selectView.headerTitleArray = @[@"推荐",@"新游",@"攻略",@"分类"];
    self.selectChildViewControllers = @[self.hRecommentVC,self.hNewGameVC,self.hGameGuideVC,self.hClassifyVC];
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









@end
