//
//  FFGameHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameHeaderView.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import "FFCurrentGameModel.h"
#import "FFControllerManager.h"
#import <UIImageView+WebCache.h>
#import <FFTools/FFTools.h>


@interface FFGameHeaderView ()

@property (nonatomic, strong) UIView *settingView;

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *gameNameLabel;
@property (nonatomic, strong) UIButton *discountLabel;
@property (nonatomic, strong) UIView *starView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *starsArray;
@property (nonatomic, strong) UIView *gameLabelView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelArray;
@property (nonatomic, strong) UILabel *gameSizeAndDownloadLabel;
@property (nonatomic, strong) UIButton *QQGroupButton;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation FFGameHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

#pragma makr - responds
- (void)respondsToQQButton {
    if (self.qqGroupButtonBlock) {
        self.qqGroupButtonBlock();
    }
}

- (void)initUserInterface {
    [self addSubview:self.backgroundView];
    [self addSubview:self.settingView];
    [self addSubview:self.maskView];
}

- (void)refresh {
    //logo
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:CURRENT_GAME.game_logo_url] placeholderImage:[FFImageManager gameLogoPlaceholderImage]];
    //game name logo
    self.gameNameLabel.text = CURRENT_GAME.game_name;
    //discount
    if (CURRENT_GAME.game_discount != nil && CURRENT_GAME.game_discount.floatValue > 0) {
        self.discountLabel.hidden = NO;
        [self.discountLabel setTitle:[NSString stringWithFormat:@"%.1lf折",CURRENT_GAME.game_discount.floatValue] forState:(UIControlStateNormal)];
    } else {
        self.discountLabel.hidden = YES;
    }
    //stars
    CGFloat stars = CURRENT_GAME.game_score.floatValue;
    for (int i = 0; i < 5; i++) {
        stars -= 1;
        if (stars >= 0) {
            [_starsArray[i] setImage:[FFImageManager Game_header_stars_light]];
        } else if (stars > -1) {
            [_starsArray[i] setImage:[FFImageManager Game_header_stars_half]];
        } else {
            [_starsArray[i] setImage:[FFImageManager Game_header_stars_dark]];
        }
    }
    //label
    int currentIdx = 0;
    for (int idx = 0; idx < CURRENT_GAME.game_label_array.count; idx++) {
        NSString *obj = CURRENT_GAME.game_label_array[idx];
        if (idx < self.labelArray.count) {
            [self.labelArray[idx] setText:[NSString stringWithFormat:@" %@ ",obj]];
            [self.labelArray[idx] sizeToFit];
            currentIdx = idx;
        }
    }
    CGRect bounds = CGRectZero;
    for (int idx = 0; idx < self.labelArray.count; idx++) {
        UILabel *label = self.labelArray[idx];
        if (idx <= currentIdx) {
            label.frame = CGRectMake(bounds.size.width, 0, label.bounds.size.width, label.bounds.size.height);
            bounds.size.width += (label.bounds.size.width + 2);
            [self.gameLabelView addSubview:label];
        } else {
            [label removeFromSuperview];
        }
    }
    self.gameLabelView.bounds = bounds;

    //size and download
    NSString *downLoadNumber = (CURRENT_GAME.game_download_number.integerValue > 10000) ? [NSString stringWithFormat:@"%ld万+",(CURRENT_GAME.game_download_number.integerValue / 10000)] : CURRENT_GAME.game_download_number;
    self.gameSizeAndDownloadLabel.text = [NSString stringWithFormat:@"%@M | %@下载",CURRENT_GAME.game_size,downLoadNumber];

    //玩家 Q 群
    self.QQGroupButton.hidden = !(CURRENT_GAME.player_qq_group.length > 0);
}

- (void)showNavigationTitle {
    self.gameNameLabel.hidden = YES;
}

- (void)hideNavigationTitle {
    self.gameNameLabel.hidden = NO;
}


#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

    self.settingView.frame = CGRectMake(15, kNAVIGATION_HEIGHT, frame.size.width - 30, frame.size.height - kNAVIGATION_HEIGHT);
    self.maskView.frame = CGRectMake(15, frame.size.height - 10, frame.size.width - 30, 10);
    [self setSettingChildeViewFrame:self.settingView.frame];

}

