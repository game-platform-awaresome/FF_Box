//
//  FFOpenVipViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFOpenVipViewController.h"
#import "FFPayModel.h"
#import "FFWebViewController.h"
#import "FFUserModel.h"
#import "FFStatisticsModel.h"

#define CELL_IDE @"openVipViewCell"
#define BUTTON_TAG 10086

@interface FFOpenVipViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *showArray;
@property (nonatomic, strong) UIView *amontView;

/** 选择月份 */
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *selectButtons;
@property (nonatomic, strong) UIButton *lastSelectButton;

@property (nonatomic, assign) NSInteger cellIndex;

/** 支付金额 */
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) NSArray *amountArray;
/** 原价 */
@property (nonatomic, strong) UILabel *oriLabel;
@property (nonatomic, strong) NSArray *oriArray;

/** 返还平台币 */
@property (nonatomic, strong) UILabel *returnCointlabel;

/** 支付按钮 */
@property (nonatomic, strong) UIButton *payButton;

@end

@implementation FFOpenVipViewController {
    NSString *_amount;
    NSString *_payType;
    NSUInteger _quereTime;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self refreshData];
}

- (void)refreshData {
    [self startWaiting];
    [FFUserModel vipGetOptionWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"vip option === %@",content);
        [self stopWaiting];
        if (success) {
            self.vipOptionArray = content[@"data"];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _cellIndex = 0;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"开通 VIP";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.amontView];
}

- (void)setVipOptionArray:(NSArray *)vipOptionArray {
    _vipOptionArray = vipOptionArray;
    [self setTableHeader];
    [self resPondsToSelectButton:self.selectButtons[0]];
}

#pragma mark - responds to select buttons
- (void)resPondsToSelectButton:(UIButton *)sender {
    syLog(@"did select button");
    self.lastSelectButton = sender;
}

- (void)respondsToPayButton {
    NSDictionary *dict = self.vipOptionArray[_lastSelectButton.tag - BUTTON_TAG];

    syLog(@"zhifu   ==== %@",dict);
    [FFPayModel payReadyWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            syLog(@"可以支付");
            customEvents(@"open_vip_action", nil);

            [FFPayModel payStartWithproductID:dict[@"productID"] payType:[NSString stringWithFormat:@"%ld",(_cellIndex + 1)] amount:dict[@"money"] Completion:^(NSDictionary *content, BOOL success) {
                syLog(@"支付 ?????????????");
                if (success) {
                    _payType = [NSString stringWithFormat:@"%ld",(_cellIndex + 1)];
                    _amount = dict[@"money"];

                    statisticsPayStart(content[@"data"][@"orderID"], _payType, _amount);

                    FFWebViewController *web = [[FFWebViewController alloc] init];
                    NSDictionary *dict = content[@"data"];
                    [web setWebURL:dict[@"url"]];
                    HIDE_TABBAR;
                    HIDE_PARNENT_TABBAR;
                    [self.navigationController pushViewController:web animated:YES];
                    _quereTime = 0;
                    [self payQuereWithOrderID:content[@"data"][@"orderID"]];
                } else {

                }
                syLog(@"pay ==== %@",content);
            }];

        }
    }];

    syLog(@"开通会员");
}

- (void)payQuereWithOrderID:(NSString *)orderID {
    syLog(@"支付查询");
    if (_quereTime > 30) {
        return;
    }
    _quereTime++;
    [FFPayModel payQueryWithOrderID:orderID Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            syLog(@"支付查询成功 %@",content);
            NSDictionary *dict = content[@"data"];
            NSString *status = dict[@"order_status"];
            if (status.integerValue == 1 || status.integerValue == 2) {
                statisticsPayCallBack(orderID, _payType, _amount);
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self payQuereWithOrderID:orderID];
                });
            }
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self payQuereWithOrderID:orderID];
            });
        }
    }];
}

- (void)setTableHeader {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 60)];
    titleView.backgroundColor = [UIColor whiteColor];

    UIImageView *titleImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    titleImageview.image = [UIImage imageNamed:@"New_vip_titleimage"];
    titleImageview.center = CGPointMake(30, 30);
    [titleView addSubview:titleImageview];

    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(CGRectGetMaxX(titleImageview.frame) + 5, 0, kSCREEN_WIDTH - CGRectGetMaxX(titleImageview.frame), 60);
    title.text = @"超级会员享受更多福利特权";
    title.font = [UIFont systemFontOfSize:17];
    [titleView addSubview:title];

    [self.tableHeaderView addSubview:titleView];
    [self.tableHeaderView addSubview:self.selectView];
    CGRect frame = self.tableHeaderView.frame;
    frame.size.height = CGRectGetMaxY(self.selectView.frame) + 2;
    self.tableHeaderView.frame = frame;
}

