//
//  FFQuestionGameHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/9/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFQuestionGameHeaderView.h"
#import "FFColorManager.h"

@interface FFQuestionGameHeaderView ()

@property (nonatomic, strong) UIImageView   *gameLogoImageView;
@property (nonatomic, strong) UILabel       *gameNameLabel;
@property (nonatomic, strong) UILabel       *gamePlayerLabel;
@property (nonatomic, strong) UILabel       *gameQuestionLabel;


@end

@implementation FFQuestionGameHeaderView

+ (instancetype)QuestionHeader {
    return [FFQuestionGameHeaderView new];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, fScreenWidth, 80);
    self.backgroundColor = fWhiteColor;

    //game logo
    self.gameLogoImageView = [UIImageView ff_imageViewWithImage:nil superView:self onstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(10);
        make.top.mas_equalTo(self).mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    self.gameLogoImageView.backgroundColor = kBlueColor;
    self.gameLogoImageView.layer.cornerRadius = 8;
    self.gameLogoImageView.layer.masksToBounds = YES;

    //game name
    self.gameNameLabel = [UILabel ff_labelWithFont:15 superView:self constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.gameLogoImageView.mas_top).offset(0);
        make.height.mas_equalTo(20);
        make.right.mas_greaterThanOrEqualTo(self).mas_offset(-10);
    }];
    self.gameNameLabel.text = @"游戏名称";
    self.gameNameLabel.textColor = [FFColorManager textColorDark];
//    self.gameNameLabel.backgroundColor = kOrangeColor;

    //game player number
    self.gamePlayerLabel = [UILabel ff_labelWithFont:12 superView:self constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.gameNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
        make.right.mas_greaterThanOrEqualTo(self).mas_offset(-10);
    }];
    self.gamePlayerLabel.text = @"共有23333个人玩过";
    self.gamePlayerLabel.textColor = [FFColorManager textColorMiddle];
//    self.gamePlayerLabel.backgroundColor = kOrangeColor;

    //game question number
    self.gameQuestionLabel = [UILabel ff_labelWithFont:12 superView:self constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.gamePlayerLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(15);
        make.right.mas_greaterThanOrEqualTo(self).mas_offset(-10);
    }];
    self.gameQuestionLabel.text = @"共有300个问题,收到10086个回答";
    self.gameQuestionLabel.textColor = [FFColorManager textColorMiddle];
//    self.gameQuestionLabel.backgroundColor = kOrangeColor;



    [UIView ff_addBottomLineToView:self Height:2 Color:[FFColorManager view_separa_line_color]];

}






@end




