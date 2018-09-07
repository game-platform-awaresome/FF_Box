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
#import "FFUserModel.h"
#import "FFShowDiscoutModel.h"
//#import "FFBoxModel.h"
#import "FFBoxHandler.h"

//#import "FFHomeSelectView.h"

@interface FFHomeViewController () <FFHomeSelectViewDelegate>

@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) NSArray *_controllerNameArray;

@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, assign) BOOL leaveBreathe;

@end

@implementation FFHomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
    self.navBarBGAlpha = @"0";
    _leaveBreathe = NO;
    [self respondsToTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _leaveBreathe = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    self.navigationItem.title = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"游戏大厅";
    [self setSelectTitleView];
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.homeSelectView];
//    [self.navigationView addSubview:self.messageButton];

    self.messageButton = [UIButton hyb_buttonWithImage:@"Home_message_light" superView:self.navigationView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.navigationView);
        make.right.mas_equalTo(self.navigationView).offset(-0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    } touchUp:^(UIButton *sender) {
        [self respondsToRightButton];
    }];

    [self.view addSubview:self.scrollView];
    self.floatImageView.image = [FFImageManager Home_mission_center_image];
    self.floatImageView.frame = CGRectMake(kSCREEN_WIDTH - 95, kSCREEN_HEIGHT - 150, 100, 80);
    self.floatImageView.layer.masksToBounds = NO;
    [self addFLoatView];

    UIButton *floatButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    floatButton.frame = self.floatImageView.frame;
    [floatButton addTarget:self action:@selector(respondsToFloatButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:floatButton];
}

static BOOL homeviewAnimation;
- (void)respondsToTimer {
    if (_leaveBreathe) {
        return;
    }

    if (homeviewAnimation) {
        return;
    }
    homeviewAnimation = YES;
    [UIView animateWithDuration:1 animations:^{
        if (self.floatImageView.alpha == 0.5) {
            self.floatImageView.alpha = 1;
        } else if (self.floatImageView.alpha == 1) {
            self.floatImageView.alpha = 0.5;
        }
    } completion:^(BOOL finished) {
        homeviewAnimation = NO;
        [self respondsToTimer];
    }];
}






- (void)respondsToFloatButton {
//    NSString *message = [NSString stringWithFormat:@"开始游戏_%@",CURRENT_GAME.game_name];

    m185Statistics(@"首页_赚金币", -1);

    NSString *className = CURRENT_USER.isLogin ? @"FFMissionCenterViewController" : @"FFLoginViewController";
    Class MissonVC = NSClassFromString(className);
    if (MissonVC) {
        id vc = [[MissonVC alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s error- > %@ not exist",__func__,className);
    }
}

 
- (void)initDataSource {
    [super initDataSource];
    self.selectChildViewControllers = nil;
    self.homeSelectView.titleArray = [FFBoxHandler sharedInstance].discount_enabled.boolValue ? @[@"BT服",@"折扣",@"H5",@"承诺"] : @[@"BT服",@"H5",@"承诺"];
    self._controllerNameArray = [FFBoxHandler sharedInstance].discount_enabled.boolValue ? @[@"FFBTServerViewController",@"FFZKServerViewController",@"FFH5ServerViewController",@"FFPromiseViewController"] : @[@"FFBTServerViewController",@"FFH5ServerViewController",@"FFPromiseViewController"];

//    self._controllerNameArray = @[@"FFPromiseViewController",@"FFPromiseViewController",@"FFPromiseViewController"];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = CGRectMake(0, KSTATUBAR_HEIGHT + 44, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
    int idx = 0;
    for (UIViewController *vc in self.selectChildViewControllers) {
        vc.view.frame = CGRectMake(kSCREEN_WIDTH * idx, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
        idx++;
    }
}

#pragma mark - responds
- (void)respondsToFloatImageViewTap:(UITapGestureRecognizer *)sender {

//    NSString *className = CURRENT_USER.isLogin ? @"FFMissionCenterViewController" : @"FFLoginViewController";
//    Class MissonVC = NSClassFromString(className);
//    if (MissonVC) {
//        id vc = [[MissonVC alloc] init];
//        [self pushViewController:vc];
//    } else {
//        syLog(@"%s error- > %@ not exist",__func__,className);
//    }
}

- (void)respondsToFloatImageViewPan:(UIPanGestureRecognizer *)sender {
    
}

- (void)respondsToRightButton {
    NSString *className = CURRENT_USER.isLogin ? @"FFMyNewsViewController" : @"FFLoginViewController";
    Class ViewController = NSClassFromString(className);
    if (ViewController) {
        id vc = [[ViewController alloc] init];
        [self pushViewController:vc];
    } else {
        syLog(@"%s error -> %@ not exist",__func__,className);
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
- (void)set_controllerNameArray:(NSArray *)_controllerNameArray {
    __controllerNameArray = _controllerNameArray;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_controllerNameArray.count];
    [_controllerNameArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[self creatControllerWithString:obj]];
    }];
    if (self.selectChildViewControllers) {
        for (UIViewController *vc in self.selectChildViewControllers) {
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
    self.selectChildViewControllers = array.copy;
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


//        _homeSelectView.backgroundColor = kOrangeColor;
    }
    return _homeSelectView;
}

- (UIButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [UIButton createButtonFrame:CGRectMake(kSCREEN_WIDTH - 54, KSTATUBAR_HEIGHT, 50, 44) title:nil imageName:@"Home_message_light" action:^(UIButton * _Nonnull button) {
            [self respondsToRightButton];
        }];
    }
    return _messageButton;
}

- (CGFloat)floatImageViewSize {
    return 90;
}




@end
