//
//  FFBusinessLinkSDKViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessLinkSDKViewController.h"
#import "FFBusinessModel.h"

@interface FFBusinessLinkSDKViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *linkButton;


@end

@implementation FFBusinessLinkSDKViewController

- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessLinkSDKViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.navigationItem.title = @"关联账号";

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.accountTF.frame.origin.x, CGRectGetMaxY(self.accountTF.frame), CGRectGetWidth(self.accountTF.frame), 0.5)]];

    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.passwordTF.frame.origin.x, CGRectGetMaxY(self.passwordTF.frame), CGRectGetWidth(self.passwordTF.frame), 0.5)]];

    self.linkButton.backgroundColor = [FFColorManager blue_dark];
    self.linkButton.layer.cornerRadius = self.linkButton.bounds.size.height / 2;
    self.linkButton.layer.masksToBounds = YES;
    [self.linkButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}


- (IBAction)repondsToLinkButton:(id)sender {
    [self startWaiting];
    [FFBusinessModel linkSDKAccountWithSDKAccount:self.accountTF.text SDKPassword:self.passwordTF.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
            [UIAlertController showAlertMessage:@"绑定成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.accountTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}


#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.secureTextEntry) {
        //这里写登录的事情
        [self repondsToLinkButton:nil];
    } else {
        [self.accountTF resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    }
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.accountTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.accountTF.text.length >= 16) {
            self.accountTF.text = [textField.text substringToIndex:16];
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




@end