#pragma mark - table View data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CELL_IDE];
    }


    cell.textLabel.text = self.showArray[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == _cellIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _cellIndex = indexPath.row;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - setter
- (void)setLastSelectButton:(UIButton *)lastSelectButton {
    if (_lastSelectButton == nil) {
        _lastSelectButton = lastSelectButton;
    } else {
        _lastSelectButton.selected = NO;
        _lastSelectButton.layer.borderColor = [UIColor blackColor].CGColor;
    }

    lastSelectButton.selected = YES;
    lastSelectButton.layer.borderColor = [UIColor orangeColor].CGColor;
    NSInteger index = lastSelectButton.tag - BUTTON_TAG;


    self.amountLabel.text = [NSString stringWithFormat:@"%@",_vipOptionArray[index][@"money"]];
    self.returnCointlabel.text = [NSString stringWithFormat:@"返 %@ 平台币",_vipOptionArray[index][@"ptb"]];
    [self setOriLabelAtrString:[NSString stringWithFormat:@"原价%@元",_vipOptionArray[index][@"costMoney"]]];

    //    [self.returnCointlabel sizeToFit];




    _lastSelectButton = lastSelectButton;

}

- (void)setOriLabelAtrString:(NSString *)str {
    self.oriLabel.text = str;
    [self.oriLabel sizeToFit];
    self.oriLabel.center = CGPointMake(CGRectGetMaxX(self.amountLabel.frame) + self.oriLabel.bounds.size.width / 2 + 25, self.tabBarController.tabBar.frame.size.height / 2);
    if (str == nil) {
        return;
    }
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:self.oriLabel.text];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    [newPrice addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, newPrice.length)];
    [newPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, newPrice.length)];
    self.oriLabel.attributedText = newPrice;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 130) style:(UITableViewStylePlain)];

        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];


        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.bounces = NO;

        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.583 + 65)];
        _tableHeaderView.backgroundColor = BACKGROUND_COLOR;
    }
    return _tableHeaderView;
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, kSCREEN_WIDTH, self.tableHeaderView.frame.size.height - 70)];
        _selectView.backgroundColor = [UIColor whiteColor];

        NSArray *titleArray = @[@"1个月",@"2个月",@"3个月",@"6个月",@"12个月"];
        _selectButtons = [NSMutableArray arrayWithCapacity:titleArray.count];

        [self.vipOptionArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {

            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 4, kSCREEN_WIDTH * 0.1);
            button.center = CGPointMake(kSCREEN_WIDTH / 6 * (((idx % 3) * 2) + 1), kSCREEN_WIDTH * 0.085 * (((idx / 3) * 2) + 1));
            [button setTitle:[NSString stringWithFormat:@"%@个月",obj[@"month"]] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateSelected)];

            button.tag = BUTTON_TAG + idx;

            [button addTarget:self action:@selector(resPondsToSelectButton:) forControlEvents:(UIControlEventTouchUpInside)];

            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.cornerRadius = 4;
            button.layer.masksToBounds = YES;

            [_selectButtons addObject:button];

            [_selectView addSubview:button];
        }];


        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selectButtons.firstObject.frame), CGRectGetMaxY(_selectButtons.lastObject.frame) + 15, kSCREEN_WIDTH / 2, 20)];
        label1.text = @"1.购买超级会员立即返平台币";
        label1.font = [UIFont systemFontOfSize:14];
        [label1 sizeToFit];
        [_selectView addSubview:label1];

        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selectButtons[0].frame), CGRectGetMaxY(label1.frame), kSCREEN_WIDTH / 2, 20)];
        label2.text = @"2.超级会员每日签到额外领取66金币";
        label2.font = [UIFont systemFontOfSize:14];
        [label2 sizeToFit];
        [_selectView addSubview:label2];

        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selectButtons[0].frame), CGRectGetMaxY(label2.frame), kSCREEN_WIDTH / 2, 20)];
        label3.text = @"3.开通超级会员,每日游戏好评享三倍奖励";
        label3.font = [UIFont systemFontOfSize:14];
        [label3 sizeToFit];
        [_selectView addSubview:label3];

        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selectButtons[0].frame), CGRectGetMaxY(label3.frame), kSCREEN_WIDTH / 2, 20)];
        label4.text = @"4.超级会员更多福利敬请期待";
        label4.font = [UIFont systemFontOfSize:14];
        [label4 sizeToFit];
        [_selectView addSubview:label4];

        _selectView.frame = CGRectMake(0, 68, kSCREEN_WIDTH, CGRectGetMaxY(label4.frame) + 15);
    }
    return _selectView;
}

