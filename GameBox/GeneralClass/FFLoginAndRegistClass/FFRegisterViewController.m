//
//  FFRegisterViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRegisterViewController.h"
#import "FFUserModel.h"
#import <FFTools/FFTools.h>
#import "FFWebViewController.h"
#import "FFMapModel.h"

@interface FFRegisterViewController ()<UITextFieldDelegate>


//用户名
@property (nonatomic, strong) UITextField *userName;

//密码
@property (nonatomic, strong) UITextField *passWord;

//手机号
@property (nonatomic, strong) UITextField *phoneNumber;

//验证码
@property (nonatomic, strong) UITextField *securityCode;

//邮箱
@property (nonatomic, strong) UITextField *email;

//注册按钮
@property (nonatomic, strong) UIButton *registerBtn;

/**< 发送验证码按钮 */
@property (nonatomic, strong) UIButton *sendMessageBtn;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

//当前的时间;
@property (nonatomic, assign) NSInteger currnetTime;

//勾选用户协议按钮
@property (nonatomic, strong) UIButton *selectProtocolButton;
//查看用户协议按钮
@property (nonatomic, strong) UIButton *showProtocolButton;


@property (nonatomic, assign) BOOL isUserRegister;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIBarButtonItem *rightChangeButton;


@property (nonatomic, assign) BOOL isRegisting;


@end

@implementation FFRegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
    self.userName.text = @"";
    self.passWord.text = @"";
    self.phoneNumber.text = @"";
    self.securityCode.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self allTextFieldResignFistResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self allTextFieldResignFistResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUserRegister = NO;
    [self initUserInterFace];
}

- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userName];
    [self.view addSubview:self.securityCode];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.registerBtn];
//    [self.view addSubview:self.changeButton];
    [self.view addSubview:self.selectProtocolButton];
    [self.view addSubview:self.showProtocolButton];
    
    self.navigationItem.rightBarButtonItem = self.rightChangeButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"General_back_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];

    [self phoneView];
}

- (void)setPhoneView {
    [UIView animateWithDuration:0.3 animations:^{
        [self phoneView];
    } completion:^(BOOL finished) {

    }];
}

- (void)phoneView {
    self.navigationItem.title = @"快速注册";
    self.userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
    self.securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.userName.frame) + 55);
    self.passWord.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.securityCode.frame) + 55);
    self.registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.passWord.frame) + 60);
    self.changeButton.frame = CGRectMake(CGRectGetMinX(self.passWord.frame), CGRectGetMaxY(self.registerBtn.frame), kSCREEN_WIDTH * 0.8, 30);
    self.rightChangeButton.title = @"用户名注册";
    self.userName.placeholder = @"请输入手机号";

    [self.selectProtocolButton sizeToFit];
    [self.showProtocolButton sizeToFit];

    CGFloat width = self.selectProtocolButton.bounds.size.width + self.showProtocolButton.bounds.size.width;
    width = kSCREEN_WIDTH - width;
    self.selectProtocolButton.frame = CGRectMake(width / 2, CGRectGetMaxY(self.registerBtn.frame) + 10, self.selectProtocolButton.bounds.size.width, self.selectProtocolButton.bounds.size.height);

    self.showProtocolButton.frame = CGRectMake(CGRectGetMaxX(self.selectProtocolButton.frame), CGRectGetMinY(self.selectProtocolButton.frame), self.showProtocolButton.frame.size.width, self.showProtocolButton.frame.size.height);
    self.showProtocolButton.center = CGPointMake(self.showProtocolButton.center.x, self.selectProtocolButton.center.y);
}

