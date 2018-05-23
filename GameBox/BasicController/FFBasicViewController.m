//
//  FFBasicViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFWaitingManager.h"

@interface FFBasicViewController ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger hudNumber;

@end

@implementation FFBasicViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
    self.navBarBGAlpha = @"1.0";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.hidesBottomBarWhenPushed = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hudNumber = 0;
    [self initDataSource];
    [self initUserInterface];
}

#pragma mark - method
- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initDataSource {

}

- (void)refreshData {

}

- (void)loadMoreData {

}


- (void)hideTabbar {
    if (self.parentViewController.parentViewController) {
        self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;
    }
    self.navigationController.topViewController.hidesBottomBarWhenPushed = YES;
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    self.hidesBottomBarWhenPushed = YES;
}

- (void)showTabbar {
    if (self.parentViewController.parentViewController) {
        self.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;
    }
    self.parentViewController.hidesBottomBarWhenPushed = NO;
    self.navigationController.topViewController.hidesBottomBarWhenPushed = NO;
    self.hidesBottomBarWhenPushed = NO;
}

- (void)pushViewController:(UIViewController *)vc HideTabbar:(BOOL)hideTabbar {
    [self hideTabbar];
    [self.currentNav pushViewController:vc animated:YES];
    if (!hideTabbar) {
        [self showTabbar];
    }
}

- (void)pushViewController:(UIViewController *)viewController {
    [self hideTabbar];
    [self.currentNav pushViewController:viewController animated:YES];
    if (self.navigationController.viewControllers.count <= 2) {
        [self showTabbar];
    }
}

- (void)returnHideTabbarPushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController HideTabbar:YES];
}

- (void)returnShowTabbarPushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController HideTabbar:NO];
}

- (void)showLoginViewController {
    
}

#pragma mark - responds
- (void)respondsToRightButton {

}

- (void)respondsToLeftButton {

}

#pragma mark - hud
- (void)startWaiting {
    if (self.hudNumber <= 0) {
        self.hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.hud];
        [self.hud showAnimated:YES];
        self.hudNumber = 0;
        [FFWaitingManager startStatubarWaiting];
    }
    self.hudNumber++;
}

- (void)stopWaiting {
    self.hudNumber--;
    if (self.hudNumber <= 0) {
        self.hud.removeFromSuperViewOnHide = YES;
        [self.hud hideAnimated:YES];
        self.hudNumber = 0;
        [FFWaitingManager stopStatubarWating];
    }
}

#pragma mark - getter
- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _hud;
}

- (UINavigationController *)currentNav {
    return [FFControllerManager sharedManager].currentNavController;
}

- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
    }
    return _rightButton;
}




@end
