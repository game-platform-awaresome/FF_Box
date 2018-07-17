//
//  FFExchangeCoinController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFExchangeCoinController.h"
#import "FFUserModel.h"
#import "FFViewFactory.h"
#import "FFStatisticsModel.h"

@interface FFExchangeCoinController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UILabel *myGold;
@property (nonatomic, strong) UILabel *canEchangNumber;
@property (nonatomic, strong) UILabel *proportionLabel;


@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UITextField *exchangeTextfield;
@property (nonatomic, strong) UIButton *exchangeButton;

@property (nonatomic, strong) NSString *proportion;
@property (nonatomic, strong) NSString *canNumber;

@end

@implementation FFExchangeCoinController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.exchangeTextfield resignFirstResponder];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"兑换平台币";

    [self.view addSubview:self.upView];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.exchangeButton];
}



- (void)initDataSource {
    [FFUserModel coinExchangeInfoCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            [self setProportion:content[@"data"][@"platform_coin_ratio"]];
            [self setRemind:content[@"data"][@"platform_start_count"]];
            [self setMygoldNumber:content[@"data"][@"coin"]];
        } else {

        }
    }];
}
#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self respondsToExchangeBUtton];
    return YES;
}


#pragma mark - responds
- (void)respondsToExchangeBUtton {
    if (self.exchangeTextfield.text.length == 0) {
        BOX_MESSAGE(@"平台币不能为空");
        return;
    }

    if (self.exchangeTextfield.text.integerValue > self.canNumber.integerValue) {
        BOX_MESSAGE(@"超过最大兑换数");
        self.exchangeTextfield.text = @"";
        return;
    }

    if (self.exchangeTextfield.text.integerValue < 10) {
        BOX_MESSAGE(@"请填写大于10的数字");
        self.exchangeTextfield.text = @"";
        return;
    }

    [self.exchangeTextfield resignFirstResponder];
    START_NET_WORK;
    [FFUserModel coinExchangePlatformCounts:self.exchangeTextfield.text Completion:^(NSDictionary *content, BOOL success) {
        STOP_NET_WORK;
        if (success) {
            self.exchangeTextfield.text = @"";
            syLog(@"exchang == %@",content);
            [self initDataSource];
            BOX_MESSAGE(@"兑换成功");
            BoxcustomEvents(@"exchange_platform_coin", @{@"number":self.exchangeTextfield.text});
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - setter
- (void)setMygoldNumber:(NSString *)gold {
    if (!gold) {
        gold = @"0";
    }
    [self setCanechang:gold];
    self.myGold.text = [NSString stringWithFormat:@"    我的金币 : %@",gold];
}

- (void)setCanechang:(NSString *)gold {
    if (!gold) {
        gold = @"0";
    }
    NSInteger current = gold.integerValue / self.proportion.integerValue;
    self.canNumber = [NSString stringWithFormat:@"%ld",current];
    self.canEchangNumber.text = [NSString stringWithFormat:@"    可兑换的平台币数量 : %ld",current];
}

- (void)setProportion:(NSString *)proportion {
    if (!proportion) {
        proportion = @"10";
    }
    _proportion = proportion;
}


- (void)setRemind:(NSString *)remind {
    if (!remind) {
        remind = @"10";
    }
    self.remindLabel.text = [NSString stringWithFormat:@"%@平台币起换",remind];
    self.proportionLabel.text = [NSString stringWithFormat:@"    %@金币换1平台币,少于%@个平台币不能换",self.proportion,remind];
}

#pragma mark - getter
- (UIView *)upView {
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, 180)];
        _upView.backgroundColor = [UIColor whiteColor];

        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 10);
        layer.backgroundColor = BACKGROUND_COLOR.CGColor;
        [_upView.layer addSublayer:layer];

        [_upView addSubview:self.myGold];
        [_upView addSubview:self.canEchangNumber];
        [_upView addSubview:self.proportionLabel];

        CALayer *line2 = [[CALayer alloc] init];
        line2.frame = CGRectMake(0, 175, kSCREEN_WIDTH, 5);
        line2.backgroundColor = BACKGROUND_COLOR.CGColor;
        [_upView.layer addSublayer:line2];
    }
    return _upView;
}


- (UILabel *)myGold {
    if (!_myGold) {
        _myGold = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kSCREEN_WIDTH, 44)];
        _myGold.text = @"    我的金币 : ";
    }
    return _myGold;
}

- (UILabel *)canEchangNumber {
    if (!_canEchangNumber) {
        _canEchangNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, kSCREEN_WIDTH, 44)];
        _canEchangNumber.text = @"    可兑换的平台币 : ";
    }
    return _canEchangNumber;
}

- (UILabel *)proportionLabel {
    if (!_proportionLabel) {
        _proportionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, kSCREEN_WIDTH, 44)];
        _proportionLabel.text = @"    10金币换1平台币,少于10个不能换";
        _proportionLabel.textColor = [UIColor lightGrayColor];
    }
    return _proportionLabel;
}



- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.upView.frame) + 30, kSCREEN_WIDTH, 60)];
        _inputView.backgroundColor = BACKGROUND_COLOR;

//        [_inputView addSubview:self.remindLabel];
        [_inputView addSubview:self.exchangeTextfield];
    }
    return _inputView;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH / 3, 60)];
//        _remindLabel.backgroundColor = [UIColor blackColor];
        _remindLabel.text = @"10平台币起换";
        _remindLabel.textColor = [UIColor lightGrayColor];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLabel;
}

- (UITextField *)exchangeTextfield {
    if (!_exchangeTextfield) {
        _exchangeTextfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 8, kSCREEN_WIDTH, 44)];
        _exchangeTextfield.placeholder = @"请输入要兑换的平台币数";
        _exchangeTextfield.borderStyle = UITextBorderStyleNone;
        _exchangeTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _exchangeTextfield.delegate = self;
        _exchangeTextfield.returnKeyType = UIReturnKeyDone;
        _exchangeTextfield.textAlignment = NSTextAlignmentCenter;

    }
    return _exchangeTextfield;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _exchangeButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44);
        _exchangeButton.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.inputView.frame) + 100);
//        [_exchangeButton setImage:[UIImage imageNamed:@"New_coin_exchangeButton"] forState:(UIControlStateNormal)];
        [_exchangeButton setBackgroundColor:[FFColorManager blue_dark]];
        [_exchangeButton setTitle:@"兑换" forState:(UIControlStateNormal)];
        [_exchangeButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];
        _exchangeButton.layer.cornerRadius = _exchangeButton.bounds.size.height / 2;
        _exchangeButton.layer.masksToBounds = YES;
        [_exchangeButton addTarget:self action:@selector(respondsToExchangeBUtton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _exchangeButton;
}








@end


















