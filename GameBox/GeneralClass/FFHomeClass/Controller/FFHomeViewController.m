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
#import "FFLoginViewController.h"

//#import "FFHomeSelectView.h"

@interface FFHomeViewController () <FFHomeSelectViewDelegate>




@end

@implementation FFHomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
    self.navBarBGAlpha = @"0";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)initUserInterface {
    self.navigationItem.title = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.title = @"游戏";

    [self setSelectTitleView];

    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.homeSelectView];
//    [self.navigationController.navigationBar addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
    [self addFLoatView];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = CGRectMake(0, KSTATUBAR_HEIGHT + 44, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
    int idx = 0;
    for (UIViewController *vc in self.selectChildViewControllers) {
        vc.view.frame = CGRectMake(kSCREEN_WIDTH * idx, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
        idx++;
    }
}
 
- (void)initDataSource {
    [super initDataSource];
    self.homeSelectView.titleArray = @[@"BT服",@"折扣"];
    self.selectChildViewControllers = @[[self creatControllerWithString:@"FFBTServerViewController"],
                                        [self creatControllerWithString:@"FFZKServerViewController"]];
}

- (UIViewController *)creatControllerWithString:(NSString *)controllerString {
    Class ControllerClass = NSClassFromString(controllerString);
    id viewController = [[ControllerClass alloc] init];
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
        syLog(@"\n!\n%s error message : %@ is not exist \n!",__func__,controllerString);
    }
    return viewController;
}

#pragma mark - responds
- (void)respondsToFloatImageViewTap:(UITapGestureRecognizer *)sender {
    Class MissonVC = NSClassFromString(@"FFMissionCenterViewController");
    if (MissonVC) {
        id vc = [[MissonVC alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s error- > FFMissionCenterViewController not exist",__func__);
    }
}

#pragma mark - select view delegate
- (void)FFHomeSelectView:(FFHomeSelectView *)selectView didSelectButtonWithIndex:(NSUInteger)idx {
    if (self.isAnimatining || self.lastViewController == self.selectChildViewControllers[idx] || self.selectChildViewControllers.count == 0) {
        return;
    }

    if (idx > self.selectChildViewControllers.count) {
        syLog(@"选择的标题大于可以选择的控制器!!!");
        return;
    }

    if (self.lastViewController != nil) {
        [self childControllerAdd:self.selectChildViewControllers[idx]];
        [self childControllerRemove:self.lastViewController];
    } else {
        [self childControllerAdd:self.selectChildViewControllers[idx]];
    }

    self.lastViewController = self.selectChildViewControllers[idx];
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:NO];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标
    [self.homeSelectView setCursorCenter_X:(x) / (scrollView.contentSize.width - kSCREEN_WIDTH)];

    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < self.selectChildViewControllers.count - 1 && other != 0) {
        [self childControllerAdd:self.selectChildViewControllers[i]];
        [self childControllerAdd:self.selectChildViewControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self childControllerRemove:self.selectChildViewControllers[i - 1]];
            if (i != self.selectChildViewControllers.count - 1) {
                [self childControllerRemove:self.selectChildViewControllers[i + 1]];
            }
        } else {
            [self childControllerAdd:self.selectChildViewControllers[0]];
            [self childControllerRemove:self.selectChildViewControllers[i + 1]];
        }
    }

    NSArray *array = self.childViewControllers;
    if (array.count == 1) {
        self.lastViewController = array[0];
    } else {
        self.lastViewController = nil;
    }
}


#pragma mark - setter
- (void)setSelectTitleView {
    self.selectView.frame = CGRectMake(0, 20, kSCREEN_WIDTH * 0.5, 44);
    self.selectView.titleSize = CGSizeMake(kSCREEN_WIDTH / 5, 44);
}


#pragma mark - getter
- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, KSTATUBAR_HEIGHT + 44)];
        _navigationView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    return _navigationView;
}


- (FFHomeSelectView *)homeSelectView {
    if (!_homeSelectView) {
        _homeSelectView = [[FFHomeSelectView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, KSTATUBAR_HEIGHT + 44)];
        _homeSelectView.delegate = self;
        _homeSelectView.lineColor = [FFColorManager home_select_View_separat_lineColor];
    }
    return _homeSelectView;
}






@end
