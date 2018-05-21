//
//  FFGameViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameViewController.h"
#import "FFCurrentGameModel.h"
#import "FFGameHeaderView.h"
#import "FFGameFooterView.h"

@interface FFGameViewController () <FFGameDetailFooterViewDelegate>


@property (nonatomic, strong) FFGameHeaderView *gameHeaderView;
@property (nonatomic, strong) FFGameFooterView *gameFooterView;

@property (nonatomic, strong) NSArray *childsControllerName;
@property (nonatomic, strong) NSMutableArray<FFBasicSSTableViewController *> *childsControllerArray;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIImage *lastNaviImage;
@property (nonatomic, strong) UIImage *lastShadowImage;

@end

static FFGameViewController *controller = nil;
@implementation FFGameViewController


+ (instancetype)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!controller) {
            controller = [[FFGameViewController alloc] init];
        }
    });
    return controller;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
    [self naviTransParent];
}




- (void)naviTransParent {
    UIView *barBackgroundView;// _UIBarBackground
    UIImageView *backgroundImageView;// UIImageView
    UIView *backgroundEffectView;// UIVisualEffectView

    if (@available(iOS 10.0, *)) {//
        barBackgroundView = [self.self.navigationController.navigationBar.subviews objectAtIndex:0];
        if (barBackgroundView.subviews.count > 1) {
            backgroundImageView = [barBackgroundView.subviews objectAtIndex:0];
            backgroundEffectView = [barBackgroundView.subviews objectAtIndex:1];
        }
    } else {
        for (UIView *view in self.self.navigationController.navigationBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                barBackgroundView = view;
            }
        }
        for (UIView *otherView in barBackgroundView.subviews) {
            if ([otherView isKindOfClass:NSClassFromString(@"UIImageView")]) {
                backgroundImageView = (UIImageView *)otherView;
            }else if ([otherView isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
                backgroundEffectView = otherView;
            }
        }
    }

    barBackgroundView.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
//    self.view.backgroundColor = [UIColor blackColor];
    [self setSelectViewInfo];
    [self setNormalView];
}

- (void)setNormalView {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
    self.navBarBGAlpha = @"0.0";
    [self naviTransParent];
    self.headerView = self.gameHeaderView;
    self.footerView = self.gameFooterView;
    self.sectionView = self.selectView;
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.tableView];

    [self.view bringSubviewToFront:self.navigationView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];

    //计算导航栏的透明度
    CGFloat maxAlphaOffset = self.headerView.bounds.size.height - kNAVIGATION_HEIGHT;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = offset / maxAlphaOffset;

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:(1 - alpha) alpha:1]];

    self.navigationView.alpha = alpha;

    CGFloat offset_y = scrollView.contentOffset.y;

    [self.gameHeaderView refreshBackgroundHeight:offset_y];

    //根据导航栏透明度设置title
    if (offset_y > 120) {
        [self showNavigationTitle];
    } else {
        [self hideNavigationTitle];
    }
}


- (void)initDataSource {
    [super initDataSource];

    self.childsControllerName = @[@"FFGameDetailViewController",
                                  @"FFGameCommentListViewController",
                                  @"FFGameGiftViewController",
                                  @"FFGameOpenServerViewController",
                                  @"FFGameDetailGuideViewController"];

    [self.gameHeaderView setQqGroupButtonBlock:^{
        syLog(@"玩家 QQ 群");
    }];

    //点击了 select view 的下标后 滑动cell 的 scroll view 到指定位置
    WeakSelf;
    [self.selectView setSelectBlock:^(NSUInteger idx) {
        [[FFBasicSSTableViewCell cell] selectViewWithIndex:idx];
        _currentIndex = idx;
        [weakSelf naviTransParent];
    }];

    //cell 横向滑动的时候 移动 select view 的游标
    [[FFBasicSSTableViewCell cell] setScrolledBlock:^(CGFloat offset_x) {
        [weakSelf.selectView setCursorView_X:(offset_x)];
        NSUInteger idx = offset_x / kSCREEN_WIDTH;
        _currentIndex = idx;
    }];
}


- (FFBasicSSTableViewController *)creatControllerWithName:(NSString *)name {
    Class ViewController = NSClassFromString(name);
    id vc = [[ViewController alloc] init];
    if (![vc isKindOfClass:[FFBasicSSTableViewController class]]) {
        vc = [[UIViewController alloc] init];
    }
    [self addChildViewController:vc];
    return vc;
}


#pragma mark - method
- (void)refreshData {
    if (self.gid.length > 0) {
        [self startWaiting];
        WeakSelf;
        [FFCurrentGameModel refreshCurrentGameWithGameID:self.gid Completion:^(BOOL success) {
            [weakSelf stopWaiting];
            if (success) {
                [weakSelf setNormalView];
                [weakSelf.gameHeaderView refresh];
                [weakSelf setChildsRefresh];
            } else {
                [weakSelf.currentNav popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)setChildsRefresh {
    WeakSelf;
    for (FFBasicSSTableViewController *vc in weakSelf.selectChildConttoller) {
        vc.canRefresh = YES;
    }
    [weakSelf.selectChildConttoller[_currentIndex] refreshData];

}


- (void)showNavigationTitle {
    self.navigationItem.title = CURRENT_GAME.game_name;
    [self.gameHeaderView showNavigationTitle];
}

- (void)hideNavigationTitle {
    self.navigationItem.title = @"";
    [self.gameHeaderView hideNavigationTitle];
}


#pragma mark - delegate
- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickShareBtn:(UIButton *)sender {
    syLog(@"评论");
}

- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickCollecBtn:(UIButton *)sender {
    syLog(@"收藏");
}

- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickDownLoadBtn:(UIButton *)sender {
    syLog(@"下载");
}


#pragma mark - setter
- (void)setGid:(NSString *)gid {
    if ([_gid isEqualToString:gid]) {
        return;
    }

    _currentIndex = 0;
    _gid = gid;
    [self removeAllview];
    [[FFBasicSSTableViewCell cell] selectViewWithIndex:0];
    //刷新游戏
    [self refreshData];
}

- (void)removeAllview {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    self.navigationView.alpha = 0;
    self.footerView = nil;
    [self hideNavigationTitle];
}

- (void)setChildsControllerName:(NSArray *)childsControllerName {
    _childsControllerName = childsControllerName;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:childsControllerName.count];
    for (NSString *name in childsControllerName) {
        id vc = [self creatControllerWithName:name];
        [array addObject:vc];
    }
    self.selectChildConttoller = array;
}




#pragma mark - getter
- (FFGameHeaderView *)gameHeaderView {
    if (!_gameHeaderView) {
        _gameHeaderView = [[FFGameHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 250)];
    }
    return _gameHeaderView;
}

- (FFGameFooterView *)gameFooterView {
    if (!_gameFooterView) {
        _gameFooterView = [[FFGameFooterView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH, 50)];
        _gameFooterView.delegate = self;
    }
    return _gameFooterView;
}

- (void)setSelectViewInfo {
    self.selectView.headerLineColor = [FFColorManager game_select_line_color];
    self.selectView.footerLineColor = [FFColorManager game_select_line_color];
    self.selectView.normalColor = [FFColorManager game_select_normal_color];
    self.selectView.selectColor = [FFColorManager game_select__color];
    self.selectView.cursorColor = [FFColorManager game_select_cursor_color];
    self.selectView.titleArray = @[@"详情",@"评论",@"礼包",@"开服",@"攻略"];
    [self.selectView setButtonSubscriptWithIdx:1 Title:@"12"];
}




@end








