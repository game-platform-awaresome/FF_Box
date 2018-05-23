//
//  FFInviteListCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFInviteListCell.h"
#import "UIImageView+WebCache.h"
#import "SYKeychain.h"

@interface FFInviteListCell ()

@property (weak, nonatomic) IBOutlet UIButton *NumberButton;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (weak, nonatomic) IBOutlet UILabel *countsLabel;

@property (weak, nonatomic) IBOutlet UIButton *coinButton;

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@end

@implementation FFInviteListCell {
    NSString *__userName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.NumberButton.userInteractionEnabled = NO;
    self.coinButton.userInteractionEnabled = NO;

    self.sexImageView.hidden = YES;
    self.vipImageView.hidden = YES;
    self.remindLabel.hidden = YES;

    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2.f;
    self.iconImageView.layer.masksToBounds = YES;


    self.remindLabel.transform = CGAffineTransformMakeRotation(-M_PI_2 / 2);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;

    [self setNumber:dict[@"ranking"]];
    [self setUserName:dict[@"username"]];
    [self setVip:dict[@"vip"]];
    [self setCounts:dict[@"count"]];
    [self setCoin:dict[@"coin"]];
    [self setIcon:dict[@"icon_url"]];
    [self setUid:dict[@"uid"]];
    [self setGot:dict[@"got"]];
}

- (void)setNumber:(NSString *)string {
    NSString *ranking = [NSString stringWithFormat:@"%@",string];
    if (string.integerValue > 0) {
        [self.NumberButton setTitle:ranking forState:(UIControlStateNormal)];
    }
    UIImage *image;

    if (ranking.integerValue < 4) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"Invite_%@",string]];
    } else {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"Invite_other"]];
    }
    self.backGroundImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    self.backGroundImageView.image  = image;

    if (ranking.integerValue < 4) {
        self.backGroundImageView.center = CGPointMake(self.NumberButton.center.x, self.NumberButton.center.y + 5);
    } else {
        self.backGroundImageView.center = self.NumberButton.center;
    }

    [self.contentView bringSubviewToFront:self.NumberButton];
}

- (void)setUserName:(NSString *)userName {
    __userName = [NSString stringWithFormat:@"%@",userName];
    NSString *subName = [userName substringToIndex:3];
    self.userNameLabel.text = [NSString stringWithFormat:@"%@****",subName];
}

- (void)setSex:(NSString *)string {
    NSString *sex = [NSString stringWithFormat:@"%@",string];
    if (sex.integerValue == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"Community_Sex_Male"];
        self.sexImageView.hidden = NO;
    } else if (sex.integerValue == 2) {
        self.sexImageView.image = [UIImage imageNamed:@"Community_Sex_Female"];
        self.sexImageView.hidden = NO;
    } else {
        self.sexImageView.hidden = YES;
    }
}

- (void)setVip:(NSString *)string {
    NSString *vip = [NSString stringWithFormat:@"%@",string];
    self.vipImageView.hidden = !vip.boolValue;
}

- (void)setCounts:(NSString *)string {
    self.countsLabel.text = [NSString stringWithFormat:@"%@",string];
}

- (void)setCoin:(NSString *)string {
    [self.coinButton setTitle:[NSString stringWithFormat:@"%@",string] forState:(UIControlStateNormal)];
}

- (void)setIcon:(NSString *)string {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
}

- (void)setUid:(NSString *)string {
    NSString *uid = [NSString stringWithFormat:@"%@",string];

    if (self.gotModel == 1 && [uid isEqualToString:SSKEYCHAIN_UID]) {
        self.remindLabel.hidden = NO;
    } else {
        self.remindLabel.hidden = YES;
    }

    if ([uid isEqualToString:SSKEYCHAIN_UID]) {
        self.userNameLabel.text = __userName;
    } else {
        self.userNameLabel.text = self.userNameLabel.text;
    }
}

- (void)setGot:(NSString *)string {
    NSString *got = [NSString stringWithFormat:@"%@",string];
    if ([got isEqualToString:@"1"]) {
        self.remindLabel.text = @"已领取";
        self.remindLabel.textColor = [UIColor grayColor];
    } else {
        self.remindLabel.text = @"未领取";
        self.remindLabel.textColor = NAVGATION_BAR_COLOR;
    }
}




@end
