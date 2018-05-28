//
//  FFAdvertisingView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/12/4.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFAdvertisingView.h"


@interface FFAdvertisingView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *closebutton;

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation FFAdvertisingView

+ (FFAdvertisingView *)initWithImage:(NSData *)data {
    FFAdvertisingView *view = [[FFAdvertisingView alloc] init];

    view.imageView.image = [UIImage imageWithData:data];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view respondsToCloseButton];
    });

    return view;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [self addSubview:self.imageView];
//    [self addSubview:self.label];
    [self addSubview:self.closebutton];

}

- (void)respondsToCloseButton {
    [self removeFromSuperview];
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH * 0.7, 40, 30, 30)];
        _label.backgroundColor = BACKGROUND_COLOR;
        _label.text = @"广告";
        [_label sizeToFit];
    }
    return _label;
}


- (UIButton *)closebutton {
    if (!_closebutton) {
        _closebutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closebutton.frame = CGRectMake(kSCREEN_WIDTH * 0.8, kSCREEN_HEIGHT * 0.85, 30, 30);
        [_closebutton setTitle:@" 关闭 " forState:(UIControlStateNormal)];
        [_closebutton setTitleColor:NAVGATION_BAR_COLOR forState:(UIControlStateNormal)];
        _closebutton.titleLabel.font = [UIFont systemFontOfSize:20];
        [_closebutton sizeToFit];
        _closebutton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        [_closebutton addTarget:self action:@selector(respondsToCloseButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closebutton;
}


@end








