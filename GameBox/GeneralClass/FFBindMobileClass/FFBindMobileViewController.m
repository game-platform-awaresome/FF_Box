//
//  FFBindMobileViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBindMobileViewController.h"
#import "FFUserModel.h"

@interface FFBindMobileViewController () <UITextFieldDelegate>


//手机号
@property (nonatomic, strong) UITextField *phoneNumber;

//验证码
@property (nonatomic, strong) UITextField *securityCode;

//发送验证码按钮
@property (nonatomic, strong) UIButton *sendCodeBtn;

//下一步
@property (nonatomic, strong) UIButton *next;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
//当前的时间;
@property (nonatomic, assign) NSInteger currnetTime;


///<<<<<<<<<<<<<<<<<<<<<<<<<< 解绑手机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>//
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UILabel *unbindLabel;
@property (nonatomic, strong) UIButton *unbindButton;

@end

@implementation FFBindMobileViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    if (CURRENT_USER.mobile.length == 11) {
        [self initUnbindPhoneView];
    } else {
        [self initBindPhoneView];
    }
}

- (void)initBindPhoneView {
    _type = @"3";
    self.navigationItem.title = @"绑定手机";
    [self.view addSubview:self.phoneNumber];
    [self.view addSubview:self.securityCode];
    [self.view addSubview:self.next];
}

- (void)initUnbindPhoneView {
    _type = @"4";
    self.navigationItem.title = @"解绑手机";
    NSMutableString *phone = [NSMutableString stringWithFormat:@"%@",CURRENT_USER.mobile];
    [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"*****"];
    self.unbindLabel.text = [NSString stringWithFormat:@"绑定的手机 : %@",phone];

    [self.view addSubview:self.unbindLabel];
    [self.view addSubview:self.unbindButton];
}

