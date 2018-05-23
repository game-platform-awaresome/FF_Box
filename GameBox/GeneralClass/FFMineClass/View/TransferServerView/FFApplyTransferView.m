//
//  FFApplyTransferView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/9.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFApplyTransferView.h"
#import "FFViewFactory.h"


@interface FFApplyTransferView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputeBackground;
@property (weak, nonatomic) IBOutlet UITextField *oldGameName;
@property (weak, nonatomic) IBOutlet UITextField *transferGName;
@property (weak, nonatomic) IBOutlet UITextField *oldServerName;
@property (weak, nonatomic) IBOutlet UITextField *transferServerName;
@property (weak, nonatomic) IBOutlet UITextField *oldCharacterName;
@property (weak, nonatomic) IBOutlet UITextField *transferCharacterName;


@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *qqNumber;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) CALayer *line;

@end



@implementation FFApplyTransferView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.oldCharacterName.delegate = self;
    self.oldGameName.delegate = self;
    self.oldServerName.delegate = self;
    self.transferCharacterName.delegate = self;
    self.transferServerName.delegate = self;
    self.transferGName.delegate = self;
    self.qqNumber.delegate = self;
    self.phoneNumber.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note {
    syLog(@"键盘弹起");
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //3.输入框弹起后的Y
    CGFloat y_board = 0;
    NSValue *aValue = [note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    y_board = keyboardRect.size.height;


    if (self.phoneNumber.isFirstResponder) {
        if (self.qqNumber.frame.origin.y < keyboardRect.origin.y) {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, self.qqNumber.frame.origin.y - keyboardRect.origin.y);
            }];
        }
    }

    if (self.qqNumber.isFirstResponder) {
        if (self.qqNumber.frame.origin.y < keyboardRect.origin.y) {
            [UIView animateWithDuration:duration animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, self.qqNumber.frame.origin.y - keyboardRect.origin.y);
            }];
        }
    }
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note {
    syLog(@"键盘收起");
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    if (self.phoneNumber.isFirstResponder || self.qqNumber.isFirstResponder) {
//        self.phoneNumber.transform = CGAffineTransformIdentity;
//        self.qqNumber.transform = CGAffineTransformIdentity;
        // 2.执行动画
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }


}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldGameName) {
//        [self.oldGameName resignFirstResponder];
        [self.oldServerName becomeFirstResponder];
    } else if (textField == self.oldServerName) {
//        [self.oldServerName resignFirstResponder];
        [self.oldCharacterName becomeFirstResponder];
    } else if (textField == self.oldCharacterName) {
//        [self.oldCharacterName resignFirstResponder];
        [self.transferGName becomeFirstResponder];
    } else if (textField == self.transferGName) {
//        [self.transferGName resignFirstResponder];
        [self.transferServerName becomeFirstResponder];
    } else if (textField == self.transferServerName) {
//        [self.transferServerName resignFirstResponder];
        [self.transferCharacterName becomeFirstResponder];
    } else if (textField == self.transferCharacterName) {
        [self.transferCharacterName resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    } else if (textField == self.phoneNumber) {
//        [self.phoneNumber resignFirstResponder];
        [self.qqNumber becomeFirstResponder];
    } else if (textField == self.qqNumber) {
        [self.qqNumber resignFirstResponder];
        [self respondsToSureButton];
    }
    return YES;
}

- (void)setAllTextfildNil {
    self.oldCharacterName.text = nil;
    self.oldGameName.text = nil;
    self.oldServerName.text = nil;
    self.transferCharacterName.text = nil;
    self.transferServerName.text = nil;
    self.transferGName.text = nil;
    self.qqNumber.text = nil;
    self.phoneNumber.text = nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self initUserInterface];
}

- (void)initUserInterface {
    [self setViewFrame];
    [self setViewSetting];
}

