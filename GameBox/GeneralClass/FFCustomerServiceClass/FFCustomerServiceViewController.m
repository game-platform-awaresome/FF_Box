//
//  FFCustomerServiceViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFCustomerServiceViewController.h"
#import "FFUserModel.h"

#define NAVGATION_BAR_HEIGHT CGRectGetMaxY(self.navigationController.navigationBar.frame)
#define LABEL_HEIGHT kSCREEN_WIDTH * 0.139
#define TITLE_WIDTH kSCREEN_WIDTH / 2.7

@interface FFCustomerServiceViewController ()

/** 工作时间 */
@property (nonatomic, strong) UIView *timeBackgroundView;
/** 数据 */
@property (nonatomic, strong) NSDictionary *dataDict;

/** 手游客服 */
@property (nonatomic, strong) UIView *mobileCustomerServiceView;
@property (nonatomic, strong) UILabel *mobileCustomerServiceQQLabel;
@property (nonatomic, strong) UIButton *mobileCustomerServiceButton;

/** 返利客服 */
@property (nonatomic, strong) UIView *rebateCustomerServiceView;
@property (nonatomic, strong) UILabel *rebateCustomerServiceQQLabel;
@property (nonatomic, strong) UIButton *rebateCustomerServiceButton;

/** 手游玩家 QQ 群 */
@property (nonatomic, strong) UIView *playerCustomerServiceView;
@property (nonatomic, strong) UILabel *playerCustomerServiceQQLabel;
@property (nonatomic, strong) UIButton *playerCustomerServiceButton;

/** 游戏盒子 QQ 群 */
@property (nonatomic, strong) UIView *boxCustomerServiceView;
@property (nonatomic, strong) UILabel *boxCustomerServiceQQLabel;
@property (nonatomic, strong) UIButton *boxCustomerServiceButton;

/** 下部视图 */
@property (nonatomic, strong) UIView *downView;

@end

@implementation FFCustomerServiceViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if ([self getServiceData]) {
        self.dataDict = [self getServiceData];
    }
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [FFColorManager tabbarColor];
    self.navigationItem.title = @"客服中心";
    [self.view addSubview:self.timeBackgroundView];
    [self.view addSubview:self.mobileCustomerServiceView];
    [self.view addSubview:self.rebateCustomerServiceView];
    [self.view addSubview:self.playerCustomerServiceView];
    [self.view addSubview:self.boxCustomerServiceView];
    [self.view addSubview:self.downView];
}

- (void)initDataSource {
    [self startWaiting];
    [FFUserModel customerServiceWithCompletion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        syLog(@"customer service == %@",content);
        if (success) {
            self.dataDict = content[@"data"];
            [self saveServiceData:self.dataDict];
        } else  {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - responds
- (void)respondsToMobileQQButton {
    NSDictionary *data = self.dataDict[@"shouyou_qq"];
    NSString *urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",data[@"number"]];
    [self openUrl:urlStr];
}

- (void)respondsToRebateQQButton {
    NSDictionary *data = self.dataDict[@"fanli_qq"];
    NSString *urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",data[@"number"]];
    [self openUrl:urlStr];
}

- (void)respondsToPlayerQQButton {
    NSDictionary *data = self.dataDict[@"shouyou_group"];
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", data[@"number"],data[@"link"]];
    [self openUrl:urlStr];
}

- (void)respondsToBoxQQButton {
    NSDictionary *data = self.dataDict[@"box_group"];
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", data[@"number"],data[@"link"]];
    [self openUrl:urlStr];
}

- (void)openUrl:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - save service
- (void)saveServiceData:(NSDictionary *)dict {
    [dict writeToFile:[self filePath] atomically:YES];
}

- (NSDictionary *)getServiceData {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
    return dict;
}

- (NSString *)filePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"FFServiceData.plist"];
    return filePath;
}

#pragma mark - setter
- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    self.mobileCustomerServiceQQLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"shouyou_qq"][@"number"]];
    self.rebateCustomerServiceQQLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"fanli_qq"][@"number"]];
    self.playerCustomerServiceQQLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"shouyou_group"][@"number"]];
    self.boxCustomerServiceQQLabel.text = [NSString stringWithFormat:@"%@",dataDict[@"box_group"][@"number"]];
}