#pragma mark - responds
/** 绑定手机 */
- (void)respondsToNext {
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:self.phoneNumber.text]) {
        BOX_MESSAGE(@"手机号码有误");
        return;
    }

    //验证码长度
    if (self.securityCode.text.length < 4) {
        BOX_MESSAGE(@"验证码长度有误");
        return;
    }

    [self startWaiting];
    [FFUserModel userBindingPhoneNumber:self.phoneNumber.text Code:self.securityCode.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [FFUserModel currentUser].mobile = self.phoneNumber.text;
            [self.navigationController popViewControllerAnimated:YES];
            BOX_MESSAGE(@"绑定成功");
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

/** 解绑手机 */
- (void)unbindPhone {
    //验证码长度
    if (self.securityCode.text.length < 4) {
        BOX_MESSAGE(@"验证码长度有误");
        return;
    }
    [self startWaiting];
    [FFUserModel userUnbindingPhoneNumber:CURRENT_USER.mobile Code:self.securityCode.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [FFUserModel currentUser].mobile = nil;
            [self.navigationController popViewControllerAnimated:YES];
            BOX_MESSAGE(@"解绑成功");
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

/** 发送验证码 */
- (void)respondsToSendCodeBtn {
    NSDate *date = OBJECT_FOR_USERDEFAULTS(@"sendMessageTime");
    if (date && [date timeIntervalSinceNow] > -60) {
        BOX_MESSAGE(@"发送短信太频繁,请稍后再试");
        return;
    }
    NSString *phone = nil;
    if (_type.integerValue == 4) {
        phone = [FFUserModel currentUser].mobile;
    } else {
        phone = self.phoneNumber.text;
    }

    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:phone]) {
        BOX_MESSAGE(@"手机号码有误");
        return;
    }

    [UIView animateWithDuration:0.3 animations:^{
        [self.view addSubview:self.securityCode];
        self.securityCode.frame = self.unbindLabel.frame;
    }];
    [self.unbindButton setTitle:@"确定" forState:(UIControlStateNormal)];

    [self startWaiting];
    [FFUserModel userSendMessageWithPhoneNumber:phone Type:_type Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        _currnetTime = 59;
        syLog(@"send message === %@",content);
        if (success) {
            NSDate *nowDate = [NSDate date];
            SAVEOBJECT_AT_USERDEFAULTS(nowDate, @"sendMessageTime");
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
            BOX_MESSAGE(@"验证码已发送");
            syLog(@"开启计时器");
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

- (void)refreshTime {
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%lds",_currnetTime] forState:(UIControlStateNormal)];
    [self.sendCodeBtn setUserInteractionEnabled:NO];
    if (_currnetTime <= 0) {
        [self stopTimer];
        [self.sendCodeBtn setUserInteractionEnabled:YES];
        [self.sendCodeBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    }
    _currnetTime--;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)respondsToUnbindButton:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"解绑手机"]) {
        CGRect frame = self.unbindLabel.frame;
        frame.origin.x = kSCREEN_WIDTH;
        self.securityCode.frame = frame;
        [self respondsToSendCodeBtn];

    } else {
        [self.securityCode resignFirstResponder];
        [self unbindPhone];
    }
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneNumber) {
        [textField resignFirstResponder];
        [self.securityCode becomeFirstResponder];
    } else if (textField == self.securityCode) {
        [self.securityCode resignFirstResponder];
        if (_type.integerValue == 4) {
            [self unbindPhone];
        } else {
            [self respondsToNext];
        }
    }

    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.phoneNumber) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.phoneNumber.text.length >= 11) {
            self.phoneNumber.text = [textField.text substringToIndex:11];
            return NO;
        }
    } else if (textField == self.securityCode) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.securityCode.text.length >= 6) {
            self.securityCode.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (UITextField *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [[UITextField alloc]init];
        _phoneNumber.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _phoneNumber.center = CGPointMake(kSCREEN_WIDTH / 2, 120);

        _phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
        _phoneNumber.placeholder = @"请输入手机号码";
        _phoneNumber.delegate = self;
        _phoneNumber.returnKeyType = UIReturnKeyNext;
        _phoneNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _phoneNumber;
}

- (UITextField *)securityCode {
    if (!_securityCode) {
        _securityCode = [[UITextField alloc]init];
        _securityCode.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, 185);

        _securityCode.rightView = self.sendCodeBtn;
        _securityCode.rightViewMode = UITextFieldViewModeAlways;

        _securityCode.borderStyle = UITextBorderStyleRoundedRect;
        _securityCode.placeholder = @"请输入验证码";
        _securityCode.delegate = self;

        _securityCode.returnKeyType = UIReturnKeyNext;
        _securityCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _securityCode;
}

- (UIButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        _sendCodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendCodeBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH * 0.2, 44);
        [_sendCodeBtn setTitle:@"发送" forState:(UIControlStateNormal)];
        [_sendCodeBtn setBackgroundColor:[FFColorManager blue_dark]];
        _sendCodeBtn.layer.cornerRadius = 4;
        _sendCodeBtn.layer.masksToBounds = YES;
        [_sendCodeBtn addTarget:self action:@selector(respondsToSendCodeBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendCodeBtn;
}

- (UIButton *)next {
    if (!_next) {
        _next = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _next.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _next.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        [_next setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_next setBackgroundColor:[FFColorManager blue_dark]];
        _next.layer.cornerRadius = 4;
        _next.layer.masksToBounds = YES;
        [_next addTarget:self action:@selector(respondsToNext) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _next;
}


- (UILabel *)unbindLabel {
    if (!_unbindLabel) {
        _unbindLabel = [[UILabel alloc] init];
        _unbindLabel.frame = CGRectMake(kSCREEN_WIDTH / 10, kSCREEN_HEIGHT * 0.2, kSCREEN_WIDTH * 0.8, 44);
        _unbindLabel.textColor = [FFColorManager textColorMiddle];
        _unbindLabel.textAlignment = NSTextAlignmentCenter;
        _unbindLabel.font = [UIFont systemFontOfSize:20];
    }
    return _unbindLabel;
}

- (UIButton *)unbindButton {
    if (!_unbindButton) {
        _unbindButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _unbindButton.frame = CGRectMake(kSCREEN_WIDTH / 10, CGRectGetMaxY(self.unbindLabel.frame) + 44, kSCREEN_WIDTH * 0.8, 44);
        _unbindButton.backgroundColor = [FFColorManager blue_dark];
        _unbindButton.layer.cornerRadius = 8;
        _unbindButton.layer.masksToBounds = YES;
        [_unbindButton setTitle:@"解绑手机" forState:(UIControlStateNormal)];
        [_unbindButton addTarget:self action:@selector(respondsToUnbindButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _unbindButton;
}











@end