- (void)setViewFrame {
    self.inputeBackground.backgroundColor = [UIColor whiteColor];
    self.oldGameName.frame = CGRectMake(0, 1, kSCREEN_WIDTH / 3, 44);
    self.transferGName.frame = CGRectMake(0, CGRectGetMaxY(self.oldGameName.frame) + 44, kSCREEN_WIDTH / 3, 44);
    self.oldServerName.frame = CGRectMake(kSCREEN_WIDTH / 3, 1, kSCREEN_WIDTH / 3, 44);
    self.transferServerName.frame = CGRectMake(kSCREEN_WIDTH / 3, CGRectGetMinY(self.transferGName.frame), kSCREEN_WIDTH / 3, 44);
    self.oldCharacterName.frame = CGRectMake(kSCREEN_WIDTH / 3 * 2, 1, kSCREEN_WIDTH / 3, 44);
    self.transferCharacterName.frame= CGRectMake(kSCREEN_WIDTH / 3 * 2, CGRectGetMinY(self.transferGName.frame), kSCREEN_WIDTH / 3, 44);

    self.inputeBackground.frame = CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.transferGName.frame) + 1);

    [self.layer addSublayer:self.line];
    self.remindLabel.frame = CGRectMake(10, CGRectGetMaxY(self.line.frame) + 5, kSCREEN_WIDTH - 20, 30);
    self.phoneNumber.frame = CGRectMake(10, CGRectGetMaxY(self.remindLabel.frame) + 10, kSCREEN_WIDTH - 20, 44);
    self.qqNumber.frame = CGRectMake(10, CGRectGetMaxY(self.phoneNumber.frame) + 5, kSCREEN_WIDTH - 20, 44);
    self.sureButton.frame = CGRectMake(kSCREEN_WIDTH / 6, CGRectGetMaxY(self.qqNumber.frame) + 10, kSCREEN_WIDTH / 4 * 3, 44);
}

- (void)setViewSetting {
    [self.sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:(UIControlEventTouchUpInside)];
    self.sureButton.layer.cornerRadius = 4;
    self.sureButton.layer.masksToBounds = YES;
}

- (void)respondsToSureButton {
    if (self.oldGameName.text.length == 0) {
        BOX_MESSAGE(@"原始游戏名称不能为空");
        return;
    }
    if (self.oldServerName.text.length == 0) {
        BOX_MESSAGE(@"原始区服名称不能为空");
        return;
    }
    if (self.oldCharacterName.text.length == 0) {
        BOX_MESSAGE(@"原始角色名称不能为空");
        return;
    }
    if (self.transferGName.text.length == 0) {
        BOX_MESSAGE(@"新的游戏名称不能为空");
        return;
    }
    if (self.transferServerName.text.length == 0) {
        BOX_MESSAGE(@"新的区服名称不能为空");
        return;
    }
    if (self. transferCharacterName.text.length == 0) {
        BOX_MESSAGE(@"新的角色名称不能为空");
        return;
    }
    if (self.qqNumber.text.length == 0 && self.phoneNumber.text.length == 0) {
        BOX_MESSAGE(@"至少填写一种联系方式");
        return;
    }

    NSDictionary *dict = @{@"origin_appname":self.oldGameName.text,
                           @"origin_servername":self.oldServerName.text,
                           @"origin_rolename":self.oldCharacterName.text,
                           @"new_appname":self.transferGName.text,
                           @"new_servername":self.transferServerName.text,
                           @"new_rolename":self.transferCharacterName.text,
                           @"qq":self.qqNumber.text,
                           @"mobile":self.phoneNumber.text};
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFApplyTransferView:clickSureButton:)]) {
        [self.delegate FFApplyTransferView:self clickSureButton:dict];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.oldGameName resignFirstResponder];
    [self.oldServerName resignFirstResponder];
    [self.oldCharacterName resignFirstResponder];
    [self.transferGName resignFirstResponder];
    [self.transferServerName resignFirstResponder];
    [self.transferCharacterName resignFirstResponder];
    [self.qqNumber resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
}



#pragma mark - getter
- (CALayer *)line {
    if (!_line) {
        _line = [[CALayer alloc] init];
        _line.frame = CGRectMake(0, CGRectGetMaxY(self.inputeBackground.frame), kSCREEN_WIDTH, 2);
        _line.backgroundColor = BACKGROUND_COLOR.CGColor;
    }
    return _line;
}



@end
