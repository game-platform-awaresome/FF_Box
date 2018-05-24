//
//  FFGoldCenterViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGoldCenterViewController.h"
#import "FFLotteryViewController.h"
#import "FFGoldDetailViewController.h"
#import "FFExchangeCoinController.h"
#import "FFUserModel.h"

@interface FFGoldCenterViewController ()

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UILabel *uptitle;
/** 余额 */
@property (nonatomic, strong) UILabel *balanceLabel;
/** 今日收益 */
@property (nonatomic, strong) UILabel *todayLabel;
/** 本月收益 */
@property (nonatomic, strong) UILabel *monthLabel;


/** 马上有钱 */
@property (nonatomic, strong) UILabel *quickMoney;
@property (nonatomic, strong) UILabel *remindLabel1;
@property (nonatomic, strong) UILabel *remindLabel2;

//抽奖按钮
@property (nonatomic, strong) UIButton *lotteryButton;

@property (nonatomic, strong) UIView *whitView1;

@property (nonatomic, strong) UILabel *remindLabel3;
@property (nonatomic, strong) UILabel *remindLabel4;
@property (nonatomic, strong) UIButton *exchangeButton;

@property (nonatomic, strong) UIView *whitView2;


/**  ================================ */
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) UIBarButtonItem *coinDetailButton;

/** 金币明细页 */
@property (nonatomic, strong) FFGoldDetailViewController *goldDetailViewController;
/** 抽奖页 */
@property (nonatomic, strong) FFLotteryViewController *lotteryViewController;
/** 兑换平台币 */
@property (nonatomic, strong) FFExchangeCoinController *exchangeViewController;


@end

@implementation FFGoldCenterViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.navigationItem.title = @"金币中心";

    [self.view addSubview:self.upView];
    [self.view addSubview:self.quickMoney];
    [self.view addSubview:self.remindLabel1];
    [self.view addSubview:self.remindLabel2];
    [self.view addSubview:self.lotteryButton];
    [self.view addSubview:self.whitView1];
    [self.view addSubview:self.remindLabel3];
    [self.view addSubview:self.remindLabel4];
    [self.view addSubview:self.exchangeButton];
    [self.view addSubview:self.whitView2];
}

#pragma mark - method
- (void)refreshData {
    [self startWaiting];
    self.navigationItem.rightBarButtonItem = nil;
    [FFUserModel coinCenterWithCompletion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        if (success) {
            syLog(@"coin center === %@",content);
            [self setBalance:content[@"data"][@"user_counts"]];
            [self setToday:content[@"data"][@"today_coin"]];
            [self setMonth:content[@"data"][@"month_coin"]];
            self.navigationItem.rightBarButtonItem = self.coinDetailButton;
        } else {
            self.navigationItem.rightBarButtonItem = self.refreshButton;
        }
    }];
}



#pragma mark - responds
- (void)respondsToLotteryButton {
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.lotteryViewController animated:YES];
}

- (void)respondsToExchangeButton {
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.exchangeViewController setMygoldNumber:self.balanceLabel.text];
    [self.navigationController pushViewController:self.exchangeViewController animated:YES];
}

- (void)respondsToRefreshButton {
    [self initDataSource];
}

- (void)respondsToCoindetailButton {
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.goldDetailViewController animated:YES];
}

#pragma mark - setter
- (void)setBalance:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length > 0) {
        self.balanceLabel.text = string;
    } else {
        self.balanceLabel.text = @"0";
    }
}

- (void)setToday:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length > 0) {
        self.todayLabel.text = string;
    } else {
        self.todayLabel.text = @"0";
    }
}

- (void)setMonth:(NSString *)string {
    string = [NSString stringWithFormat:@"%@",string];
    if (string.length > 0) {
        self.monthLabel.text = string;
    } else {
        self.monthLabel.text = @"0";
    }
}

#pragma mark - getter
- (UIView *)upView {
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT + 10, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.3)];
        _upView.backgroundColor = [UIColor whiteColor];

        _uptitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.1)];
        _uptitle.text = @"  我的金币:";
        _uptitle.font = [UIFont systemFontOfSize:18];
        [_upView addSubview:_uptitle];

        //余额
        UIView *balanceView = [self creatViewWith:CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(_uptitle.frame) + kSCREEN_WIDTH * 0.06) Title:@"    余额"];
        [balanceView addSubview:self.balanceLabel];
        [_upView addSubview:balanceView];

        //今日收益
        UIView *todayView = [self creatViewWith:CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(balanceView.frame) + kSCREEN_WIDTH * 0.08) Title:@"    今日收益"];
        [todayView addSubview:self.todayLabel];
        [_upView addSubview:todayView];

        //本月收益
        UIView *monthView = [self creatViewWith:CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(todayView.frame) + kSCREEN_WIDTH * 0.08) Title:@"    本月收益"];
        [monthView addSubview:self.monthLabel];
        [_upView addSubview:monthView];


        syLog(@"screen width === %lf",kSCREEN_WIDTH);
    }
    return _upView;
}

- (UIView *)creatViewWith:(CGPoint)center Title:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, kSCREEN_WIDTH * 0.13);
    view.center = center;
    view.backgroundColor = BACKGROUND_COLOR;
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH * 0.13)];
    titleLabel.text = title;
    [view addSubview:titleLabel];

    return view;
}

