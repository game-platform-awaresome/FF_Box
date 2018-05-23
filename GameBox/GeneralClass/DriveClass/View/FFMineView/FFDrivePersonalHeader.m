//
//  FFDrivePersonalHeader.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/30.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDrivePersonalHeader.h"
#import "SYKeychain.h"
#import "UIImageView+WebCache.h"

#import "FFViewFactory.h"
#import "FFDriveModel.h"

@interface FFDrivePersonalHeader ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

// icon
@property (nonatomic, strong) UIImageView *iconImageView;
// nick name label
@property (nonatomic, strong) UILabel *nickNameLabel;
// nick name
@property (nonatomic, strong) NSString *nickName;
// sex image
@property (nonatomic, strong) UIImageView *sexImage;
// vip image
@property (nonatomic, strong) UIImageView *vipImage;

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *driverLevelLabel;


/** tableHeaderView */
@property (nonatomic, strong) UIButton *attentionButton;


@end



@implementation FFDrivePersonalHeader {
    NSString *iconUrl;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.62);
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.sexImage];
    [self addSubview:self.vipImage];
    [self addSubview:self.driverLevelLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.attentionButton];
}

- (void)hideNickName:(BOOL)hide {
    self.nickNameLabel.hidden = hide;
}

#pragma mark - responds
- (void)respondsToAttentionButton {
//    FF_is_login;
    syLog(@"关注 %@",self.model.present_user_uid);
    START_NET_WORK;
    [FFDriveModel userAttentionWith:self.model.present_user_uid Type:(self.model.attention.integerValue == 0) ? attention : cancel  Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"attention === %@",content);
        STOP_NET_WORK;
        if (success) {
            if (self.model.attention.integerValue == 0) {
                self.model.attention = @"1";
            } else {
                self.model.attention = @"0";
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }

        [self setAttentionWith:self.model.attention];
    }];

}

#pragma mark - setter
- (void)setModel:(FFDynamicModel *)model {
    _model = model;
    
    syLog(@"mine center model == model");
    // nick name
    [self setNickName:model.present_user_nickName];
    // sex
    [self setSexWith:model.present_user_sex];
    // vip
    [self setVipWith:model.present_user_vip];
    //image
    [self setImageUrl:model.present_user_iconImageUrlString];
    //
    [self setDriverLevelWith:model.present_user_driver_level];
    [self setDescriptionWith:model.present_user_desc];

    [self setAttentionWith:model.attention];
}


- (void)setIconImage:(UIImage *)iconImage {
    self.iconImageView.image = iconImage;
}

- (void)setImageUrl:(NSString *)imageurl {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
}

- (void)setNickName:(NSString *)nickName {
    NSString *string = [NSString stringWithFormat:@" %@ ",nickName];
    _nickName = string;
    self.nickNameLabel.text = string;
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.hidden = NO;
    self.nickNameLabel.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.iconImageView.frame) + self.nickNameLabel.bounds.size.height / 2 + 8);

    self.sexImage.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 10, self.nickNameLabel.center.y);
    self.vipImage.center = CGPointMake(CGRectGetMaxX(self.sexImage.frame) + 10, self.nickNameLabel.center.y);
}

- (void)setSexWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexImage.hidden = NO;
        if (str.integerValue == 1) {
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Male"];
            self.sexImage.tintColor = [UIColor blueColor];
        } else if (str.integerValue == 2) {
            self.sexImage.tintColor = [UIColor redColor];
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Female"];
        } else {
            self.sexImage.hidden = YES;
        }
    } else {
        self.sexImage.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string.boolValue) {
        self.vipImage.hidden = NO;
    } else {
        self.vipImage.hidden = YES;
    }
}

- (void)setDriverLevelWith:(NSString *)str {
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.driverLevelLabel.hidden = (string.length > 0) ? NO : YES;
    self.driverLevelLabel.text = [NSString stringWithFormat:@"老司机指数 :%@颗星",string];
    [self.driverLevelLabel sizeToFit];
    self.driverLevelLabel.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.nickNameLabel.frame) + self.nickNameLabel.frame.size.height);
}

- (void)setDescriptionWith:(NSString *)str {
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.descriptionLabel.hidden = (string.length > 0) ? NO : YES;
    self.descriptionLabel.text = [NSString stringWithFormat:@"简介 : %@ ",string];
    self.descriptionLabel.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 30);
    self.descriptionLabel.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.driverLevelLabel.frame) + self.driverLevelLabel.frame.size.height);
}

- (void)setAttentionWith:(NSString *)str {

//    [_model.present_user_uid isEqualToString:SSKEYCHAIN_UID] ? (self.attentionButton.hidden = YES) : (self.attentionButton.hidden = NO);
    self.attentionButton.hidden = [_model.present_user_uid isEqualToString:SSKEYCHAIN_UID];

    if (str.integerValue == 0) {
        [self.attentionButton setTitle:@"+关注" forState:(UIControlStateNormal)];
        [self.attentionButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.attentionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        [self.attentionButton setTitle:@"已关注" forState:(UIControlStateNormal)];
        [self.attentionButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        self.attentionButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

#pragma mark - getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.62 + 200)];
        _backgroundImageView.image = [UIImage imageNamed:@"New_mine_header"];
    }
    return _backgroundImageView;
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH / 5, kSCREEN_WIDTH / 5)];
        _iconImageView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.2);
        _iconImageView.layer.cornerRadius = kSCREEN_WIDTH / 10;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 3;
    }
    return _iconImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.hidden = YES;
    }
    return _nickNameLabel;
}

- (UIImageView *)sexImage {
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc] init];
        _sexImage.bounds = CGRectMake(0, 0, 15, 15) ;

    }
    return _sexImage;
}

- (UIImageView *)vipImage {
    if (!_vipImage) {
        _vipImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _vipImage.image = [UIImage imageNamed:@"Community_Vip"];
        _vipImage.hidden = YES;
    }
    return _vipImage;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:16];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.hidden = YES;
    }
    return _descriptionLabel;
}

- (UILabel *)driverLevelLabel {
    if (!_driverLevelLabel) {
        _driverLevelLabel = [[UILabel alloc] init];
        _driverLevelLabel.font = [UIFont boldSystemFontOfSize:16];
        _driverLevelLabel.textColor = [UIColor whiteColor];
        _driverLevelLabel.hidden = YES;
    }
    return _driverLevelLabel;
}

- (UIButton *)attentionButton {
    if (!_attentionButton) {
        _attentionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _attentionButton.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, self.iconImageView.center.y - 15, 60, 30);
        _attentionButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _attentionButton.layer.borderWidth = 1;
        _attentionButton.layer.cornerRadius = 4;
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _attentionButton.hidden = YES;
        [_attentionButton addTarget:self action:@selector(respondsToAttentionButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _attentionButton;
}


@end









