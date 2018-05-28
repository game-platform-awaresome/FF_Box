//
//  FFNewPasswordViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNewPasswordViewController.h"
#import "FFUserModel.h"
#import <FFTools/FFTools.h>

@interface FFNewPasswordViewController ()<UITextFieldDelegate>

//新密码
@property (nonatomic, strong) UITextField *passWord;

//确认密码
@property (nonatomic, strong) UITextField *affimPassWord;

//完成按钮
@property (nonatomic, strong) UIButton *completeBtn;

@end

@implementation FFNewPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
    self.passWord.text = @"";
    self.affimPassWord.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"General_back_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    self.navigationItem.title = @"新密码";
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.affimPassWord];
    [self.view addSubview:self.completeBtn];
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToCompleteBtn {
    //密码太短
    if (self.passWord.text.length < 6 || self.affimPassWord.text.length < 6) {
        [UIAlertController showAlertMessage:@"密码长度太短" dismissTime:0.8 dismissBlock:nil];
        return;
    }

    if (![self.passWord.text isEqualToString:self.affimPassWord.text]) {
        [UIAlertController showAlertMessage:@"两次密码不相同" dismissTime:0.8 dismissBlock:nil];
        return;
    }

    syLog(@"%@",self.userToken);

    [self startWaiting];
    [FFUserModel userForgetPasswordWithUserID:self.userId Password:self.passWord.text RePassword:self.affimPassWord.text Token:self.userToken Completion:^(NSDictionary * _Nullable content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [UIAlertController showAlertMessage:@"修改成功" dismissTime:0.8 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.8 dismissBlock:nil];
        }
    }];

}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passWord) {
        [textField resignFirstResponder];
        [self.affimPassWord becomeFirstResponder];
    } else if (textField == self.affimPassWord) {
        [self respondsToCompleteBtn];
    }

    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.passWord) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passWord.text.length >= 16) {
            self.passWord.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.affimPassWord) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.affimPassWord.text.length >= 16) {
            self.affimPassWord.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [[UITextField alloc]init];
        _passWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44);
        _passWord.center = CGPointMake(kSCREEN_WIDTH / 2, 120);

        _passWord.delegate = self;
        _passWord.borderStyle = UITextBorderStyleNone;
        _passWord.placeholder = @"请输入新密码";
        _passWord.secureTextEntry = YES;
        _passWord.delegate = self;
        _passWord.returnKeyType = UIReturnKeyNext;
        [_passWord.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _passWord.bounds.size.height - 1, _passWord.bounds.size.width, 0.5)]];
    }
    return _passWord;
}

- (UITextField *)affimPassWord {
    if (!_affimPassWord) {
        _affimPassWord = [[UITextField alloc]init];
        _affimPassWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44);
        _affimPassWord.center = CGPointMake(kSCREEN_WIDTH / 2, 185);

        _affimPassWord.borderStyle = UITextBorderStyleNone;
        _affimPassWord.placeholder = @"确认密码";
        _affimPassWord.secureTextEntry = YES;
        _affimPassWord.delegate = self;
        _affimPassWord.returnKeyType = UIReturnKeyDone;

        [_affimPassWord.layer addSublayer:[self creatLineLayerWithFrame:CGRectMake(0, _affimPassWord.bounds.size.height - 1, _affimPassWord.bounds.size.width, 0.5)]];
    }
    return _affimPassWord;
}

- (CALayer *)creatLineLayerWithFrame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.backgroundColor = [FFColorManager text_separa_line_color].CGColor;
    return layer;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _completeBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _completeBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        [_completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [_completeBtn setBackgroundColor:[FFColorManager blue_dark]];
        _completeBtn.layer.cornerRadius = 22;
        _completeBtn.layer.masksToBounds = YES;
        [_completeBtn addTarget:self action:@selector(respondsToCompleteBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _completeBtn;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




