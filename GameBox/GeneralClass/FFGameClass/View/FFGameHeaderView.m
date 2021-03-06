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

/** 设置视图 */
@property (nonatomic, strong) UIView *settingView;

@property (nonatomic, strong) UIImageView   *logoImageView;
@property (nonatomic, strong) UIImageView   *typeImageView;     //独家 or 联合
@property (nonatomic, strong) UILabel       *gameNameLabel;
@property (nonatomic, strong) UIButton      *discountLabel;
@property (nonatomic, strong) UIView        *starView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *starsArray;
@property (nonatomic, strong) UIView        *gameLabelView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelArray;
@property (nonatomic, strong) UILabel       *gameSizeAndDownloadLabel;
@property (nonatomic, strong) UIButton      *QQGroupButton;


@property (nonatomic, strong) UIView        *hotBackView;
@property (nonatomic, strong) UIImageView   *hotTopView;
@property (nonatomic, strong) UIImageView   *hotBottomView;
@property (nonatomic, strong) UIImageView   *hotLabelView;
@property (nonatomic, strong) UILabel       *hotTitleLabel;

@property (nonatomic, strong) UILabel       *hotNumberLabel;


/** 账号交易按钮 */
@property (nonatomic, strong) UIButton *AccountTransactionButton;
/** 账号交易数量 */
@property (nonatomic, strong) UILabel *accountTransactionLabel;



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

    [self setAccountTransactionButton];
}



#pragma mark - responds
- (void)respondsToAccountTransactionButton {
    if (CURRENT_GAME.accountTransaction) {
        CURRENT_GAME.accountTransaction();
    }
}

- (void)respondsToHotView:(UITapGestureRecognizer *)sender {
    syLog(@"排行榜");
    if (self.hotButtonBlock) {
        self.hotButtonBlock();
    }
}

- (void)refresh {
    //背景
    self.backgroundView.image = [UIImage imageNamed:[CURRENT_GAME.operate isEqualToString:@"1"] ? @"Game_header_background_image1" : @"Game_header_background_image2"];

    //logo
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:CURRENT_GAME.game_logo_url] placeholderImage:[FFImageManager gameLogoPlaceholderImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CURRENT_GAME.game_logo_image = image;
    }];

    //图标
    self.typeImageView.image = [UIImage imageNamed:[CURRENT_GAME.operate isEqualToString:@"1"] ? @"Game_header_class1" : @"Game_header_class2"];

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

    if (self.betaString.length > 0) {
        self.gameSizeAndDownloadLabel.text = [NSString stringWithFormat:@"%@M | %@下载 | 公测时间 : %@",CURRENT_GAME.game_size,downLoadNumber,self.betaString];
    }else if (self.reservationString.length > 0) {
        self.gameSizeAndDownloadLabel.text = [NSString stringWithFormat:@"%@M | %@下载 | 上线时间 : %@",CURRENT_GAME.game_size,downLoadNumber,self.reservationString];
    } else {
        self.gameSizeAndDownloadLabel.text = [NSString stringWithFormat:@"%@M | %@下载",CURRENT_GAME.game_size,downLoadNumber];
    }

    //玩家 Q 群
    self.QQGroupButton.hidden = !(CURRENT_GAME.player_qq_group.length > 0);

    //账号交易
    self.AccountTransactionButton.hidden = !(CURRENT_GAME.transaction_switch.integerValue > 0 && CURRENT_GAME.transaction_number.integerValue > 0);

    //账号交易数量
    self.accountTransactionLabel.text = [NSString stringWithFormat:@"%@",CURRENT_GAME.transaction_number];
    [self.accountTransactionLabel sizeToFit];
    CGSize size = self.accountTransactionLabel.bounds.size;
    size.width = size.width < 10 ? 12 : size.width;

    self.accountTransactionLabel.frame = CGRectMake(self.AccountTransactionButton.bounds.size.width - 20, -10, size.width, 12);


    if (CURRENT_GAME.top_number.integerValue > 0) {
        [self.settingView addSubview:self.hotBackView];
        self.hotNumberLabel.text = [NSString stringWithFormat:@"top%@",CURRENT_GAME.top_number];
        self.frame = CGRectMake(0, 0, kScreenWidth, 320);
    } else {
        [self.hotBackView removeFromSuperview];
        self.frame = CGRectMake(0, 0, kScreenWidth, 270);
    }


}

- (void)showNavigationTitle {
    self.gameNameLabel.hidden = YES;
}

- (void)hideNavigationTitle {
    self.gameNameLabel.hidden = NO;
}

- (void)setBetaString:(NSString *)betaString {
    _betaString = betaString;
}

- (void)setReservationString:(NSString *)reservationString {
    _reservationString = reservationString;
}


#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

    self.settingView.frame = CGRectMake(15, kNAVIGATION_HEIGHT, frame.size.width - 30, frame.size.height - kNAVIGATION_HEIGHT);
    self.hotBackView.frame = CGRectMake(0, CGRectGetMaxY(self.gameSizeAndDownloadLabel.frame) + 2, self.settingView.bounds.size.width, 50);

    self.maskView.frame = CGRectMake(15, frame.size.height - 10, frame.size.width - 30, 10);
    [self setSettingChildeViewFrame:self.settingView.frame];

}

