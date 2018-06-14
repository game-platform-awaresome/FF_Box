//
//  FFBussinessLoginViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessLoginViewController.h"
#import "FFBusinessModel.h"

@interface FFBusinessLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) UIButton *forgetButton;

@property (nonatomic, assign) BOOL isRegisting;

@end

@implementation FFBusinessLoginViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSuccess:) name:FFBusinessRegistSuccess object:nil];
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessLoginViewController"];
}

- (void)registSuccess:(NSNotification *)noti {
    NSDictionary *dict = [noti userInfo];
    NSString *username = dict[@"username"];
    NSString *password = dict[@"password"];
    if (username && password) {
        self.userNameTF.text = username;
        self.passwordTF.text = password;
        [self respondsToLoginButton:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"登录";

    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;

    [self.rightButton setTitle:@"注册"];
    self.navigationItem.rightBarButtonItem = self.rightButton;

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT - 1, kSCREEN_WIDTH, 1)]];

//    self.userNameTF;
    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.userNameTF.frame.origin.x, CGRectGetMaxY(self.userNameTF.frame), CGRectGetWidth(self.userNameTF.frame), 0.5)]];

    self.passwordTF.rightView = self.forgetButton;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.passwordTF.frame.origin.x, CGRectGetMaxY(self.passwordTF.frame), CGRectGetWidth(self.passwordTF.frame), 0.5)]];

    self.loginButton.backgroundColor = [FFColorManager blue_dark];
    self.loginButton.layer.cornerRadius = self.loginButton.bounds.size.height / 2;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}



#pragma mark - responds
- (void)respondsToRightButton {
    pushViewController(@"FFBusinessRegistViewController");
}

- (void)respondsToForgetButton {
    pushViewController(@"FFBusinessForgetPasswordViewController");
}

- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (IBAction)respondsToLoginButton:(id)sender {
    syLog(@"登录账号交易系统");
    if (_isRegisting) {
        return;
    }
    _isRegisting = YES;
    [self respondsToTap:nil];
    //手机号有误
    NSString *MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:self.userNameTF.text]) {
        [UIAlertController showAlertMessage:@"手机号码有误" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }
    //密码太短
    if (self.passwordTF.text.length < 1) {
        [UIAlertController showAlertMessage:@"请输入密码" dismissTime:0.7 dismissBlock:nil];
        _isRegisting = NO;
        return;
    }
    [self startWaiting];
    [FFBusinessModel loginAccountWithUserName:self.userNameTF.text Password:self.passwordTF.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [FFBusinessModel setUsername:self.userNameTF.text];
            [FFBusinessModel setPassword:self.passwordTF.text];
            [FFBusinessModel loginSuccessWith:content[@"data"]];
            [self.navigationController popViewControllerAnimated:YES];
            [UIAlertController showAlertMessage:@"登录成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.secureTextEntry) {
        //这里写登录的事情
        [self respondsToLoginButton:nil];
    } else {
        [self.userNameTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    }
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userNameTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.userNameTF.text.length >= 11) {
            self.userNameTF.text = [textField.text substringToIndex:11];
            return NO;
        }
    } else if (textField == self.passwordTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passwordTF.text.length >= 16) {
            self.passwordTF.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_forgetButton setTitle:@"忘记密码?" forState:(UIControlStateNormal)];
        [_forgetButton addTarget:self action:@selector(respondsToForgetButton) forControlEvents:(UIControlEventTouchUpInside)];
        [_forgetButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_forgetButton sizeToFit];
    }
    return _forgetButton;
}




@end










