//
//  FFMineHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/5/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFMineHeaderView.h"
#import "FFColorManager.h"
#import "FFImageManager.h"

#import "FFUserModel.h"
#import <UIImageView+WebCache.h>
#import <FFTools/FFTools.h>


@interface FFMineHeaderView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *vipImageView;

@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) UIView *coinView;

@property (nonatomic, strong) UILabel *goldMoneyLabel;
@property (nonatomic, strong) UILabel *platformMoneyLabel;
@property (nonatomic, strong) UILabel *inviteModeyLabel;

@property (nonatomic, strong) UILabel *goldLabel;
@property (nonatomic, strong) UILabel *platformLabel;
@property (nonatomic, strong) UILabel *inviteLabel;

@property (nonatomic, strong) UIButton *openVipButton;

@property (nonatomic, strong) UIButton *goldCenterButton;
@property (nonatomic, strong) UIButton *platformButton;


@end


@implementation FFMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {

    self.backgroundColor = [FFColorManager blue_dark];
    [UIImageView hyb_imageViewWithImage:@"Mine_header_background" superView:self constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self).offset(0);
        make.right.mas_equalTo(self).offset(0);
    }];

    [self addSubview:self.avatarImageView];
    [self addSubview:self.vipImageView];
    [self addSubview:self.nameButton];
    [self addSubview:self.coinView];
    [self refreshUserInterface];
}

- (void)refreshUserInterface {
    self.isLogin = CURRENT_USER.isLogin;
    [self setCoinviewInfo];
}

- (void)setLoginView {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:CURRENT_USER.icon_url] placeholderImage:nil];

    self.avatarImageView.center = CGPointMake(kSCREEN_WIDTH / 2, 82);

    self.vipImageView.center = CGPointMake(CGRectGetMaxX(self.avatarImageView.frame) - 10, CGRectGetMaxY(self.avatarImageView.frame) - 10);

    self.nameButton.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.avatarImageView.frame) + self.nameButton.bounds.size.height / 2);
    [self.nameButton setTitle:CURRENT_USER.nick_name forState:(UIControlStateNormal)];

    CURRENT_USER.is_vip.boolValue ? [self setNotOpenViewFram] : [self setOpenVipFrame];

    CGRect frame = self.goldMoneyLabel.frame;
    frame.size.height = 44;
    self.goldCenterButton.frame = frame;

    frame = self.platformMoneyLabel.frame;
    frame.size.height = 44;
    self.platformButton.frame = frame;

    self.vipImageView.hidden = NO;
}

- (void)setNotLoginView {
    self.avatarImageView.image = [FFImageManager Mine_not_login_avatar];
    self.avatarImageView.center = CGPointMake(50, 110);
    self.nameButton.center = CGPointMake(CGRectGetMaxX(self.avatarImageView.frame) + 10 + self.nameButton.bounds.size.width / 2, 110);
    [self.nameButton setTitle:@"登录/注册" forState:(UIControlStateNormal)];
    [self setNotOpenViewFram];
    self.goldCenterButton.frame = CGRectZero;
    self.platformButton.frame = CGRectZero;

    self.vipImageView.hidden = YES;
}

- (void)setOpenVipFrame {
    self.vipImageView.image = [FFImageManager Mine_vip_no];
    [self setCoinviewWithWideth:kSCREEN_WIDTH / 4];
    self.openVipButton.hidden = NO;
}

- (void)setNotOpenViewFram {
    self.vipImageView.image = [FFImageManager Mine_vip_yes];
    [self setCoinviewWithWideth:kSCREEN_WIDTH / 3];
    self.openVipButton.hidden = YES;
}

- (void)setCoinviewWithWideth:(CGFloat)width {
    self.goldLabel.frame = CGRectMake(0, 33, width , 20);
    self.platformLabel.frame = CGRectMake(width, 33, width, 20);
    self.inviteLabel.frame = CGRectMake(width * 2, 33, width, 20);

    self.goldMoneyLabel.frame = CGRectMake(0, 13, width , 20);
    self.platformMoneyLabel.frame = CGRectMake(width, 13, width, 20);
    self.inviteModeyLabel.frame = CGRectMake(width * 2, 13, width, 20);

    self.openVipButton.frame = CGRectMake(width * 3 + 8, 18, width - 16, 30);
}

- (void)setCoinviewInfo {
    self.goldMoneyLabel.text = CURRENT_USER.coin;
    self.platformMoneyLabel.text = CURRENT_USER.platform_money;
    self.inviteModeyLabel.text = CURRENT_USER.recom_bonus;
}


#pragma mark - responds
- (void)respondsToAvatarImageView:(UITapGestureRecognizer *)sender {
    if (_isLogin) {
        if (self.modifyAratarBlock) self.modifyAratarBlock();
    } else {
        if (self.loginBlock) self.loginBlock();
    }
}

- (void)respondsToNameButton:(UIButton *)sender {
    if (_isLogin) {
        if (self.modifyNickName) {
//            self.modifyNickName();
            syLog(@"%@",self.modifyNickName());
        };
    } else {
        if (self.loginBlock) self.loginBlock();
    }
}