- (void)setSettingChildeViewFrame:(CGRect)frame {
    self.logoImageView.center = CGPointMake(frame.size.width / 2, 50);
    self.typeImageView.center = CGPointMake(frame.size.width / 2, 93);
    self.gameNameLabel.center = CGPointMake(frame.size.width / 2, 120);
    self.discountLabel.center = CGPointMake(frame.size.width - 15 - self.discountLabel.bounds.size.width / 2, self.discountLabel.bounds.size.height / 2);
    self.starView.center = CGPointMake(frame.size.width / 2, 140);
    self.gameLabelView.center = CGPointMake(frame.size.width / 2, 150);
    self.gameSizeAndDownloadLabel.frame = CGRectMake(0, 175, frame.size.width, 20);
    self.QQGroupButton.center = CGPointMake(40, 40);
}

- (void)refreshBackgroundHeight:(CGFloat)height {
    if (height <= 0) {
        self.backgroundView.frame = CGRectMake(0, 0 + height, self.bounds.size.width, self.bounds.size.height + fabs(height));
    }
}

- (void)setAccountTransactionButton {

    self.AccountTransactionButton = [UIButton hyb_buttonWithImage:@"Game_account_transaction" superView:self.settingView constraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(10);
        make.centerX.mas_equalTo(self.QQGroupButton.mas_centerX);
        make.top.mas_equalTo(self.QQGroupButton.mas_bottom).offset(30);
        //        make.size.mas_equalTo(CGSizeMake(50, 50));
    } touchUp:^(UIButton *sender) {
        [self respondsToAccountTransactionButton];
    }];

    [self.AccountTransactionButton setTitle:@"账号交易" forState:(UIControlStateNormal)];
    [self.AccountTransactionButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
    self.AccountTransactionButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.AccountTransactionButton.hidden = YES;
    [self.AccountTransactionButton layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:0];
    [self.AccountTransactionButton addSubview:self.accountTransactionLabel];
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
        [_settingView addSubview:self.typeImageView];
        [_settingView addSubview:self.gameNameLabel];
        [_settingView addSubview:self.discountLabel];
        [_settingView addSubview:self.starView];
        [_settingView addSubview:self.gameLabelView];
        [_settingView addSubview:self.gameSizeAndDownloadLabel];
        [_settingView addSubview:self.QQGroupButton];
//        [_settingView addSubview:self.hotBackView];
    }
    return _settingView;
}

- (UIView *)hotBackView {
    if (!_hotBackView) {
        _hotBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.gameSizeAndDownloadLabel.frame) + 2, self.settingView.bounds.size.width, 50)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToHotView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_hotBackView addGestureRecognizer:tap];

        self.hotTopView = [UIImageView hyb_imageViewWithImage:@"Game_hot_top" superView:_hotBackView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self -> _hotBackView).offset(0);
            make.left.mas_equalTo(self -> _hotBackView).offset(5);
            make.right.mas_equalTo(self -> _hotBackView).offset(-5);
            make.height.mas_equalTo(6);
        }];

        self.hotBottomView = [UIImageView hyb_imageViewWithImage:@"Game_hot_bottom" superView:_hotBackView constraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self -> _hotBackView).offset(0);
            make.left.mas_equalTo(self -> _hotBackView).offset(5);
            make.right.mas_equalTo(self -> _hotBackView).offset(-5);
            make.height.mas_equalTo(6);
        }];

        self.hotLabelView = [UIImageView hyb_imageViewWithImage:@"Game_hot_label" superView:_hotBackView constraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self -> _hotBackView).offset(-20);
            make.centerY.mas_equalTo(0);
        }];

        self.hotTitleLabel = [UILabel hyb_labelWithFont:18 superView:_hotBackView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self -> _hotBackView).offset(0);
            make.bottom.mas_equalTo(self -> _hotBackView).offset(0);
            make.left.mas_equalTo(self -> _hotBackView).offset(10);
        }];
        self.hotTitleLabel.textColor = [FFColorManager blue_dark];
        self.hotTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.hotTitleLabel.text = @"185平台最火游戏";

        self.hotNumberLabel = [UILabel hyb_labelWithFont:15 superView:_hotBackView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self -> _hotBackView).offset(0);
            make.bottom.mas_equalTo(self -> _hotBackView).offset(0);
            make.right.mas_equalTo(self.hotLabelView.mas_left).offset(-6);
        }];

    }
    return _hotBackView;
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

- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.bounds = CGRectMake(0, 0, 110, 25);
        _typeImageView.center = CGPointMake(kScreenWidth / 2, 93);
    }
    return _typeImageView;
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

- (UILabel *)accountTransactionLabel {
    if (!_accountTransactionLabel) {
        _accountTransactionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _accountTransactionLabel.font = [UIFont systemFontOfSize:9];
        _accountTransactionLabel.backgroundColor = [FFColorManager blue_dark];
        _accountTransactionLabel.layer.cornerRadius = 6;
        _accountTransactionLabel.layer.masksToBounds = YES;
        _accountTransactionLabel.textColor = kWhiteColor;
        _accountTransactionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountTransactionLabel;
}


@end




