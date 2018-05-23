//
//  FFInviteRankListViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/27.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFInviteRankListViewController.h"
#import "FFSelectHeaderView.h"

#import "FFTodayInviteListViewController.h"
#import "FFYesterDayListViewController.h"
#import "FFInviteListNotesController.h"


#import "FFInviteModel.h"
#import "FFSharedController.h"

#define FLOATSIZE 50

@interface FFInviteRankListViewController () <FFSelectHeaderViewDelegate>

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) FFSelectHeaderView *headerView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FFTodayInviteListViewController *todayListViewController;
@property (nonatomic, strong) FFYesterDayListViewController *yesterdayListViewController;

@property (nonatomic, assign) NSUInteger today_view_x;
@property (nonatomic, assign) NSUInteger yesterday_view_x;

@property (nonatomic, strong) UIBarButtonItem *noticeButton;

@property (nonatomic, strong) UIImageView *inviteImageView;


@end

@implementation FFInviteRankListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"1.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initDataSource];
    [self initUserInterface];
}


- (void)initDataSource {
    _today_view_x = 0;
    _yesterday_view_x = 1;
    self.headerView.headerTitleArray = @[@"今日排行",@"昨日排行"];

    [[FFInviteModel sharedModel] setCompletion:^(BOOL success, First_list_enum listEnum) {
        
        if (success) {
            self.todayListViewController.showArray = [FFInviteModel sharedModel].todayList.mutableCopy;
            self.yesterdayListViewController.showArray = [FFInviteModel sharedModel].yesterDayList.mutableCopy;

            if (listEnum == TodayFirst) {
                self.headerView.headerTitleArray = @[@"今日排行",@"昨日排行"];
                self.today_view_x = 0;
                self.yesterday_view_x = 1;
            } else {
                self.headerView.headerTitleArray = @[@"昨日排行",@"今日排行"];
                self.today_view_x = 1;
                self.yesterday_view_x = 0;
            }
            self.todayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.today_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
            self.yesterdayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.yesterday_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
        } else {
            [UIAlertController showAlertMessage:@"刷新失败" dismissTime:0.7 dismissBlock:nil];
        }

        [self.todayListViewController.tableView.mj_header endRefreshing];

        [self.yesterdayListViewController.tableView.mj_header endRefreshing];


        [self.yesterdayListViewController.tableView reloadData];
        [self.todayListViewController.tableView reloadData];
    }];



    [self addChildViewController:self.todayListViewController];
    [self addChildViewController:self.yesterdayListViewController];



    [[FFInviteModel sharedModel] setRewardBlock:^(BOOL success) {
        if (success) {
            [UIAlertController showAlertMessage:@"领取成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:@"领取失败,请刷新后尝试" dismissTime:0.7 dismissBlock:nil];
        }
    }];


}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"排行榜";
    self.navigationItem.rightBarButtonItem = self.noticeButton;
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.todayListViewController.view];
    [self.scrollView addSubview:self.yesterdayListViewController.view];
    [self.view addSubview:self.inviteImageView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.remindLabel.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 20);
    self.headerView.frame = CGRectMake(0, kNAVIGATION_HEIGHT + 20, kSCREEN_WIDTH, 60);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame));
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, kSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame));
    self.todayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.today_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.yesterdayListViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.yesterday_view_x, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
}

#pragma mark - header view delegate
- (void)FFSelectHeaderView:(FFSelectHeaderView *)view didSelectTitleWithIndex:(NSUInteger)idx {
    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0)];
}

- (void)respondsToNoticeButton {
    syLog(@"须知页面 ");
    FFInviteListNotesController *noticeVC = [FFInviteListNotesController new];
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:noticeVC animated:YES];
}

#pragma mark - GestureRecognize
- (void)respondsToInviteImageTap:(UITapGestureRecognizer *)sender {
    [FFSharedController inviteFriend];
}

- (void)respondsToInviteImagePan:(UIPanGestureRecognizer *)sender {
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [sender translationInView:self.view];

    CGFloat centerX = 0;
    CGFloat centerY = 0;

    centerX = self.inviteImageView.center.x + point.x;
    centerY = self.inviteImageView.center.y + point.y;

    CGFloat KWidth = kSCREEN_WIDTH;
    CGFloat KHeight = kSCREEN_HEIGHT;

    //确定特殊的centerY
    if (centerY - FLOATSIZE / 2 < kNAVIGATION_HEIGHT ) {
        centerY = FLOATSIZE / 2 + kNAVIGATION_HEIGHT;
    }

    if (centerY + FLOATSIZE / 2 > KHeight ) {
        centerY = KHeight - FLOATSIZE / 2;
    }

    //确定特殊的centerX
    if (centerX - FLOATSIZE / 2 < 0) {
        centerX = FLOATSIZE / 2;
    }
    if (centerX + FLOATSIZE / 2 > KWidth) {
        centerX = KWidth - FLOATSIZE / 2;
    }

    //设置悬浮窗的边界

    self.inviteImageView.center = CGPointMake(centerX, centerY);

    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        //判断是是否在边缘(在边缘的话隐藏)

    }
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

#pragma mark - getter
- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 20)];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.textColor = [FFColorManager blue_dark];
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.text = @"今日邀请人数 : 0";
    }
    return _remindLabel;
}
- (FFSelectHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFSelectHeaderView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 60)];
        _headerView.delegate = self;
        [_headerView setTitleSelectColor:[FFColorManager blue_dark]];
        [_headerView setCursorColor:[FFColorManager blue_dark]];
        _headerView.lineColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _headerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (FFTodayInviteListViewController *)todayListViewController {
    if (!_todayListViewController) {
        _todayListViewController = [[FFTodayInviteListViewController alloc] init];
    }
    return _todayListViewController;
}

- (FFYesterDayListViewController *)yesterdayListViewController {
    if (!_yesterdayListViewController) {
        _yesterdayListViewController = [[FFYesterDayListViewController alloc] init];
    }
    return _yesterdayListViewController;
}

- (UIBarButtonItem *)noticeButton {
    if (!_noticeButton) {
        _noticeButton = [[UIBarButtonItem alloc] initWithTitle:@"须知" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToNoticeButton)];
    }
    return _noticeButton;
}

- (UIImageView *)inviteImageView {
    if (!_inviteImageView) {
        _inviteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH * 0.8, self.view.bounds.size.height * 0.8, FLOATSIZE, FLOATSIZE)];
        //        _inviteImageView.backgroundColor = [UIColor redColor];
        _inviteImageView.image = [UIImage imageNamed:@"Mine_list_invte"];
        _inviteImageView.layer.cornerRadius = 25;
        _inviteImageView.layer.masksToBounds = YES;
        _inviteImageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToInviteImageTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_inviteImageView addGestureRecognizer:tap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToInviteImagePan:)];

        [_inviteImageView addGestureRecognizer:pan];

    }
    return _inviteImageView;
}



@end














