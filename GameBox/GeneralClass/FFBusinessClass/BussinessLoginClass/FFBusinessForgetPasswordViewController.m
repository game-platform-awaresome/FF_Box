//
//  FFBusinessForgetPasswordViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessForgetPasswordViewController.h"
#import "FFBusinessModel.h"

@interface FFBusinessForgetPasswordViewController ()


@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, assign) NSInteger currnetTime;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIButton *sendMessageButton;

@property (nonatomic, assign) BOOL isRegisting;


@end

@implementation FFBusinessForgetPasswordViewController


- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessForgetPasswordViewController"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"忘记密码";

    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;

    CALayer *navLine = [[CALayer alloc] init];
    navLine.frame = CGRectMake(0, kNAVIGATION_HEIGHT - 1, kSCREEN_WIDTH, 1);
    navLine.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
    [self.view.layer addSublayer:navLine];

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.usernameTF.frame.origin.x, CGRectGetMaxY(self.usernameTF.frame), CGRectGetWidth(self.usernameTF.frame), 0.5)]];

    self.codeTF.rightView = self.sendMessageButton;
    self.codeTF.rightViewMode = UITextFieldViewModeAlways;
    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.codeTF.frame.origin.x, CGRectGetMaxY(self.codeTF.frame), CGRectGetWidth(self.codeTF.frame), 0.5)]];

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.passwordTF.frame.origin.x, CGRectGetMaxY(self.passwordTF.frame), CGRectGetWidth(self.passwordTF.frame), 0.5)]];

    self.resetButton.backgroundColor = [FFColorManager blue_dark];
    self.resetButton.layer.cornerRadius = self.resetButton.bounds.size.height / 2;
    self.resetButton.layer.masksToBounds = YES;
    [self.resetButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];

}

- (CALayer *)creatLineWithFrame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
    return layer;
}


#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.usernameTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (IBAction)respondsToRegist:(id)sender {
    if (_isRegisting) {
        return;
    }

    _isRegisting = YES;
    NSString *MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //手机号有误
    if (![regextestmobile evaluateWithObject:self.usernameTF.text]) {
        [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }
    //验证码长度不正确
    if (self.codeTF.text.length < 4) {
        [UIAlertController showAlertMessage:@"验证码长度有误" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }
    //密码太短
    if (self.passwordTF.text.length < 6) {
        [UIAlertController showAlertMessage:@"密码长度太短" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }

    [self startWaiting];
    [FFBusinessModel recoverPasswordWithPhoneNumber:self.usernameTF.text Code:self.codeTF.text NewPassword:self.passwordTF.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        self.isRegisting = NO;
        if (success) {
            [UIAlertController showAlertMessage:@"修改密码成功" dismissTime:0.7 dismissBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}


- (void)respondsToSendMessageButton {
    syLog(@"发送验证码");
    NSString *MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:self.usernameTF.text]) {
        [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
        return;
    }
    [FFBusinessModel sendMessageWithPhoneNumber:self.usernameTF.text type:(FFBusinessTypePassword) Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            self.currnetTime = 59;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
            [UIAlertController showAlertMessage:@"验证码已发送" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (void)refreshTime {
    [self.sendMessageButton setTitle:[NSString stringWithFormat:@"%lds",_currnetTime] forState:(UIControlStateNormal)];
    [self.sendMessageButton setUserInteractionEnabled:NO];
    if (_currnetTime <= 0) {
        [self stopTimer];
        [self.sendMessageButton setUserInteractionEnabled:YES];
        [self.sendMessageButton setTitle:@"发送验证码" forState:(UIControlStateNormal)];
    }
    _currnetTime--;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTF) {
        [self.usernameTF resignFirstResponder];
        [self.codeTF becomeFirstResponder];
    } else if(textField == self.codeTF) {
        [self.codeTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    } else if (textField == self.passwordTF) {
        [self.passwordTF resignFirstResponder];
        [self respondsToRegist:nil];
    }
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.usernameTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.usernameTF.text.length >= 11) {
            self.usernameTF.text = [textField.text substringToIndex:11];
            return NO;
        }
    } else if (textField == self.passwordTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passwordTF.text.length >= 16) {
            self.passwordTF.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.codeTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.codeTF.text.length >= 6) {
            self.codeTF.text = [textField.text substringToIndex:6];
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (UIButton *)sendMessageButton {
    if (!_sendMessageButton) {
        _sendMessageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sendMessageButton setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [_sendMessageButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
        [_sendMessageButton addTarget:self action:@selector(respondsToSendMessageButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_sendMessageButton sizeToFit];
    }
    return _sendMessageButton;
}







@end