- (void)setUserView {
    self.navigationItem.title = @"用户名注册";
    [UIView animateWithDuration:0.3 animations:^{
        self.userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        self.securityCode.center = CGPointMake(kSCREEN_WIDTH * 2, CGRectGetMaxY(self.userName.frame) + 55);
        self.passWord.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.userName.frame) + 55);
        self.registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.passWord.frame) + 60);
        self.changeButton.frame = CGRectMake(CGRectGetMinX(self.passWord.frame), CGRectGetMaxY(self.registerBtn.frame), kSCREEN_WIDTH * 0.8, 30);
        self.rightChangeButton.title = @"快速注册";
        self.userName.placeholder = @"请输入用户名";
        self.selectProtocolButton.frame = CGRectMake(CGRectGetMinX(self.passWord.frame), CGRectGetMaxY(self.passWord.frame) + 10, 20, 20);
        [self.selectProtocolButton sizeToFit];
        [self.showProtocolButton sizeToFit];

        CGFloat width = self.selectProtocolButton.bounds.size.width + self.showProtocolButton.bounds.size.width;
        width = kSCREEN_WIDTH - width;
        self.selectProtocolButton.frame = CGRectMake(width / 2, CGRectGetMaxY(self.registerBtn.frame) + 10, self.selectProtocolButton.bounds.size.width, self.selectProtocolButton.bounds.size.height);
        self.showProtocolButton.frame = CGRectMake(CGRectGetMaxX(self.selectProtocolButton.frame), CGRectGetMinY(self.selectProtocolButton.frame), self.showProtocolButton.frame.size.width, self.showProtocolButton.frame.size.height);
        self.showProtocolButton.center = CGPointMake(self.showProtocolButton.center.x, self.selectProtocolButton.center.y);
    } completion:^(BOOL finished) {

    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTextFieldResignFistResponder];
}

- (void)allTextFieldResignFistResponder {
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.securityCode resignFirstResponder];
//    [self.email resignFirstResponder];
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}
/** 切换注册 */
- (void)respondsToChangeButton {
    syLog(@"???");
    if (_isUserRegister) {
        _isUserRegister = NO;
        [self setPhoneView];
    } else {
        _isUserRegister = YES;
        [self setUserView];
    }
    [_changeButton sizeToFit];
}

/** 注册 */
- (void)respondsToRegisterBtn {
    syLog(@"用户名注册 %u",_isUserRegister);
    [self registAccount];
}

/** 是否选择协议 */
- (void)respondsToSelectProtocolButton {
    self.selectProtocolButton.selected = !self.selectProtocolButton.selected;
}

/** 查看协议 */
- (void)showAlowProtocol {
    FFWebViewController *webVC = [FFWebViewController new];
    webVC.webURL = [FFMapModel map].USER_AGREEMENT;
    webVC.title = @"用户协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)resPondsToButtonIndex:(NSUInteger)index {
    syLog(@"select index == %lu",index);
    switch (index) {
        case 0: {
            //取消按钮
            break;
        }
        case 1: {
            //同意协议
            [self registAccount];
            break;
        }
        case 2: {
            //查看协议
            [self showAlowProtocol];
            syLog(@"查看用户协议");
            break;
        }

        default:
            break;
    }
}