#pragma mark - getter
- (UIView *)timeBackgroundView {
    if (!_timeBackgroundView) {
        _timeBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVGATION_BAR_HEIGHT, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.324)];
        _timeBackgroundView.backgroundColor = [UIColor whiteColor];

        UIImageView *logo = [[UIImageView alloc] init];
        logo.frame = CGRectMake(kSCREEN_WIDTH * 0.05, kSCREEN_WIDTH * 0.037, kSCREEN_WIDTH * 0.088, kSCREEN_WIDTH * 0.088 * 0.88);
        //        logo.backgroundColor = [UIColor orangeColor];
        logo.image = [UIImage imageNamed:@"New_customer_service_logo"];
        [_timeBackgroundView addSubview:logo];

        UILabel *title = [[UILabel alloc] init];
        title.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 2, 20);
        title.center = CGPointMake(CGRectGetMaxX(logo.frame) + title.bounds.size.width / 2 + 8, logo.center.y);
        title.text = @"客服在线时间:";
        title.font = [UIFont systemFontOfSize:16];
        [_timeBackgroundView addSubview:title];

        UILabel *workTitle = [[UILabel alloc] init];
        workTitle.frame = CGRectMake(kSCREEN_WIDTH * 0.35, CGRectGetMaxY(title.frame) + 4, kSCREEN_WIDTH / 2, 20);
        workTitle.numberOfLines = 1;
        workTitle.text = @"工作日:";
        workTitle.font = [UIFont systemFontOfSize:14];
        [workTitle sizeToFit];
        [_timeBackgroundView addSubview:workTitle];

        UILabel *workTime1 = [[UILabel alloc] init];
        workTime1.frame = CGRectMake(CGRectGetMaxX(workTitle.frame), CGRectGetMinY(workTitle.frame), kSCREEN_WIDTH / 3, 60);
        workTime1.numberOfLines = 2;
        workTime1.text = @"09:00 - 12:00\n13:30 - 18:30";
        workTime1.font = [UIFont systemFontOfSize:14];
        [workTime1 sizeToFit];
        [_timeBackgroundView addSubview:workTime1];

        UILabel *holidayTitle = [[UILabel alloc] init];
        holidayTitle.frame = CGRectMake(CGRectGetMinX(workTitle.frame), CGRectGetMaxY(workTime1.frame) + 2, 20, 20);
        holidayTitle.text = @"节假日:";
        holidayTitle.font = [UIFont systemFontOfSize:14];
        [holidayTitle sizeToFit];
        [_timeBackgroundView addSubview:holidayTitle];

        UILabel *holidayTime = [[UILabel alloc] init];
        holidayTime.frame = CGRectMake(CGRectGetMaxX(holidayTitle.frame), CGRectGetMinY(holidayTitle.frame), kSCREEN_WIDTH / 3, 20);
        holidayTime.numberOfLines = 1;
        holidayTime.text = @"09:00 - 22:30";
        holidayTime.font = [UIFont systemFontOfSize:14];
        [holidayTime sizeToFit];
        [_timeBackgroundView addSubview:holidayTime];


    }
    return _timeBackgroundView;
}

- (UIView *)mobileCustomerServiceView {
    if (!_mobileCustomerServiceView) {
        _mobileCustomerServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeBackgroundView.frame) + 2, kSCREEN_WIDTH, LABEL_HEIGHT)];
        _mobileCustomerServiceView.backgroundColor = [UIColor whiteColor];

        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, TITLE_WIDTH, LABEL_HEIGHT);
        title.text = @"    手游客服QQ :";
        title.textAlignment = NSTextAlignmentLeft;
        [_mobileCustomerServiceView addSubview:title];
        [_mobileCustomerServiceView addSubview:self.mobileCustomerServiceQQLabel];
        [_mobileCustomerServiceView addSubview:self.mobileCustomerServiceButton];
    }
    return _mobileCustomerServiceView;
}

- (UILabel *)mobileCustomerServiceQQLabel {
    if (!_mobileCustomerServiceQQLabel) {
        _mobileCustomerServiceQQLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_WIDTH, 0, kSCREEN_WIDTH / 3, LABEL_HEIGHT)];
        _mobileCustomerServiceQQLabel.textAlignment = NSTextAlignmentCenter;
        _mobileCustomerServiceQQLabel.text = @"";
    }
    return _mobileCustomerServiceQQLabel;
}


- (UIButton *)mobileCustomerServiceButton {
    if (!_mobileCustomerServiceButton) {
        _mobileCustomerServiceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

        [self setContactButton:_mobileCustomerServiceButton];
        [_mobileCustomerServiceButton addTarget:self action:@selector(respondsToMobileQQButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _mobileCustomerServiceButton;
}


/** 返利 */
- (UIView *)rebateCustomerServiceView {
    if (!_rebateCustomerServiceView) {
        _rebateCustomerServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mobileCustomerServiceView.frame) + 2, kSCREEN_WIDTH, LABEL_HEIGHT)];
        _rebateCustomerServiceView.backgroundColor = [UIColor whiteColor];

        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, TITLE_WIDTH, LABEL_HEIGHT);
        title.text = @"    返利客服QQ :";
        title.textAlignment = NSTextAlignmentLeft;
        [_rebateCustomerServiceView addSubview:title];
        [_rebateCustomerServiceView addSubview:self.rebateCustomerServiceQQLabel];
        [_rebateCustomerServiceView addSubview:self.rebateCustomerServiceButton];
    }
    return _rebateCustomerServiceView;
}

