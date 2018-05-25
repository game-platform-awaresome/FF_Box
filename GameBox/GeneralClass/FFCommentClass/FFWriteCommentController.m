//
//  FFWriteCommentController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFWriteCommentController.h"
#import "FFViewFactory.h"
#import "FFGameModel.h"
#import "FFCurrentGameModel.h"

@interface FFWriteCommentController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

/** 游戏评分 */
@property (nonatomic, strong) UILabel *label;


/** 分数 */
@property (nonatomic, strong) UILabel *starGradeLabel;
@property (nonatomic, assign) CGFloat sorce;

/** 发表评论 */
@property (nonatomic, strong) UIBarButtonItem *commentButton;


@end

@implementation FFWriteCommentController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView resignFirstResponder];
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)initDataSource {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发表评论";
    [self.view addSubview:self.textView];
    self.navigationItem.rightBarButtonItem = self.commentButton;
}

#pragma mark - respondsToCommentButton
- (void)respondsToCommentButton {
    if (self.textView.text.length == 0) {
        BOX_MESSAGE(@"还没有输入哦~");
        return;
    }
#warning 发布评论
    syLog(@"发布评论");
    WeakSelf;
    [CURRENT_GAME sendCommentWithText:self.textView.text ToUid:nil is_fake:nil isGameID:nil Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"send comment === %@",content);
        if (weakSelf.sendCommentCallBack) {
            weakSelf.sendCommentCallBack(content, success);
        }
        if (success) {
            weakSelf.textView.text = @"";
        }
    }];

}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"点击评论~"]) {
        textView.font = [UIFont systemFontOfSize:16];
        textView.textAlignment = NSTextAlignmentJustified;
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

#pragma makr - stardelegate
- (void)numberOfSorce:(CGFloat)Sorce {
    _sorce = Sorce;
    self.starGradeLabel.text = [NSString stringWithFormat:@"%.1lf分",_sorce];
    [self.starGradeLabel sizeToFit];
}

#pragma mark - setter
- (void)setGameName:(NSString *)gameName {
    _gameName = gameName;

    syLog(@"topic ===  %@",gameName);
    //    self.navigationItem.title = _gameName;
    _sorce = 5.0;

    self.textView.text = @"良心平台,很不错的游戏~";
    self.textView.textColor = [UIColor blackColor];

}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH - 20, (kSCREEN_WIDTH - 20) * 0.618);
        _textView.center = CGPointMake(kSCREEN_WIDTH / 2, 120 + (kSCREEN_WIDTH - 20) * 0.309);



        _textView.textAlignment = NSTextAlignmentJustified;

        _textView.textColor = [UIColor blackColor];
        // 设置自动纠错方式
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        // 设置自动大写方式
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.text = @"良心平台,很不错的游戏~";

        _textView.returnKeyType = UIReturnKeySend;

        _textView.backgroundColor = [UIColor whiteColor];

        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 2;
        _textView.layer.cornerRadius = 8;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(10, 80, 80, 44);
        _label.text = @"游戏评分:";
        _label.textAlignment = NSTextAlignmentCenter;
        [_label sizeToFit];
    }
    return _label;
}


- (UIBarButtonItem *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCommentButton)];
    }
    return _commentButton;
}


@end
