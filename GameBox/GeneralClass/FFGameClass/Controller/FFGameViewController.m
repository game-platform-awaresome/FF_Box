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
#import "H5Handler.h"

#import "FFDeviceInfo.h"
#import "FFUserModel.h"

#import "FFSharedController.h"
#import "FFGameBusinessViewController.h"

@interface FFGameDwonloadView : UIView



+ (FFGameDwonloadView *)show;

- (FFGameDwonloadView *)hide;



@end




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

@property (nonatomic, strong) UIButton *Game_comment_prompt_button;
@property (nonatomic, assign) BOOL show_Game_comment_prompt;


@end

static FFGameViewController *controller = nil;
@implementation FFGameViewController

+ (FFGameViewController *)showWithGameID:(id)gameID {
    FFGameViewController *gameViewController = [self sharedController];
    if ([gameID isKindOfClass:[NSString class]]) {
        gameViewController.gid = gameID;
    } else if ([gameID isKindOfClass:[NSDictionary class]]) {
        gameViewController.gid = [NSString stringWithFormat:@"%@",gameID[@"id"] ?: gameID[@"gid"] ?: @"0"];
    } else {
        gameViewController.gid = nil;
    }
    return [self sharedController];
}

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

    }

    CGFloat maxAlphaOffset = self.headerView.bounds.size.height - kNAVIGATION_HEIGHT;
    CGFloat offset = self.tableView.contentOffset.y;
    CGFloat alpha = offset / maxAlphaOffset;
    self.lastNavColor = [UIColor colorWithWhite:(1 - alpha) alpha:1];
    [self.navigationController.navigationBar setTintColor:self.lastNavColor];


    if (!_show_Game_comment_prompt) {
        _show_Game_comment_prompt = YES;
        self.Game_comment_prompt_button = [UIButton hyb_buttonWithImage:@"Game_comment_prompt" superView:self.view constraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view).offset(-50);
            make.right.mas_equalTo(self.view).offset(-0);
        } touchUp:^(UIButton *sender) {
            [self respondsToShowGameCommentButton];
        }];
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

}

- (void)initUserInterface {
    [super initUserInterface];


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

- (void)respondsToShowGameCommentButton {
    [self.Game_comment_prompt_button removeFromSuperview];
    self.Game_comment_prompt_button = nil;
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

    [self.tableView reloadData];

    if (self.Game_comment_prompt_button) {
        [self.view bringSubviewToFront:self.Game_comment_prompt_button];
    }

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
        self -> _currentIndex = idx;
        [weakSelf naviTransParent];
    }];

    //cell 横向滑动的时候 移动 select view 的游标
    [[FFBasicSSTableViewCell cell] setScrolledBlock:^(CGFloat offset_x) {
        [weakSelf.selectView setCursorView_X:(offset_x)];
        NSUInteger idx = offset_x / kSCREEN_WIDTH;
        self -> _currentIndex = idx;
    }];


    //设置评论数
    [CURRENT_GAME setCommentNumberBlock:^(NSString *commentNumber) {
        [self.selectView setButtonSubscriptWithIdx:1 Title:commentNumber];
    }];

    //设置礼包数目
    [CURRENT_GAME setGiftNumberBlock:^(NSString *giftNumber) {
        [self.selectView setButtonSubscriptWithIdx:2 Title:giftNumber];
    }];

    //设置攻略数据
    [CURRENT_GAME setGuideNumberBlock:^(NSString *guideNumberBlock) {
        [self.selectView setButtonSubscriptWithIdx:4 Title:guideNumberBlock];

    }];

    //响应头部账号交易按钮
    [CURRENT_GAME setAccountTransaction:^{
        syLog(@"账号交易!!!!");
//        [self presentViewController:[FFGameBusinessViewController GameBusiness] animated:YES completion:nil];
        [self pushViewController:[FFGameBusinessViewController showWithGameName:CURRENT_GAME.game_name]];
    }];

    //点击头部排行榜

    [self.gameHeaderView setHotButtonBlock:^{
        syLog(@"游戏 排行榜");
        [weakSelf pushRankList];
//        [self pushViewController:[FFRankListViewController new]];
    }];

}

- (void)pushRankList {
    //"platform": "3", //游戏平台 1 BT 2 折扣 3 H5
    switch (CURRENT_GAME.platform.integerValue) {
        case 1:{
            pushViewController(@"FFRankListViewController");
        }
            break;
        case 2: {
            pushViewController(@"FFZKRankViewController");
        }
            break;
        case 3: {
            pushViewController(@"FFH5RankViewController");
        }
            break;
        default:
            break;
    }
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
                [weakSelf.gameHeaderView refresh];
                [weakSelf.gameFooterView refresh];
                [weakSelf setChildsRefresh];
                [weakSelf setNormalView];
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
    if ((CURRENT_GAME.platform.integerValue == 3)) {
        syLog(@"进入 H5 游戏");
        if ([FFUserModel UserName] && [FFUserModel passWord]) {
            [self pushViewController:[H5Handler handler].H5ViewController];
            [H5Handler initWithAppID:CURRENT_GAME.appid ClientKey:CURRENT_GAME.app_clientkey H5Url:CURRENT_GAME.h5_url];
        } else {
            pushViewController(@"FFLoginViewController");
        }
    } else {
        [FFGameDwonloadView show];
    }
}





