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
#import "FFStatisticsModel.h"

#import "FFWriteCommentController.h"

#import "FFDeviceInfo.h"
#import "FFUserModel.h"

#import "FFSharedController.h"

@interface FFGameViewController () <FFGameDetailFooterViewDelegate>


@property (nonatomic, strong) FFGameHeaderView *gameHeaderView;
@property (nonatomic, strong) FFGameFooterView *gameFooterView;

@property (nonatomic, strong) NSArray *childsControllerName;
@property (nonatomic, strong) NSMutableArray<FFBasicSSTableViewController *> *childsControllerArray;

@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) UIImage *lastNaviImage;
@property (nonatomic, strong) UIImage *lastShadowImage;

@property (nonatomic, strong) UIColor *lastNavColor;
@property (nonatomic, assign) BOOL isResetNavColor;

@property (nonatomic, strong) FFWriteCommentController *writeComment;

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
    if (_isResetNavColor) {
        [self resetNavColor];
    } else {
        [self.navigationController.navigationBar setTintColor:self.lastNavColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.gameHeaderView.betaString = nil;
    self.gameHeaderView.reservationString = nil;
}

- (void)resetNavColor {
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
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
//    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_white_color]];
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

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[FFImageManager General_back_black] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[FFImageManager Game_shared_image] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
}

- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToRightButton {
    syLog(@"分享");
    if (CURRENT_USER.isLogin) {
        syLog(@"邀请好友");
        [FFSharedController inviteFriend];
    } else {
        NSString *className = @"FFLoginViewController";
        Class ViewController = NSClassFromString(className);
        if (ViewController) {
            id vc = [[ViewController alloc] init];
            [self pushViewController:vc];
        } else {
            syLog(@"%s error -> %@ not exist",__func__,className);
        }
    }
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
    self.lastNavColor = [UIColor colorWithWhite:(1 - alpha) alpha:1];
    [self.navigationController.navigationBar setTintColor:self.lastNavColor];

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
        syLog(@"玩家 QQ 群 == %@",[FFCurrentGameModel CurrentGame].player_qq_group);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[FFCurrentGameModel CurrentGame].player_qq_group]];
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


    [CURRENT_GAME setCommentNumberBlock:^(NSString *commentNumber) {
        [self.selectView setButtonSubscriptWithIdx:1 Title:commentNumber];
    }];

    


}


- (FFBasicSSTableViewController *)creatControllerWithName:(NSString *)name {
    Class ViewController = NSClassFromString(name);
    id vc = [[ViewController alloc] init];
    if (![vc isKindOfClass:[FFBasicViewController class]]) {
        vc = [[FFBasicViewController alloc] init];
    }
    [self addChildViewController:vc];
    return vc;
}


#pragma mark - method
- (void)refreshData {
    if (self.gid.length > 0) {
        [self naviTransParent];
        [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_white_color]];
        [self startWaiting];
        WeakSelf;
        [FFCurrentGameModel refreshCurrentGameWithGameID:self.gid Completion:^(BOOL success) {
            [weakSelf stopWaiting];
            if (success) {
                [weakSelf setNormalView];
                [weakSelf.gameHeaderView refresh];
                [weakSelf.gameFooterView refresh];
                [weakSelf setChildsRefresh];
            } else {
                [weakSelf.currentNav popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)setChildsRefresh {
    WeakSelf;
    for (FFBasicViewController *vc in weakSelf.selectChildConttoller) {
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
    if (CURRENT_USER.isLogin) {
        [self startWaiting];
        //请求是否可以评论
        WeakSelf;
        [CURRENT_GAME gameCanCommentCompletion:^(NSDictionary *content, BOOL success) {
            syLog(@"game is login -=== %@",content);
            [self stopWaiting];
            if (success) {
                [weakSelf pushViewController:self.writeComment];
            } else {
                NSString *msg ;
                if ([content[@"msg"] isEqualToString:@"404"]) {
                    msg = @"网络不知道飞哪里去了";
                } else {
                    msg = [NSString stringWithFormat:@"%@",content[@"msg"]];
                }
                [UIAlertController showAlertMessage:msg dismissTime:0.9 dismissBlock:nil];
            }
        }];
    } else {
        NSString *className = @"FFLoginViewController";
        Class ViewController = NSClassFromString(className);
        if (ViewController) {
            id vc = [[ViewController alloc] init];
            [self pushViewController:vc];
        } else {
            syLog(@"%s error -> %@ not exist",__func__,className);
        }
    }
}

- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickCollecBtn:(UIButton *)sender {
    syLog(@"收藏");
    if (!CURRENT_USER.isLogin) {
        BOX_MESSAGE(@"尚未登录");
        return;
    }
    FFCollectionType type = CURRENT_GAME.game_is_collection.boolValue ? FFCollectionTypeCancel : FFCollectionTypeCollection;
    [FFGameModel collectionGameWithGameID:CURRENT_GAME.game_id CollectionType:type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            CURRENT_GAME.game_is_collection = [NSString stringWithFormat:@"%u", (type == FFCollectionTypeCancel) ? NO : YES];
            [self.gameFooterView refresh];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickDownLoadBtn:(UIButton *)sender {
    syLog(@"下载游戏");

    if ([Channel isEqualToString:@"185"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CURRENT_GAME.game_download_url]];
    } else {
        [self startWaiting];
        [FFGameModel getGameDownloadUrlWithTag:CURRENT_GAME.game_tag Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            [self stopWaiting];
            id contentData = content[@"data"];
            if (contentData == nil || [contentData isKindOfClass:[NSNull class]] || ((NSArray *)contentData).count == 0) {
                BOX_MESSAGE(@"暂无下载链接,请联系客服");
            } else {
                NSString *url = content[@"data"][@"download_url"];
                syLog(@"downLoadUrl == %@",url);
                ([url isKindOfClass:[NSString class]]) ? ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) : (BOX_MESSAGE(@"链接出错,请稍后尝试"));
            }
        }];
    }

    customEvents(@"down_laod_game", @{@"game_name":CURRENT_GAME.game_name,@"game_id":CURRENT_GAME.game_id});

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

/** 内测游戏 */
- (void)setBetaString:(NSString *)betaString {
    _betaString = betaString;
    self.gameHeaderView.betaString = betaString;
}

/** 预约游戏字段 */
- (void)setReservationString:(NSString *)reservationString {
    _reservationString = reservationString;
    self.gameHeaderView.reservationString = reservationString;
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
}



- (FFWriteCommentController *)writeComment {
    if (!_writeComment) {
        _writeComment = [[FFWriteCommentController alloc] init];
        WeakSelf;
        [_writeComment setSendCommentCallBack:^(NSDictionary *dict, BOOL success) {
            if (success) {
                [weakSelf.selectChildConttoller[1] refreshData];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [UIAlertController showAlertMessage:@"评论成功" dismissTime:0.7 dismissBlock:nil];
            } else {
                [UIAlertController showAlertMessage:dict[@"msg"] dismissTime:0.7 dismissBlock:nil];
            }
        }];
    }
    return _writeComment;
}




@end