/** 注册账号 */
- (void)registAccount {
    if (_isRegisting) {
        return;
    }

    _isRegisting = YES;

    //用户名太短,返回
    if (self.userName.text.length < 6) {
        [UIAlertController showAlertMessage:@"用户名长度太短" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }
    //密码太短
    if (self.passWord.text.length < 6) {
        [UIAlertController showAlertMessage:@"密码长度太短" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }
    //用户协议
    if (self.selectProtocolButton.selected == NO) {
        [UIAlertController showAlertMessage:@"请同意用户协议" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }

    NSString *userName = nil;
    NSString *code = nil;
    NSString *phoneNumber = nil;
    NSString *passWord = nil;
    NSString *type = nil;

    if (_isUserRegister) {
        userName = self.userName.text;
        code = @"";
        phoneNumber = @"";
        passWord = self.passWord.text;
        type = @"1";
    } else {
        NSString *MOBILE = @"^1\\d{10}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        //手机号有误
        if (![regextestmobile evaluateWithObject:self.userName.text]) {
            [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
            _isRegisting = NO;
            return;
        }
        //验证码长度不正确
        if (self.securityCode.text.length < 4) {
            [UIAlertController showAlertMessage:@"验证码长度有误" dismissTime:0.7 dismissBlock:nil];
            _isRegisting = NO;
            return;
        }
        userName = @"";
        code = self.securityCode.text;
        phoneNumber = self.userName.text;
        passWord = self.passWord.text;
        type = @"2";
    }

    [self startWaiting];
    [FFUserModel userRegisterWithUserName:userName Code:code PhoneNumber:phoneNumber PassWord:passWord Type:type Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSString *loginName = ([userName isEqualToString:@""] || userName.length == 0) ? phoneNumber : userName;
            [UIAlertController showAlertMessage:@"注册成功" dismissTime:0.7 dismissBlock:^{

                m185Statistics(@"完成注册", -1);

                [self.navigationController popViewControllerAnimated:YES];
                if (self.registCompletionBlcok) {
                    self.registCompletionBlcok(loginName,passWord);
                }
            }];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

/** 响应发送验证码按钮 */
- (void)respondsToSendMessageBtn {

    NSString *MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:self.userName.text]) {
        [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
        return;
    }

    [FFUserModel userSendMessageWithPhoneNumber:self.userName.text Type:@"1" Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            _currnetTime = 59;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
            [UIAlertController showAlertMessage:@"验证码已发送" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (void)refreshTime {
    [self.sendMessageBtn setTitle:[NSString stringWithFormat:@"%lds",_currnetTime] forState:(UIControlStateNormal)];
    [self.sendMessageBtn setUserInteractionEnabled:NO];
    if (_currnetTime <= 0) {
        [self stopTimer];
        [self.sendMessageBtn setUserInteractionEnabled:YES];
        [self.sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
    }
    _currnetTime--;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.email) {
        [self respondsToRegisterBtn];
    } else if (textField == self.userName) {
        [self.userName resignFirstResponder];
        [self.passWord becomeFirstResponder];
    } else if (textField == self.passWord) {
        [self.passWord resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    } else if (textField == self.phoneNumber) {
        [self.phoneNumber resignFirstResponder];
        [self.securityCode becomeFirstResponder];
    } else if (textField == self.securityCode) {
        [self.securityCode resignFirstResponder];
        [self.email becomeFirstResponder];
        [self respondsToRegisterBtn];
    }

    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.userName) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.userName.text.length >= 15) {
            self.userName.text = [textField.text substringToIndex:15];
            return NO;
        }
    } else if (textField == self.passWord) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passWord.text.length >= 16) {
            self.passWord.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.phoneNumber) {
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
    } else if (textField == self.email) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.email.text.length >= 30) {
            self.email.text = [textField.text substringToIndex:30];
            return NO;
        }
    }
    return YES;
}

#define MainColor [UIColor redColor]

#pragma mark - getter
- (UITextField *)creatTextFieldWithLeftView:(UIImageView *)lefitView WithRightView:(UIImageView *)rigthView WithPlaceholder:(NSString *)placeholder WithBounds:(CGRect)Bounds WithsecureTextEntry:(BOOL)secureTextEntry  {
    UITextField *textfield = [[UITextField alloc] init];
    textfield.bounds = Bounds;

    textfield.leftView = lefitView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.borderStyle = UITextBorderStyleNone;
    textfield.placeholder = placeholder;
    textfield.secureTextEntry = secureTextEntry;
    textfield.delegate = self;

    [textfield setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    [textfield.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, textfield.bounds.size.height - 1, textfield.bounds.size.width, 0.5)]];
    return textfield;
}

- (UITextField *)userName {
    if (!_userName) {
        _userName = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输用户名" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44) WithsecureTextEntry:NO];
        _userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        _userName.returnKeyType = UIReturnKeyNext;
        _userName.keyboardType = UIKeyboardTypeDefault;
    }
    return _userName;
}

- (UITextField *)securityCode {
    if (!_securityCode) {
        _securityCode = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入验证码" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44) WithsecureTextEntry:NO];
        _securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        _securityCode.returnKeyType = UIReturnKeyNext;
        _securityCode.keyboardType = UIKeyboardTypeDefault;
        _securityCode.rightView = self.sendMessageBtn;
        _securityCode.rightViewMode = UITextFieldViewModeAlways;
    }
    return _securityCode;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入密码" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44) WithsecureTextEntry:YES];
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        _passWord.returnKeyType = UIReturnKeyNext;
        _passWord.keyboardType = UIKeyboardTypeDefault;
    }
    return _passWord;
}



- (UITextField *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入手机号" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44) WithsecureTextEntry:NO];
        _phoneNumber.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        _phoneNumber.returnKeyType = UIReturnKeyNext;
        _phoneNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

        [_phoneNumber.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _phoneNumber.bounds.size.height - 1, _phoneNumber.bounds.size.width, 0.5)]];
    }
    return _phoneNumber;
}

