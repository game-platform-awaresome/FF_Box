//
//  FFForgetPasswordViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFForgetPasswordViewController.h"
#import "FFUserModel.h"
#import <FFTools/FFTools.h>
#import "FFNewPasswordViewController.h"


@interface FFForgetPasswordViewController ()<UITextFieldDelegate>

//手机号
@property (nonatomic, strong) UITextField *phoneNumber;

//验证码
@property (nonatomic, strong) UITextField *securityCode;

//发送验证码按钮
@property (nonatomic, strong) UIButton *sendCodeBtn;

//下一步
@property (nonatomic, strong) UIButton *next;

@property (nonatomic, strong) FFNewPasswordViewController *newPassWordView;

/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
//当前的时间;
@property (nonatomic, assign) NSInteger currnetTime;

@end

@implementation FFForgetPasswordViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"找回密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"General_back_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    [self.view addSubview:self.phoneNumber];
    [self.view addSubview:self.securityCode];
    [self.view addSubview:self.next];
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}
/** 下一步 */
- (void)respondsToNext {
    NSString *MOBILE = @"^1\\d{10}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:self.phoneNumber.text]) {
        [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
        return;
    }

    //验证码长度
    if (self.securityCode.text.length < 4) {
        [UIAlertController showAlertMessage:@"验证码长度有误" dismissTime:0.7 dismissBlock:nil];
        return;
    }

    [self startWaiting];
    [FFUserModel userCheckMessageWithPhoneNumber:self.phoneNumber.text MessageCode:self.securityCode.text Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        if (success) {
            FFNewPasswordViewController *newPassword = [FFNewPasswordViewController new];
            newPassword.userId = content[@"data"][@"id"];
            newPassword.userToken = content[@"data"][@"token"];
            self.hidesBottomBarWhenPushed = YES;
            [self pushViewController:newPassword];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

/** 发送验证码 */
- (void)respondsToSendCodeBtn {
    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:self.phoneNumber.text]) {
        [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
        return;
    }

    [self startWaiting];
    [FFUserModel userSendMessageWithPhoneNumber:self.phoneNumber.text Type:@"2" Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        _currnetTime = 59;
        syLog(@"send message === %@",content);
        if (success) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
            [UIAlertController showAlertMessage:@"验证码已发送" dismissTime:0.7 dismissBlock:nil];
            syLog(@"开启计时器");
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
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
#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneNumber) {
        [textField resignFirstResponder];
        [self.securityCode becomeFirstResponder];
    } else if (textField == self.securityCode) {
        [self respondsToNext];
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

#define MainColor [UIColor redColor]
#pragma mark - getter
- (UITextField *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [[UITextField alloc]init];
        _phoneNumber.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44);
        _phoneNumber.center = CGPointMake(kSCREEN_WIDTH / 2, 120);

        _phoneNumber.borderStyle = UITextBorderStyleNone;
        _phoneNumber.placeholder = @"请输入手机号码";
        _phoneNumber.delegate = self;
        _phoneNumber.returnKeyType = UIReturnKeyNext;
        _phoneNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        [_phoneNumber.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _phoneNumber.bounds.size.height - 1, _phoneNumber.bounds.size.width, 0.5)]];
    }
    return _phoneNumber;
}

- (UITextField *)securityCode {
    if (!_securityCode) {
        _securityCode = [[UITextField alloc]init];
        _securityCode.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44);
        _securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, 185);

        _securityCode.rightView = self.sendCodeBtn;
        _securityCode.rightViewMode = UITextFieldViewModeAlways;

        _securityCode.borderStyle = UITextBorderStyleNone;
        _securityCode.placeholder = @"请输入验证码";
        _securityCode.delegate = self;

        _securityCode.returnKeyType = UIReturnKeyNext;
        _securityCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        [_securityCode.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _securityCode.bounds.size.height - 1, _securityCode.bounds.size.width, 0.5)]];
    }
    return _securityCode;
}

- (UIButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        _sendCodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendCodeBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH / 4, 44);
        [_sendCodeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        [_sendCodeBtn setBackgroundColor:[FFColorManager navigation_bar_white_color]];
        [_sendCodeBtn setTitleColor:MainColor forState:(UIControlStateNormal)];
        _sendCodeBtn.layer.cornerRadius = 4;
        _sendCodeBtn.layer.masksToBounds = YES;
        [_sendCodeBtn addTarget:self action:@selector(respondsToSendCodeBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [_sendCodeBtn.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _sendCodeBtn.bounds.size.height - 1, _sendCodeBtn.bounds.size.width, 0.5)]];
    }
    return _sendCodeBtn;
}

- (CALayer *)creatLineLayerWithFrame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.backgroundColor = [FFColorManager text_separa_line_color].CGColor;
    return layer;
}

- (UIButton *)next {
    if (!_next) {
        _next = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _next.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _next.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        [_next setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_next setBackgroundColor:MainColor];
        _next.layer.cornerRadius = 22;
        _next.layer.masksToBounds = YES;
        [_next addTarget:self action:@selector(respondsToNext) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _next;
}

- (FFNewPasswordViewController *)newPassWordView {
    if (!_newPassWordView) {
        _newPassWordView = [FFNewPasswordViewController new];
    }
    return _newPassWordView;
}




@end
