//
//  FFModeifyPasswordController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFModifyPasswordController.h"
#import "FFUserModel.h"

@interface FFModifyPasswordController () <UITextFieldDelegate>

//原始密码
@property (nonatomic, strong) UITextField *oriPassWord;
//新密码
@property (nonatomic, strong) UITextField *reSetWord;
//确认密码
@property (nonatomic, strong) UITextField *affirmWord;
//确认按钮
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation FFModifyPasswordController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self allTextFiledResetText];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"修改密码";
    [self.view addSubview:self.oriPassWord];
    [self.view addSubview:self.reSetWord];
    [self.view addSubview:self.affirmWord];
    [self.view addSubview:self.sureBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self allTextFiledresignFirstResponder];
}

- (void)allTextFiledresignFirstResponder {
    [self.oriPassWord resignFirstResponder];
    [self.reSetWord resignFirstResponder];
    [self.affirmWord resignFirstResponder];
}

- (void)allTextFiledResetText {
    self.oriPassWord.text = @"";
    self.reSetWord.text = @"";
    self.affirmWord.text = @"";
}

#pragma mark - responds
/** 修改密码按钮 */
- (void)respondsToSureBtn {
    [self allTextFiledresignFirstResponder];

    if (self.oriPassWord.text.length < 6) {
        BOX_MESSAGE(@"原始密码长度不少于6位");
        [self.oriPassWord becomeFirstResponder];
        return;
    }

    if (self.reSetWord.text.length < 6) {
        BOX_MESSAGE(@"新密码长度不少于6位");
        [self.reSetWord becomeFirstResponder];
        return;
    }

    if (self.affirmWord.text.length < 6) {
        BOX_MESSAGE(@"确认密码长度不少于6位");
        [self.affirmWord becomeFirstResponder];
        return;
    }

    if (![self.reSetWord.text isEqualToString:self.affirmWord.text]) {
        BOX_MESSAGE(@"两次输入密码不相等");
        return;
    }

    [self startWaiting];
    [FFUserModel userModifyPasswordOldPassword:self.oriPassWord.text NewPassword:self.affirmWord.text Completion:^(NSDictionary *content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [self allTextFiledResetText];
            [UIAlertController showAlertMessage:@"修改成功" dismissTime:0.8 dismissBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.affirmWord) {
        [self respondsToSureBtn];
    } else if (textField == self.oriPassWord) {
        [self.oriPassWord resignFirstResponder];
        [self.reSetWord becomeFirstResponder];
    } else if (textField == self.reSetWord) {
        [self.reSetWord resignFirstResponder];
        [self.affirmWord becomeFirstResponder];
    }
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if (textField.text.length >= 16) {
        textField.text = [textField.text substringToIndex:16];
        return NO;
    }
    return YES;
}


#pragma mark - getter
- (UITextField *)oriPassWord {
    if (!_oriPassWord) {
        _oriPassWord = [[UITextField alloc]init];
        _oriPassWord.secureTextEntry = YES;
        _oriPassWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _oriPassWord.center = CGPointMake(kSCREEN_WIDTH / 2, 120);
        _oriPassWord.borderStyle = UITextBorderStyleRoundedRect;
        _oriPassWord.placeholder = @"请输入原始密码:";
        _oriPassWord.returnKeyType = UIReturnKeyNext;
        _oriPassWord.delegate = self;
    }
    return _oriPassWord;
}

- (UITextField *)reSetWord {
    if (!_reSetWord) {
        _reSetWord = [[UITextField alloc]init];
        _reSetWord.secureTextEntry = YES;
        _reSetWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _reSetWord.center = CGPointMake(kSCREEN_WIDTH / 2, 185);
        _reSetWord.borderStyle = UITextBorderStyleRoundedRect;
        _reSetWord.placeholder = @"请输入新密码:";
        _reSetWord.returnKeyType = UIReturnKeyNext;
        _reSetWord.delegate = self;
    }
    return _reSetWord;
}

- (UITextField *)affirmWord {
    if (!_affirmWord) {
        _affirmWord = [[UITextField alloc]init];
        _affirmWord.secureTextEntry = YES;
        _affirmWord.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _affirmWord.center = CGPointMake(kSCREEN_WIDTH / 2, 250);
        _affirmWord.borderStyle = UITextBorderStyleRoundedRect;
        _affirmWord.placeholder = @"请确认密码:";
        _affirmWord.returnKeyType = UIReturnKeyDone;
        _affirmWord.delegate = self;
    }
    return _affirmWord;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _sureBtn.center = CGPointMake(kSCREEN_WIDTH / 2, 315);
        [_sureBtn setTitle:@"确认" forState:(UIControlStateNormal)];
        [_sureBtn setBackgroundColor:[FFColorManager blue_dark]];
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(respondsToSureBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}









@end
