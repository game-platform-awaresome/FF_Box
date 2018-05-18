//
//  FFDriveReplyView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/22.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveReplyView.h"
#import "FFDriveModel.h"
#import "FFViewFactory.h"

@class ReplyViewController;

static FFDriveReplyView *window = nil;
static ReplyViewController *rootViewController = nil;


@interface ReplyViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *removeButton;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSString *dynamicID;
@property (nonatomic, strong) NSString *toUid;

@end


@implementation ReplyViewController {
    bool sendCommentSuccess;
    BOOL isReply;
}


+ (instancetype)controller {
    if (rootViewController == nil) {
        rootViewController = [[ReplyViewController alloc] init];
    }
    return rootViewController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHideWithNotification:) name:UIKeyboardWillHideNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        sendCommentSuccess = false;
        isReply = NO;
    }
    return self;
}


- (void)keyboardWillShowWithNotification:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];

    [UIView animateWithDuration:time animations:^{
        self.backGroundView.frame = CGRectMake(0, kSCREEN_HEIGHT * 0.78 - keyboardSize.height, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.22);
    }];

}

- (void)keyboardWillHideWithNotification:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSNumber * duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat time = [duration floatValue];
    [UIView animateWithDuration:time animations:^{
        self.backGroundView.frame = CGRectMake(0, kSCREEN_HEIGHT * 0.78, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.22);
    } completion:^(BOOL finished) {
        if (sendCommentSuccess && finished) {
            [self.backGroundView removeFromSuperview];
        }
    }];

}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self respondsToTap];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.removeButton];
    [self.view addSubview:self.backGroundView];
    [self.textView becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self setSendButtonColorWith:textView.text];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 199) {
        textView.text = [textView.text substringToIndex:199];
    }
    [self setSendButtonColorWith:textView.text];
}

- (void)setSendButtonColorWith:(NSString *)text {
    if (text.length > 0) {
        self.sendButton.userInteractionEnabled = YES;
        [self.sendButton setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    } else {
        self.sendButton.userInteractionEnabled = NO;
        [self.sendButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    }
}



#pragma mark - responds tap
- (void)respondsToTap {
    [window resignKeyWindow];
    window = nil;
    rootViewController = nil;
}

- (void)respondsToSendButton {
    syLog(@"发送");
    if (isReply) {
        return;
    }
    isReply = YES;
    [FFDriveModel userSendCommentWithjDynamicsID:self.dynamicID ToUid:self.toUid Comment:self.textView.text Complete:^(NSDictionary *content, BOOL success) {
        if (success) {
            sendCommentSuccess = YES;
            [self.textView resignFirstResponder];
            [[NSNotificationCenter defaultCenter] postNotificationName:SendCommentNotificationName object:nil userInfo:content];

            [self respondsToTap];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        isReply = NO;
    }];
}

#pragma mark - getter
- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _removeButton.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [_removeButton addTarget:self action:@selector(respondsToTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT * 0.78, kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.22)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [_backGroundView addSubview:self.textView];
        [_backGroundView addSubview:self.sendButton];

    }
    return _backGroundView;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(10, 10, kSCREEN_WIDTH * 0.8, kSCREEN_HEIGHT * 0.22 - 20);
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
        _sendButton.frame = CGRectMake(kSCREEN_WIDTH * 0.8 + 3, kSCREEN_HEIGHT * 0.22 - 50, kSCREEN_WIDTH * 0.2 - 6, 44);
        [_sendButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
        [_sendButton addTarget:self action:@selector(respondsToSendButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sendButton;
}


- (void)dealloc {
    syLog(@"销毁通知");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


@end




@implementation FFDriveReplyView {

}

+ (void)showReplyViewWithDynamicID:(NSString *)dynamicID {
    [self showReplyViewWithDynamicID:dynamicID ToUid:nil];
}

+ (void)showReplyViewWithDynamicID:(NSString *)dynamicID ToUid:(NSString *)toUid {
    [self setDynamicID:dynamicID toUid:toUid];
    [[self SharedWindow] makeKeyAndVisible];
}

+ (void)setDynamicID:(NSString *)dynamicID toUid:(NSString *)toUid {
    [ReplyViewController controller].dynamicID = dynamicID;
    [ReplyViewController controller].toUid = toUid;
}


+ (instancetype)SharedWindow {
    if (window == nil) {
        window = [[FFDriveReplyView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        window.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        window.rootViewController = [ReplyViewController controller];
    }
    return window;
}









@end






