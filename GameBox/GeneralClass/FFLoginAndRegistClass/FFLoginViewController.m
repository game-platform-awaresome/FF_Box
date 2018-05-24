//
//  FFLoginViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/9.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFLoginViewController.h"
#import "FFRegisterViewController.h"
#import "FFForgetPasswordViewController.h"
#import "FFUserModel.h"


@interface FFLoginViewController ()<UITextFieldDelegate>

//用户名输入框
@property (nonatomic, strong) UITextField *userName;
//密码输入框
@property (nonatomic, strong) UITextField *passWord;
//登录按钮
@property (nonatomic, strong) UIButton *loginBtn;
//忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBtn;
//分割线
@property (nonatomic, strong) UIView *separateLine;
//注册按钮
@property (nonatomic, strong) UIButton *registerBtn;

//注册页面
@property (nonatomic, strong) FFRegisterViewController *registerViewController;


@property (nonatomic, assign) BOOL isLogging;


@end

@implementation FFLoginViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    self.userName.text = @"";
    self.passWord.text = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    [self.view addSubview:self.userName];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.separateLine];
    [self.view addSubview:self.registerBtn];
}

#pragma mark - responds
- (void)respondsToBtn:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    if ([sender.titleLabel.text isEqualToString:@"忘记密码"]) {

        [self pushViewController:[FFForgetPasswordViewController new]];
    } else {
        FFRegisterViewController *registerViewController =[FFRegisterViewController new];
        [registerViewController setRegistCompletionBlcok:^(NSString *username, NSString *password) {
            syLog(@"注册完成 :: username == %@ password == %@",username,password);
            self.userName.text = username;
            self.passWord.text = password;
            [self respondsToLogin];
        }];
        [self pushViewController:registerViewController];
    }
}

/** 登录 *///3想
- (void)respondsToLogin {
    if (_isLogging) {
        return;
    }
    _isLogging = YES;
    //释放第一响应者
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];

    if (self.userName.text.length < 1) {
        [UIAlertController showAlertMessage:@"用户名不能为空" dismissTime:0.7 dismissBlock:nil];
        _isLogging = NO;
        return;
    }

    if (self.passWord.text.length < 1) {
        [UIAlertController showAlertMessage:@"密码不能为空" dismissTime:0.7 dismissBlock:nil];
        _isLogging = NO;
        return;
    }

    [self startWaiting];
    [FFUserModel userLoginWithUsername:self.userName.text Password:self.passWord.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        _isLogging = NO;
        if (success) {
            [UIAlertController showAlertMessage:@"登录成功" dismissTime:0.7 dismissBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [UIAlertController showAlertMessage:@"登录失败" dismissTime:0.7 dismissBlock:^{
                
            }];
        }
    }];
}


#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.secureTextEntry) {
        //这里写登录的事情
        [self respondsToLogin];
    } else {
        [self.userName resignFirstResponder];
        [self.passWord becomeFirstResponder];
    }
    return YES;
}


//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.userName) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.userName.text.length >= 16) {
            self.userName.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.passWord) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passWord.text.length >= 16) {
            self.passWord.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}


#pragma mark - getter
- (UITextField *)userName {
    if (!_userName) {
        _userName = [[UITextField alloc]init];
        _userName.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _userName.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor clearColor];

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_account"]];
        imageView.bounds = CGRectMake(0, 0, 20, 20);
        imageView.center = CGPointMake(20, 15);

        [view addSubview:imageView];

        _userName.leftView = view;

        [_userName setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_userName setAutocapitalizationType:UITextAutocapitalizationTypeNone];

        _userName.leftViewMode = UITextFieldViewModeAlways;
        _userName.borderStyle = UITextBorderStyleRoundedRect;
        _userName.placeholder = @"请输入手机号或用户名";
        _userName.keyboardType = UIKeyboardTypeDefault;
        _userName.delegate = self;
        _userName.returnKeyType = UIReturnKeyNext;
    }
    return _userName;
}


- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [[UITextField alloc]init];
        _passWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, 185);

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password"]];
        imageView.bounds = CGRectMake(0, 0, 20, 20);
        imageView.center = CGPointMake(20, 15);

        [view addSubview:imageView];

        _passWord.leftView = view;

        _passWord.leftViewMode = UITextFieldViewModeAlways;
        _passWord.borderStyle = UITextBorderStyleRoundedRect;
        [_passWord setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_passWord setAutocapitalizationType:UITextAutocapitalizationTypeNone];

        _passWord.placeholder = @"请输入密码";
        _passWord.secureTextEntry = YES;
        _passWord.delegate = self;
        _passWord.returnKeyType = UIReturnKeyJoin;
    }
    return _passWord;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _loginBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _loginBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 260);
        _loginBtn.backgroundColor = [FFColorManager blue_dark];
        [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];

        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;

        [_loginBtn addTarget:self action:@selector(respondsToLogin) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginBtn;
}

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _forgetBtn.frame = CGRectMake(kSCREEN_WIDTH / 6 - 1, 285, kSCREEN_WIDTH / 3, 30);
        [_forgetBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        [_forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _forgetBtn;
}

- (UIView *)separateLine {
    if (!_separateLine) {
        _separateLine = [[UIView alloc] init];
        _separateLine.bounds = CGRectMake(0, 0, 2, 20);
        _separateLine.center = CGPointMake(kSCREEN_WIDTH / 2, 300);
        _separateLine.backgroundColor = [UIColor grayColor];
    }
    return _separateLine;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _registerBtn.frame = CGRectMake(kSCREEN_WIDTH / 2 + 1, 285, kSCREEN_WIDTH / 3, 30);
        [_registerBtn setTitle:@"立即注册" forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(respondsToBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _registerBtn;
}







@end