- (void)respondsToOpenVipButoon {
    if (!CURRENT_USER.is_vip.boolValue && self.openVip) {
        self.openVip();
    }
}

#pragma mark - setter
- (void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    CURRENT_USER.isLogin ? [self setLoginView] : [self setNotLoginView];
}

#pragma mark - getter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.bounds = CGRectMake(0, 0, 60, 60);
        _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.height / 2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [FFColorManager navigation_bar_white_color].CGColor;
        _avatarImageView.layer.borderWidth = 3;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToAvatarImageView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}

- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 28)];
    }
    return _vipImageView;
}

- (UIButton *)nameButton {
    if (!_nameButton) {
        _nameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _nameButton.bounds = CGRectMake(0, 0, 100, 44);
        [_nameButton addTarget:self action:@selector(respondsToNameButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nameButton;
}

- (UIView *)coinView {
    if (!_coinView) {
        _coinView = [[UIView alloc] initWithFrame:CGRectMake(0, 168, kSCREEN_WIDTH, 67)];
        _coinView.backgroundColor = [FFColorManager navigation_bar_white_color];

        CALayer *layer1 = [[CALayer alloc] init];
        layer1.backgroundColor = [FFColorManager home_select_View_separat_lineColor].CGColor;
        layer1.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);
        [_coinView.layer addSublayer:layer1];

        CALayer *layer2 = [[CALayer alloc] init];
        layer2.backgroundColor = [FFColorManager home_select_View_separat_lineColor].CGColor;
        layer2.frame = CGRectMake(0, _coinView.bounds.size.height - 1, kSCREEN_WIDTH, 1);
        [_coinView.layer addSublayer:layer2];

        [_coinView addSubview:self.goldMoneyLabel];
        [_coinView addSubview:self.goldLabel];
        [_coinView addSubview:self.platformMoneyLabel];
        [_coinView addSubview:self.platformLabel];
        [_coinView addSubview:self.inviteModeyLabel];
        [_coinView addSubview:self.inviteLabel];
        [_coinView addSubview:self.openVipButton];
        [_coinView addSubview:self.goldCenterButton];
        [_coinView addSubview:self.platformButton];
    }
    return _coinView;
}

- (UILabel *)creatLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 4, 20);
    label.textColor = [FFColorManager textColorMiddle];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

- (UILabel *)goldLabel {
    if (!_goldLabel) {
        _goldLabel = [self creatLabel];
        _goldLabel.text = @"金币";
    }
    return _goldLabel;
}

- (UILabel *)platformLabel {
    if (!_platformLabel) {
        _platformLabel = [self creatLabel];
        _platformLabel.text = @"平台币";
    }
    return _platformLabel;
}

- (UILabel *)inviteLabel {
    if (!_inviteLabel) {
        _inviteLabel = [self creatLabel];
        _inviteLabel.text = @"邀请奖励";
    }
    return _inviteLabel;
}

- (UILabel *)goldMoneyLabel {
    if (!_goldMoneyLabel) {
        _goldMoneyLabel = [self creatLabel];
        _goldMoneyLabel.textColor = [FFColorManager blue_dark];
        _goldMoneyLabel.text = @"0";
    }
    return _goldMoneyLabel;
}

- (UILabel *)platformMoneyLabel {
    if (!_platformMoneyLabel) {
        _platformMoneyLabel = [self creatLabel];
        _platformMoneyLabel.textColor = [FFColorManager blue_dark];
        _platformMoneyLabel.text = @"0";
    }
    return _platformMoneyLabel;
}

- (UILabel *)inviteModeyLabel {
    if (!_inviteModeyLabel) {
        _inviteModeyLabel = [self creatLabel];
        _inviteModeyLabel.textColor = [FFColorManager blue_dark];
        _inviteModeyLabel.text = @"0";
    }
    return _inviteModeyLabel;
}


- (UIButton *)openVipButton {
    if (!_openVipButton) {
        _openVipButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _openVipButton.backgroundColor = [FFColorManager blue_dark];
        [_openVipButton setTitle:@"开通VIP" forState:(UIControlStateNormal)];
        [_openVipButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];
        [_openVipButton addTarget:self action:@selector(respondsToOpenVipButoon) forControlEvents:(UIControlEventTouchUpInside)];
        _openVipButton.layer.cornerRadius = 8;
        _openVipButton.layer.masksToBounds = YES;
    }
    return _openVipButton;
}

- (UIButton *)goldCenterButton {
    if (!_goldCenterButton) {
        _goldCenterButton = [UIButton createButtonWithAction:^(UIButton * _Nonnull button) {
            if (self.goldCenter) {
                self.goldCenter();
            }
        }];
    }
    return _goldCenterButton;
}

- (UIButton *)platformButton {
    if (!_platformButton) {
        _platformButton = [UIButton createButtonWithAction:^(UIButton * _Nonnull button) {
            if (self.platform) {
                self.platform();
            }
        }];
    }
    return _platformButton;
}




@end

