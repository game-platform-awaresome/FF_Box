//
//  FFMaskView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFMaskView.h"

@interface FFMaskView ()

@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation FFMaskView

+ (void)addMaskViewWithWindow:(UIWindow *)window {
    FFMaskView * _maskView = [[FFMaskView alloc] initWithFrame:window.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.8;
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) ];
    CGSize scanSize = CGSizeMake(70, 70);
    CGRect scanRect = CGRectMake(kSCREEN_WIDTH / 2 - 35, kSCREEN_HEIGHT  - 70, scanSize.width, scanSize.height);
    [bpath appendPath:[[UIBezierPath bezierPathWithOvalInRect:scanRect] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    self.layer.mask = shapeLayer;
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    [self addSubview:self.hideButton];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hideButton addTarget:self action:@selector(respondsToButton) forControlEvents:(UIControlEventTouchUpInside)];
    });
}

#pragma mark -
- (void)respondsToButton {
    [self removeFromSuperview];
}


#pragma mark - getter
- (UIButton *)hideButton {
    if (!_hideButton) {
        _hideButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _hideButton.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    return _hideButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 10, kSCREEN_HEIGHT - kSCREEN_WIDTH / 3 / 0.9 - 45, kSCREEN_WIDTH / 3 - kSCREEN_WIDTH / 20, kSCREEN_WIDTH / 3 / 0.9)];
        _imageView.image = [UIImage imageNamed:@"Community_Arrow"];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"点击邀请好友,\n赚取充值";
        _label.numberOfLines = 0;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:22];
        _label.textAlignment = NSTextAlignmentCenter;
        [_label sizeToFit];
        _label.frame = CGRectMake(10, CGRectGetMinY(self.imageView.frame) - _label.bounds.size.height, _label.bounds.size.width, _label.bounds.size.height);
    }
    return _label;
}



@end







