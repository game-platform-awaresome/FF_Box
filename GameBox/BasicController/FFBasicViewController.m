//
//  FFBasicViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFWaitingManager.h"
#import "UINavigationBar+FFNavigationBar.h"

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

//    self.navigationController.navigationBar.lineLayer.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height - 1, kSCREEN_WIDTH, 1);

    self.navBarBGAlpha = @"1.0";

//    syLog(@"%@ -> %s",NSStringFromClass([self class]),__func__);
}

- (void)customNavLine {
    self.navigationController.navigationBar.lineLayer = self.navLine;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.navigationController.navigationBar.lineLayer.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height - 1, kSCREEN_WIDTH, 1);
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

- (CALayer *)creatLineWithFrame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
    return layer;
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

- (void)addFLoatView {
    [self.view addSubview:self.floatImageView];
}

#pragma mark - responds
- (void)respondsToRightButton {

}

- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GestureRecognize
- (void)respondsToFloatImageViewTap:(UITapGestureRecognizer *)sender {

}

- (void)respondsToFloatImageViewPan:(UIPanGestureRecognizer *)sender {
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [sender translationInView:self.view];

    CGFloat centerX = 0;
    CGFloat centerY = 0;

    centerX = self.floatImageView.center.x + point.x;
    centerY = self.floatImageView.center.y + point.y;

    CGFloat KWidth = kSCREEN_WIDTH;
    CGFloat KHeight = kSCREEN_HEIGHT;

    //确定特殊的centerY
    if (centerY - self.floatImageViewSize / 2 < kNAVIGATION_HEIGHT ) {
        centerY = self.floatImageViewSize / 2 + kNAVIGATION_HEIGHT;
    }

    if (centerY + self.floatImageViewSize / 2 > KHeight ) {
        centerY = KHeight - self.floatImageViewSize / 2;
    }

    //确定特殊的centerX
    if (centerX - self.floatImageViewSize / 2 < 0) {
        centerX = self.floatImageViewSize / 2;
    }
    if (centerX + self.floatImageViewSize / 2 > KWidth) {
        centerX = KWidth - self.floatImageViewSize / 2;
    }

    //设置悬浮窗的边界

    self.floatImageView.center = CGPointMake(centerX, centerY);

    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        //判断是是否在边缘(在边缘的话隐藏)

    }
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
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
        _leftButton = [[UIBarButtonItem alloc] init];
        [_leftButton setTarget:self];
        [_leftButton setAction:@selector(respondsToLeftButton)];
    }
    return _leftButton;
}

- (UIBarButtonItem *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc] init];
        [_rightButton setTarget:self];
        [_rightButton setAction:@selector(respondsToRightButton)];
    }
    return _rightButton;
}

- (CGFloat)floatImageViewSize {
    return 50;
}

- (UIImageView *)floatImageView {
    if (!_floatImageView) {
        _floatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH * 0.8, self.view.bounds.size.height - CGRectGetMaxX(self.tabBarController.tabBar.frame) - 49, self.floatImageViewSize, self.floatImageViewSize)];

        _floatImageView.image = [UIImage imageNamed:@"Mine_list_invte"];
        _floatImageView.layer.cornerRadius = self.floatImageViewSize / 2;
        _floatImageView.layer.masksToBounds = YES;
        _floatImageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToFloatImageViewTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_floatImageView addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToFloatImageViewPan:)];
        [_floatImageView addGestureRecognizer:pan];
    }
    return _floatImageView;
}

- (CALayer *)navLine {
    if (!_navLine) {
        _navLine = [self creatLineWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height - 1, kSCREEN_WIDTH, 1)];
    }
    return _navLine;
}


@end
