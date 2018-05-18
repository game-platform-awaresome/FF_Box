//
//  FFDetailFooterView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDetailFooterView.h"

@interface FFDetailFooterView ()



@end

const NSInteger BUTTON_TAG = 10086;

@implementation FFDetailFooterView {
    CGFloat buttonWidth;
    NSArray *buttonImageArray;
    NSArray *buttonTitleArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    buttonImageArray = @[@"Community_Like",@"Community_Unlike",@"Community_Shared",@"Communtiy_Comment"];
    buttonTitleArray = @[@"  赞",@"  踩",@"  分享",@"  评论"];
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    buttonWidth = kSCREEN_WIDTH / 4;
    _buttons = [NSMutableArray arrayWithCapacity:4];

    for (int i = 0; i < 4 ;i++) {
        UIButton *button = [self creatButtonWithIndex:i];
        [_buttons addObject:button];
        [self addSubview:button];
    }
}

- (UIButton *)creatButtonWithIndex:(NSUInteger)idx {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(idx * buttonWidth, 0, buttonWidth, 44);
    button.tag = idx + BUTTON_TAG;
    [button setTitle:buttonTitleArray[idx] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:buttonImageArray[idx]] forState:(UIControlStateNormal)];
    [button setTintColor:[UIColor grayColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14];

    [self addRespondsToButton:button];
    return button;
}

- (void)setModel:(FFDynamicModel *)model {
    _model = model;
    [self setLikeButtonWith:model.likes_number];
    [self setUnLikeButtonWith:model.dislikes_number];
    [self setSharedButtonWith:model.shared_number];
    [self setCommentButtonWith:model.comments_number];
    [self setOperateWith:model.operate];
}


- (void)setLikeButtonWith:(NSString *)string {
    UIButton *button = self.buttons[0];
    [button setTitle:[NSString stringWithFormat:@"  %@赞",string] forState:(UIControlStateNormal)];
}

- (void)setUnLikeButtonWith:(NSString *)string {
    UIButton *button = self.buttons[1];
    [button setTitle:[NSString stringWithFormat:@"  %@踩",string] forState:(UIControlStateNormal)];
}

- (void)setSharedButtonWith:(NSString *)string {
    UIButton *button = self.buttons[2];
    [button setTitle:[NSString stringWithFormat:@"  %@分享",string] forState:(UIControlStateNormal)];
}

- (void)setCommentButtonWith:(NSString *)string {
    UIButton *button = self.buttons[3];
    [button setTitle:[NSString stringWithFormat:@"  %@评论",string] forState:(UIControlStateNormal)];
}

- (void)setOperateWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string != nil && string.length != 0) {
//        syLog(@"operate string === %@",str);
        switch (string.integerValue) {
            case 0: {
                [self addRespondsToButton:self.buttons[0]];
                [self addRespondsToButton:self.buttons[1]];
                self.buttons[0].tintColor = [UIColor grayColor];
                self.buttons[1].tintColor = [UIColor redColor];
            }
                break;
            case 1: {
                [self addRespondsToButton:self.buttons[0]];
                [self addRespondsToButton:self.buttons[1]];
                self.buttons[0].tintColor = [UIColor redColor];
                self.buttons[1].tintColor = [UIColor grayColor];
            }
                break;
            case 2: {
                [self addRespondsToButton:self.buttons[0]];
                [self addRespondsToButton:self.buttons[1]];
                self.buttons[0].tintColor = [UIColor grayColor];
                self.buttons[1].tintColor = [UIColor grayColor];
            }
                break;

            default: {
                [self canNotRespondsToLikeButtonAndDislikeButton];
            }
                break;
        }
    } else {
        [self canNotRespondsToLikeButtonAndDislikeButton];
    }
}

- (void)canNotRespondsToLikeButtonAndDislikeButton {
    [self removeLikeButtonAndeDisLikeButtonSelect];
    self.buttons[0].tintColor = [UIColor grayColor];
    self.buttons[1].tintColor = [UIColor grayColor];
}

- (void)removeLikeButtonAndeDisLikeButtonSelect {
    [self removeRespondsToButton:self.buttons[0]];
    [self removeRespondsToButton:self.buttons[1]];
}

- (void)addRespondsToButton:(UIButton *)button {
    [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)removeRespondsToButton:(UIButton *)button {
    [button removeTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
}



#pragma mark - responds
- (void)respondsToButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFDetailFooterView:didClickButton:)]) {
        [self.delegate FFDetailFooterView:self didClickButton:(sender.tag - BUTTON_TAG)];
    }
}



@end