- (void)setSettingChildeViewFrame:(CGRect)frame {
    self.logoImageView.center = CGPointMake(frame.size.width / 2, 50);
    self.gameNameLabel.center = CGPointMake(frame.size.width / 2, 100);
    self.discountLabel.center = CGPointMake(frame.size.width - 15 - self.discountLabel.bounds.size.width / 2, self.discountLabel.bounds.size.height / 2);
    self.starView.center = CGPointMake(frame.size.width / 2, 120);
    self.gameLabelView.center = CGPointMake(frame.size.width / 2, 130);
    self.gameSizeAndDownloadLabel.frame = CGRectMake(0, 155, frame.size.width, 20);
    self.QQGroupButton.center = CGPointMake(40, 40);
}

- (void)refreshBackgroundHeight:(CGFloat)height {
    if (height <= 0) {
        self.backgroundView.frame = CGRectMake(0, 0 + height, self.bounds.size.width, self.bounds.size.height + fabs(height));
    }
}

#pragma mark - getter
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[FFImageManager Game_header_background_image]];
    }
    return _backgroundView;
}

- (UIView *)settingView {
    if (!_settingView) {
        _settingView = [[UIView alloc] initWithFrame:CGRectMake(15, kNAVIGATION_HEIGHT, 220, 20)];
        _settingView.backgroundColor = [FFColorManager game_header_setview_BKColor];
        _settingView.layer.cornerRadius = 8;
        _settingView.layer.masksToBounds = YES;

        [_settingView addSubview:self.logoImageView];
        [_settingView addSubview:self.gameNameLabel];
        [_settingView addSubview:self.discountLabel];
        [_settingView addSubview:self.starView];
        [_settingView addSubview:self.gameLabelView];
        [_settingView addSubview:self.gameSizeAndDownloadLabel];
        [_settingView addSubview:self.QQGroupButton];
    }
    return _settingView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.bounds = CGRectMake(0, 0, 60, 60);
        _logoImageView.layer.cornerRadius = 8;
        _logoImageView.layer.masksToBounds = YES;
    }
    return _logoImageView;
}

- (UILabel *)gameNameLabel {
    if (!_gameNameLabel) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.6, 20);
        _gameNameLabel.font = [UIFont systemFontOfSize:18];
        _gameNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _gameNameLabel;
}

- (UIButton *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_discountLabel setBackgroundImage:[FFImageManager Game_header_discount_iamge] forState:(UIControlStateNormal)];
        CGSize size = [FFImageManager Game_header_discount_iamge].size;
        _discountLabel.bounds = CGRectMake(0, 0, size.width, size.height);
        _discountLabel.hidden = YES;
        _discountLabel.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _discountLabel;
}

- (UIView *)starView {
    if (!_starView) {
        _starView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 10)];
        _starsArray = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0 ; i < 5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 13, 0, 10, 10)];
            [_starView addSubview:imageView];
            [_starsArray addObject:imageView];
        }
    }
    return _starView;
}

- (UIView *)gameLabelView {
    if (!_gameLabelView) {
        _gameLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];

    }
    return _gameLabelView;
}

- (NSMutableArray<UILabel *> *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [FFColorManager text_color_array][i];
            label.textColor = [FFColorManager game_header_label_color];
            label.font = [UIFont systemFontOfSize:13];
            label.layer.cornerRadius = 4;
            label.layer.masksToBounds = YES;
            [_labelArray addObject:label];
        }
    }
    return _labelArray;
}

- (UILabel *)gameSizeAndDownloadLabel {
    if (!_gameSizeAndDownloadLabel) {
        _gameSizeAndDownloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 20)];
        _gameSizeAndDownloadLabel.textColor = [FFColorManager textColorMiddle];
        _gameSizeAndDownloadLabel.textAlignment = NSTextAlignmentCenter;
        _gameSizeAndDownloadLabel.font = [UIFont systemFontOfSize:13];
    }
    return _gameSizeAndDownloadLabel;
}

- (UIButton *)QQGroupButton {
    if (!_QQGroupButton) {
        _QQGroupButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _QQGroupButton.bounds = CGRectMake(0, 0, 60, 60);
        [_QQGroupButton setTitle:@"玩家QQ群" forState:(UIControlStateNormal)];
        _QQGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_QQGroupButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_QQGroupButton setImage:[FFImageManager Game_header_QQ] forState:(UIControlStateNormal)];
        [_QQGroupButton layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:2];
        [_QQGroupButton addTarget:self action:@selector(respondsToQQButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _QQGroupButton;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [FFColorManager game_header_setview_BKColor];
    }
    return _maskView;
}


@end