- (UILabel *)quickMoney {
    if (!_quickMoney) {
        _quickMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.upView.frame) + 2, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.08)];
        _quickMoney.text = @"     马上有钱";
        _quickMoney.backgroundColor = [UIColor whiteColor];

    }
    return _quickMoney;
}

- (UILabel *)remindLabel1 {
    if (!_remindLabel1) {
        _remindLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.quickMoney.frame) + kSCREEN_WIDTH * 0.03, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.1)];
        _remindLabel1.textAlignment = NSTextAlignmentCenter;
        _remindLabel1.text = @"金币抽奖";
    }
    return _remindLabel1;
}

- (UILabel *)remindLabel2 {
    if (!_remindLabel2) {
        _remindLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remindLabel1.frame), kSCREEN_WIDTH, kSCREEN_WIDTH * 0.1)];
        _remindLabel2.textAlignment = NSTextAlignmentCenter;
        _remindLabel2.text = @"金币抽奖可以获得高额平台币和话费等奖励";
    }
    return _remindLabel2;
}

- (UIButton *)lotteryButton {
    if (!_lotteryButton) {
        _lotteryButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _lotteryButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, kSCREEN_WIDTH * 0.13);
        _lotteryButton.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.remindLabel2.frame) + kSCREEN_WIDTH * 0.08);
        [_lotteryButton addTarget:self action:@selector(respondsToLotteryButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_lotteryButton setBackgroundColor:[FFColorManager blue_dark]];
        [_lotteryButton setTitle:@"立即抽奖" forState:(UIControlStateNormal)];
        [_lotteryButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];
        _lotteryButton.layer.cornerRadius = 8;
        _lotteryButton.layer.masksToBounds = YES;
    }
    return _lotteryButton;
}

- (UIView *)whitView1 {
    if (!_whitView1) {
        _whitView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lotteryButton.frame) + kSCREEN_WIDTH * 0.03, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.05)];
        _whitView1.backgroundColor = [UIColor whiteColor];
    }
    return _whitView1;
}

- (UILabel *)remindLabel3 {
    if (!_remindLabel3) {
        _remindLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.whitView1.frame) + kSCREEN_WIDTH * 0.03, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.1)];
        _remindLabel3.text = @"平台币兑换";
        _remindLabel3.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLabel3;
}

- (UILabel *)remindLabel4 {
    if (!_remindLabel4) {
        _remindLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remindLabel3.frame), kSCREEN_WIDTH, kSCREEN_WIDTH * 0.1)];
        _remindLabel4.text = @"在游戏充值时可以使用平台币支付";
        _remindLabel4.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLabel4;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _exchangeButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, kSCREEN_WIDTH * 0.13);
        _exchangeButton.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.remindLabel4.frame) + kSCREEN_WIDTH * 0.08);
        [_exchangeButton addTarget:self action:@selector(respondsToExchangeButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_exchangeButton setBackgroundColor:[FFColorManager blue_dark]];
        [_exchangeButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];
        [_exchangeButton setTitle:@"立即兑换" forState:(UIControlStateNormal)];
        _exchangeButton.layer.cornerRadius = 8;
        _exchangeButton.layer.masksToBounds = YES;
    }
    return _exchangeButton;
}

- (UIView *)whitView2 {
    if (!_whitView2) {
        _whitView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.exchangeButton.frame) + kSCREEN_WIDTH * 0.03, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.exchangeButton.frame))];
        _whitView2.backgroundColor = [UIColor whiteColor];
    }
    return _whitView2;
}

#pragma mark 0
- (UILabel *)creatLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 3, 0, kSCREEN_WIDTH * 0.9 - kSCREEN_WIDTH / 3 - 20, kSCREEN_WIDTH * 0.13)];

    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor redColor];
    label.text = @"0";

    return label;
}
- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [self creatLabel];
    }
    return _balanceLabel;
}

- (UILabel *)todayLabel {
    if (!_todayLabel) {
        _todayLabel = [self creatLabel];
    }
    return _todayLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [self creatLabel];
    }
    return _monthLabel;
}

- (UIBarButtonItem *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRefreshButton)];
    }
    return _refreshButton;
}

- (UIBarButtonItem *)coinDetailButton {
    if (!_coinDetailButton) {
        _coinDetailButton = [[UIBarButtonItem alloc] initWithTitle:@"金币明细" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCoindetailButton)];
    }
    return _coinDetailButton;
}

- (FFGoldDetailViewController *)goldDetailViewController {
    if (!_goldDetailViewController) {
        _goldDetailViewController = [[FFGoldDetailViewController alloc] init];
    }
    return _goldDetailViewController;
}

- (FFLotteryViewController *)lotteryViewController {
    if (!_lotteryViewController) {
        _lotteryViewController = [[FFLotteryViewController alloc] init];
    }
    return _lotteryViewController;
}


- (FFExchangeCoinController *)exchangeViewController {
    if (!_exchangeViewController) {
        _exchangeViewController = [[FFExchangeCoinController alloc] init];
    }
    return _exchangeViewController;
}


@end