- (UILabel *)rebateCustomerServiceQQLabel {
    if (!_rebateCustomerServiceQQLabel) {
        _rebateCustomerServiceQQLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_WIDTH, 0, kSCREEN_WIDTH / 3, LABEL_HEIGHT)];
        _rebateCustomerServiceQQLabel.textAlignment = NSTextAlignmentCenter;
        _rebateCustomerServiceQQLabel.text = @"";
    }
    return _rebateCustomerServiceQQLabel;
}

- (UIButton *)rebateCustomerServiceButton {
    if (!_rebateCustomerServiceButton) {
        _rebateCustomerServiceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self setContactButton:_rebateCustomerServiceButton];
        [_rebateCustomerServiceButton addTarget:self action:@selector(respondsToRebateQQButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rebateCustomerServiceButton;
}

/** player */
- (UIView *)playerCustomerServiceView {
    if (!_playerCustomerServiceView) {
        _playerCustomerServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.rebateCustomerServiceView.frame) + 2, kSCREEN_WIDTH, LABEL_HEIGHT)];
        _playerCustomerServiceView.backgroundColor = [UIColor whiteColor];

        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, TITLE_WIDTH, LABEL_HEIGHT);
        title.text = @"    手游玩家QQ群 :";
        title.textAlignment = NSTextAlignmentLeft;

        [_playerCustomerServiceView addSubview:title];
        [_playerCustomerServiceView addSubview:self.playerCustomerServiceQQLabel];
        [_playerCustomerServiceView addSubview:self.playerCustomerServiceButton];
    }
    return _playerCustomerServiceView;
}

- (UILabel *)playerCustomerServiceQQLabel {
    if (!_playerCustomerServiceQQLabel) {
        _playerCustomerServiceQQLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_WIDTH, 0, kSCREEN_WIDTH / 3, LABEL_HEIGHT)];
        _playerCustomerServiceQQLabel.textAlignment = NSTextAlignmentCenter;
        _playerCustomerServiceQQLabel.text = @"";
    }
    return _playerCustomerServiceQQLabel;
}

- (UIButton *)playerCustomerServiceButton {
    if (!_playerCustomerServiceButton) {
        _playerCustomerServiceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self setContactButton:_playerCustomerServiceButton];
        [_playerCustomerServiceButton setTitle:@"进群" forState:(UIControlStateNormal)];
        [_playerCustomerServiceButton addTarget:self action:@selector(respondsToPlayerQQButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _playerCustomerServiceButton;
}

/** 盒子群 */
- (UIView *)boxCustomerServiceView {
    if (!_boxCustomerServiceView) {
        _boxCustomerServiceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playerCustomerServiceView.frame) + 2, kSCREEN_WIDTH, LABEL_HEIGHT)];
        _boxCustomerServiceView.backgroundColor = [UIColor whiteColor];

        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(0, 0, TITLE_WIDTH, LABEL_HEIGHT);
        title.text = @"    游戏盒子QQ群 :";
        title.textAlignment = NSTextAlignmentLeft;

        [_boxCustomerServiceView addSubview:title];
        [_boxCustomerServiceView addSubview:self.boxCustomerServiceQQLabel];
        [_boxCustomerServiceView addSubview:self.boxCustomerServiceButton];
    }
    return _boxCustomerServiceView;
}

- (UILabel *)boxCustomerServiceQQLabel {
    if (!_boxCustomerServiceQQLabel) {
        _boxCustomerServiceQQLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_WIDTH, 0, kSCREEN_WIDTH / 3, LABEL_HEIGHT)];
        _boxCustomerServiceQQLabel.textAlignment = NSTextAlignmentCenter;
        _boxCustomerServiceQQLabel.text = @"";
    }
    return _boxCustomerServiceQQLabel;
}

- (UIButton *)boxCustomerServiceButton {
    if (!_boxCustomerServiceButton) {
        _boxCustomerServiceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self setContactButton:_boxCustomerServiceButton];
        [_boxCustomerServiceButton setTitle:@"进群" forState:(UIControlStateNormal)];
        [_boxCustomerServiceButton addTarget:self action:@selector(respondsToBoxQQButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _boxCustomerServiceButton;
}

- (UIView *)downView {
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.boxCustomerServiceView.frame) + 2, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.boxCustomerServiceView.frame) - 2)];
        _downView.backgroundColor = [UIColor whiteColor];

        UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, 80)];
        remindLabel.backgroundColor = [FFColorManager tabbarColor];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.text = @"线上反馈,客服将在24小时内答复您";

        [_downView addSubview:remindLabel];
    }
    return _downView;
}

- (void)setContactButton:(UIButton *)button {
    [button setTitle:@"联系" forState:(UIControlStateNormal)];
    button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 6, LABEL_HEIGHT / 3 * 2);
    button.center = CGPointMake(kSCREEN_WIDTH / 8 * 7, LABEL_HEIGHT / 2);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [FFColorManager blue_dark].CGColor;
    button.layer.borderWidth = 1;
}










@end