#pragma mark - setter
- (void)setGid:(NSString *)gid {
    if ([_gid isEqualToString:gid]) {
        return;
    }

    _currentIndex = 0;
    _gid = gid;
    CURRENT_GAME.game_id = [NSString stringWithFormat:@"%@",gid];

    [self removeAllview];

    [[FFBasicSSTableViewCell cell] selectViewWithIndex:0];

    //刷新游戏
    [self refreshData];
    //刷新子视图
//    for (FFBasicViewController *vc in self.selectChildConttoller) {
//        [vc refreshData];
//    }
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
//    self.tableView = nil;
    self.canScroll = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [[FFBasicSSTableViewCell cell] selectViewWithIndex:0];
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



@implementation FFGameDwonloadView


+ (FFGameDwonloadView *)show {
    FFGameDwonloadView *view = [[FFGameDwonloadView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    return view;
}

- (FFGameDwonloadView *)hide {
    [self removeFromSuperview];
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];


    //backview
    UIView *backView = [UIView hyb_viewWithSuperView:self constraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, kScreenWidth * 0.8));
    }];
    backView.backgroundColor = kWhiteColor;
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;

    //title
    UILabel *titleLable = [UILabel hyb_labelWithText:@"提示" font:18 superView:backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView).offset(0);
        make.left.mas_equalTo(backView).offset(0);
        make.right.mas_equalTo(backView).offset(0);
        make.height.mas_equalTo(50);
    }];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont boldSystemFontOfSize:18];
    titleLable.backgroundColor = [FFColorManager blue_dark];
    titleLable.textColor = kWhiteColor;

    //关闭按钮
    [UIButton hyb_buttonWithImage:@"Game_repaire_close" superView:backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView).offset(2);
        make.right.mas_equalTo(backView).offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    } touchUp:^(UIButton *sender) {
        [self respondsToCloseButton];
    }];

    //line
    [UIView hyb_addBottomLineToView:titleLable height:1 color:[FFColorManager view_separa_line_color]];


    //安装按钮
    UIButton *downLoadButton = [UIButton hyb_buttonWithTitle:@"下载" superView:backView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backView).offset(-10);
        make.left.mas_equalTo(backView).offset(20);
        make.right.mas_equalTo(backView).offset(-20);
        make.height.mas_equalTo(44);
    } touchUp:^(UIButton *sender) {
        [self downloadGame];
    }];
    downLoadButton.layer.cornerRadius = 8;
    downLoadButton.layer.masksToBounds = YES;
    downLoadButton.backgroundColor = [FFColorManager blue_dark];

    //信任设备  http://foo.com/hello.mobileprovision
    UIButton *faithButton = [UIButton hyb_buttonWithTitle:@"信任设备" superView:backView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(downLoadButton.mas_top).offset(-10);
        make.left.mas_equalTo(backView).offset(20);
        make.right.mas_equalTo(backView).offset(-20);
        make.height.mas_equalTo(44);
    } touchUp:^(UIButton *sender) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://p.185sy.com/embedded.mobileprovision"]];
    }];
    faithButton.layer.cornerRadius = 8;
    faithButton.layer.borderColor = [FFColorManager blue_dark].CGColor;
    faithButton.layer.borderWidth = 1;
    [faithButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];

    //提示标签
    UILabel *label1 = [UILabel hyb_labelWithText:@"      正在为您下载,点击[安装]后,可按home键在桌面查看进度." font:15 superView:backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLable.mas_bottom).offset(10);
        make.left.mas_equalTo(backView).offset(20);
        make.right.mas_equalTo(backView).offset(-20);
    }];
    label1.textColor = [FFColorManager textColorMiddle];
    label1.numberOfLines = 0;

    UILabel *label2 = [UILabel hyb_labelWithText:@"      由于iOS9以后系统限制,安装完毕后,点击[信任设备],即可正常游戏" font:15 superView:backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).offset(10);
        make.left.mas_equalTo(backView).offset(20);
        make.right.mas_equalTo(backView).offset(-20);
    }];
    label2.textColor = [FFColorManager textColorMiddle];
    label2.numberOfLines = 0;
}


/** 关闭页面 */
- (void)respondsToCloseButton  {
    [self hide];
}

/** 下载游戏 */
- (void)downloadGame {
    syLog(@"下载游戏");
    if ([Channel isEqualToString:@"185"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CURRENT_GAME.game_download_url]];
    } else {
        [FFGameModel getGameDownloadUrlWithTag:CURRENT_GAME.game_tag Completion:^(NSDictionary * _Nonnull content, BOOL success) {
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
    BoxcustomEvents(@"down_laod_game", @{@"game_name":CURRENT_GAME.game_name,@"game_id":CURRENT_GAME.game_id});
}




@end





























