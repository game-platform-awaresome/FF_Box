//
//  FFBusinessModifyPasswordController.m
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessModifyPasswordController.h"
#import "FFBusinessModel.h"

@interface FFBusinessModifyPasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *oriPasswordTF;

@property (weak, nonatomic) IBOutlet UITextField *rePasswordTF;

@property (weak, nonatomic) IBOutlet UITextField *comPasswordTF;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation FFBusinessModifyPasswordController

- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessModifyPasswordController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {

}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"修改密码";

    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;

//    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT - 1, kSCREEN_WIDTH, 1)]];

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.oriPasswordTF.frame.origin.x, CGRectGetMaxY(self.oriPasswordTF.frame), CGRectGetWidth(self.oriPasswordTF.frame), 0.5)]];

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.rePasswordTF.frame.origin.x, CGRectGetMaxY(self.rePasswordTF.frame), CGRectGetWidth(self.rePasswordTF.frame), 0.5)]];

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.comPasswordTF.frame.origin.x, CGRectGetMaxY(self.comPasswordTF.frame), CGRectGetWidth(self.comPasswordTF.frame), 0.5)]];

    self.sureButton.backgroundColor = [FFColorManager blue_dark];
    self.sureButton.layer.cornerRadius = self.sureButton.bounds.size.height / 2;
    self.sureButton.layer.masksToBounds = YES;
    [self.sureButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - responds
- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.oriPasswordTF resignFirstResponder];
    [self.rePasswordTF resignFirstResponder];
    [self.comPasswordTF resignFirstResponder];
}

- (IBAction)respondsToSureButton:(id)sender {
    if (_isRequest) {
        return;
    }

    _isRequest = YES;


    if (self.oriPasswordTF.text.length < 1) {
        [UIAlertController showAlertMessage:@"请输入原始密码" dismissTime:0.7 dismissBlock:nil];
        _isRequest = NO;
        return;
    }
    if (self.rePasswordTF.text.length < 6) {
        [UIAlertController showAlertMessage:@"请输入6位以上的新密码" dismissTime:0.7 dismissBlock:nil];
        _isRequest = NO;
        return;
    }
    if (self.comPasswordTF.text.length < 16) {
        [UIAlertController showAlertMessage:@"请输入6位以上的确认密码" dismissTime:0.7 dismissBlock:nil];
        _isRequest = NO;
        return;
    }
    if (![self.rePasswordTF.text isEqualToString:self.comPasswordTF.text]) {
        [UIAlertController showAlertMessage:@"两次输入的密码不一样" dismissTime:0.7 dismissBlock:nil];
        _isRequest = NO;
        return;
    }

    [self startWaiting];
    [FFBusinessModel modifyPasswordWithPassword:self.oriPasswordTF.text NewPassword:self.comPasswordTF.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        self.isRequest = NO;
        if (success) {
            [FFBusinessModel setPassword:self.oriPasswordTF.text];
            [self.navigationController popViewControllerAnimated:YES];
            [UIAlertController showAlertMessage:@"密码修改成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];

}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oriPasswordTF) {
        [self.oriPasswordTF resignFirstResponder];
        [self.rePasswordTF becomeFirstResponder];
    } else if (textField == self.rePasswordTF) {
        [self.rePasswordTF resignFirstResponder];
        [self.comPasswordTF becomeFirstResponder];
    } else if (textField == self.comPasswordTF) {
        [self.comPasswordTF resignFirstResponder];
        [self respondsToSureButton:nil];
    }
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.oriPasswordTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.oriPasswordTF.text.length >= 16) {
            self.oriPasswordTF.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.rePasswordTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.rePasswordTF.text.length >= 16) {
            self.rePasswordTF.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.comPasswordTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.comPasswordTF.text.length >= 16) {
            self.comPasswordTF.text = [textField.text substringToIndex:16];
            return NO;
        }
    }
    return YES;
}





@end