- (CALayer *)creatLineLayerWithFrame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.backgroundColor = [FFColorManager text_separa_line_color].CGColor;
    return layer;
}

- (UITextField *)email {
    if(!_email) {
        _email = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入邮箱" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _email.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.6);
        _email.returnKeyType = UIReturnKeyDone;
        _email.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _email;
}

- (UIButton *)selectProtocolButton {
    if (!_selectProtocolButton) {
        _selectProtocolButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _selectProtocolButton.frame = CGRectMake(CGRectGetMinX(self.passWord.frame), CGRectGetMaxY(self.passWord.frame) + 10, 30, 30);
        [_selectProtocolButton setImage:[UIImage imageNamed:@"Protocol_select_yes"] forState:(UIControlStateSelected)];
        [_selectProtocolButton setImage:[UIImage imageNamed:@"Protocol_select_no"] forState:(UIControlStateNormal)];
        _selectProtocolButton.selected = YES;
        [_selectProtocolButton setTitle:@"我已阅读并同意" forState:(UIControlStateNormal)];
        [_selectProtocolButton setTitle:@"我已阅读并同意" forState:(UIControlStateSelected)];
        [_selectProtocolButton setTitleColor:[FFColorManager navigation_bar_black_color] forState:(UIControlStateNormal)];
        [_selectProtocolButton setTitleColor:[FFColorManager navigation_bar_black_color] forState:(UIControlStateSelected)];
        [_selectProtocolButton addTarget:self action:@selector(respondsToSelectProtocolButton) forControlEvents:(UIControlEventTouchUpInside)];
        _selectProtocolButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _selectProtocolButton;
}

- (UIButton *)showProtocolButton {
    if (!_showProtocolButton) {
        _showProtocolButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _showProtocolButton.bounds = CGRectMake(0, 0, 30, 30);
        [_showProtocolButton addTarget:self action:@selector(showAlowProtocol) forControlEvents:(UIControlEventTouchUpInside)];
        [_showProtocolButton setTitle:@"《用户协议》" forState:(UIControlStateNormal)];
        _showProtocolButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_showProtocolButton sizeToFit];
        [_showProtocolButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
    }
    return _showProtocolButton;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _registerBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.passWord.frame) + 60);
        [_registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateHighlighted)];
        [_registerBtn setBackgroundColor:MainColor];
        _registerBtn.layer.cornerRadius = 22;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn addTarget:self action:@selector(respondsToRegisterBtn) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _registerBtn;
}

- (UIButton *)sendMessageBtn {
    if (!_sendMessageBtn) {
        _sendMessageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendMessageBtn.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_sendMessageBtn setTitleColor:MainColor forState:(UIControlStateNormal)];
        [_sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [_sendMessageBtn addTarget:self action:@selector(respondsToSendMessageBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _sendMessageBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.3, 44);
        _sendMessageBtn.layer.cornerRadius = 2;
        _sendMessageBtn.layer.masksToBounds = YES;

        [_sendMessageBtn.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _sendMessageBtn.bounds.size.height - 1, _sendMessageBtn.bounds.size.width, 0.5)]];
    }
    return _sendMessageBtn;
}


- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _changeButton.frame = CGRectMake(CGRectGetMinX(self.registerBtn.frame), CGRectGetMaxY(self.registerBtn.frame) + 10, kSCREEN_WIDTH, 20);
        if (_isUserRegister) {
            [_changeButton setTitle:@"快速注册" forState:(UIControlStateNormal)];
        } else {
            [_changeButton setTitle:@"用户名注册" forState:(UIControlStateNormal)];
        }
        [_changeButton sizeToFit];
        [_changeButton addTarget:self action:@selector(respondsToChangeButton) forControlEvents:(UIControlEventTouchUpInside)];
        _changeButton.layer.cornerRadius = 2;
        _changeButton.layer.masksToBounds = YES;
        _changeButton.layer.borderWidth = 1;
        _changeButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
        [_changeButton setTitleColor:NAVGATION_BAR_COLOR forState:(UIControlStateNormal)];
    }
    return _changeButton;
}

- (UIBarButtonItem *)rightChangeButton {
    if (!_rightChangeButton) {
        _rightChangeButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToChangeButton)];
    }
    return _rightChangeButton;
}




@end






