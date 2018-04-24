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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [FFWaitingManager stopWatiting];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
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









@end