- (UIView *)amontView {
    if (!_amontView) {
        _amontView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 128, kSCREEN_WIDTH, 128)];

        _amontView.backgroundColor = [UIColor whiteColor];


        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.bounds = CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.height / 3 * 2, self.tabBarController.tabBar.frame.size.height / 3 * 2);
        imageView.center = CGPointMake(self.tabBarController.tabBar.frame.size.height / 2, self.tabBarController.tabBar.frame.size.height / 2);
        imageView.image = [UIImage imageNamed:@"New_amount_money"];
        [_amontView addSubview:imageView];

        self.amountLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame), 0, kSCREEN_WIDTH / 6, _amontView.bounds.size.height);
        self.amountLabel.center = CGPointMake(self.amountLabel.center.x, imageView.center.y);
        //        self.amountLabel.text = @"0";
        [_amontView addSubview:self.amountLabel];

        UILabel *yuan = [[UILabel alloc] init];
        yuan.text = @"元";
        yuan.font = [UIFont systemFontOfSize:16];
        [yuan sizeToFit];
        yuan.center = CGPointMake(CGRectGetMaxX(self.amountLabel.frame), self.tabBarController.tabBar.frame.size.height / 2);
        [_amontView addSubview:yuan];

        //        self.oriLabel.text = @"原价30元";
        [self setOriLabelAtrString:self.oriLabel.text];
        [_amontView addSubview:self.oriLabel];

        self.returnCointlabel.frame = CGRectMake(CGRectGetMaxX(self.oriLabel.frame), 0, kSCREEN_WIDTH - CGRectGetMaxX(self.oriLabel.frame), self.tabBarController.tabBar.frame.size.height);

        [_amontView addSubview:self.returnCointlabel];

        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, self.tabBarController.tabBar.frame.size.height, kSCREEN_WIDTH, 2);
        layer.backgroundColor = BACKGROUND_COLOR.CGColor;
        [_amontView.layer addSublayer:layer];

        [_amontView addSubview:self.payButton];
    }
    return _amontView;
}


- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.textColor = [UIColor redColor];
        _amountLabel.font = [UIFont systemFontOfSize:20];
    }
    return _amountLabel;
}

- (UILabel *)oriLabel {
    if (!_oriLabel) {
        _oriLabel = [[UILabel alloc] init];
        _oriLabel.textAlignment = NSTextAlignmentCenter;
        _oriLabel.textColor = [UIColor lightGrayColor];
        _oriLabel.font = [UIFont systemFontOfSize:16];
    }
    return _oriLabel;
}


- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _payButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _payButton.center = CGPointMake(kSCREEN_WIDTH / 2, 96);
        _payButton.layer.cornerRadius = 8;
        _payButton.layer.masksToBounds = YES;
        [_payButton setTitle:@"立即开通" forState:(UIControlStateNormal)];
        [_payButton addTarget:self action:@selector(respondsToPayButton) forControlEvents:(UIControlEventTouchUpInside)];
        _payButton.backgroundColor = [FFColorManager blue_dark];
    }
    return _payButton;
}

- (UILabel *)returnCointlabel {
    if (!_returnCointlabel) {
        _returnCointlabel = [[UILabel alloc] init];

        _returnCointlabel.textAlignment = NSTextAlignmentCenter;
        _returnCointlabel.font = [UIFont systemFontOfSize:14];

        _returnCointlabel.textColor = [UIColor redColor];
        //        _returnCointlabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _returnCointlabel;
}



- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@"支付宝扫码",@"支付宝支付",@"微信扫码",@"微信支付",@"财付通支付"];
    }
    return _showArray;
}

- (NSArray *)amountArray {
    if (!_amountArray) {
        _amountArray = @[@"25",@"49",@"72",@"140",@"275"];
    }
    return _amountArray;
}

- (NSArray *)oriArray {
    if (!_oriArray) {
        _oriArray = @[@"原价30元",@"原价60元",@"原价90元",@"原价180元",@"原价360元"];
    }
    return _oriArray;
}

@end
