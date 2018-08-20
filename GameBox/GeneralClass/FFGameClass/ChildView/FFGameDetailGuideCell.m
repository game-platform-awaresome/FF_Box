//
//  FFGameGuideCell.m
//  GameBox
//
//  Created by 燚 on 2018/8/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailGuideCell.h"
#import "FFCurrentGameModel.h"
#import "FFColorManager.h"
#import "FFGameDetailGuideModel.h"


@interface FFGameDetailGuideCell ()

/** 游戏图标 */
@property (nonatomic, strong) UIImageView   *gameLogoImageView;
/** 置顶图片 */
@property (nonatomic, strong) UIImageView   *guideTopImageView;
/** 攻略标题 */
@property (nonatomic, strong) UILabel       *guideTitleLabel;
/** 攻略作者 */
@property (nonatomic, strong) UILabel       *guideAuthorLabel;
/** 时间 */
@property (nonatomic, strong) UILabel       *guideTimeLabel;


/** 阅读数 */
@property (nonatomic, strong) UIButton      *readNumberButton;
/** 点赞数 */
@property (nonatomic, strong) UIButton      *likeNumberButton;
/** 踩 */
@property (nonatomic, strong) UIButton      *dislikeNumberButton;
/** 分享 */
@property (nonatomic, strong) UIButton      *sharedNumberButton;



@end

@implementation FFGameDetailGuideCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    //游戏 logo
    self.gameLogoImageView = [UIImageView hyb_imageViewWithImage:CURRENT_GAME.game_logo_image superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
    }];

    //置顶图
    self.guideTopImageView = [UIImageView hyb_imageViewWithImage:@"Game_guide_top" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];

    //标题
    self.guideTitleLabel = [UILabel hyb_labelWithFont:14 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.guideTopImageView.mas_left).offset(-10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(20);
    }];

    //作者
    self.guideAuthorLabel = [UILabel hyb_labelWithFont:14 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.guideTopImageView.mas_left).offset(-10);
        make.top.mas_equalTo(self.guideTitleLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(20);
    }];
    self.guideAuthorLabel.textColor = [FFColorManager textColorDark];


    //时间
    self.guideTimeLabel = [UILabel hyb_labelWithFont:14 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.guideTopImageView.mas_left).offset(-10);
        make.top.mas_equalTo(self.guideAuthorLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(20);
    }];


    //阅读
    self.readNumberButton = [UIButton hyb_buttonWithImage:@"Game_guide_read" selectedImage:@"" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 4, 30));
    } touchUp:^(UIButton *sender) {

    }];
    [self setButton:self.readNumberButton];

    //赞数目
    self.likeNumberButton = [UIButton hyb_buttonWithImage:@"Drive_like" selectedImage:@"Drive_like_select" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.readNumberButton.mas_right).offset(0);
         make.size.mas_equalTo(CGSizeMake(kScreenWidth / 4, 30));
    } touchUp:^(UIButton *sender) {
        [self respondsToLikeButton];
    }];
    [self setButton:self.likeNumberButton];

    //踩数
    self.dislikeNumberButton = [UIButton hyb_buttonWithImage:@"Drive_unLike" selectedImage:@"Drive_unLike_select" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.likeNumberButton.mas_right).offset(0);
         make.size.mas_equalTo(CGSizeMake(kScreenWidth / 4, 30));
    } touchUp:^(UIButton *sender) {
        [self respondsToDislikeButton];
    }];
    [self setButton:self.dislikeNumberButton];

    //分享
    self.sharedNumberButton = [UIButton hyb_buttonWithImage:@"Drive_shared" selectedImage:@"" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.dislikeNumberButton.mas_right).offset(0);
         make.size.mas_equalTo(CGSizeMake(kScreenWidth / 4, 30));
    } touchUp:^(UIButton *sender) {
        [self respondsToSharedButton];
    }];
    [self setButton:self.sharedNumberButton];

    [UIView hyb_addBottomLineToView:self.contentView leftPadding:10 rightPadding:0 height:0.5 color:[FFColorManager view_separa_line_color]];
}

- (void)setButton:(UIButton *)button {
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[FFColorManager textColorMiddle] forState:(UIControlStateNormal)];
}


#pragma mark - responds
- (void)respondsToLikeButton {
    if (GuideDetailModel.likeButton) {
        GuideDetailModel.likeButton(self.dict, self.indexPath);
    }
}

- (void)respondsToDislikeButton {
    if (GuideDetailModel.dislikeButton) {
        GuideDetailModel.dislikeButton(self.dict, self.indexPath);
    }
}

- (void)respondsToSharedButton {
    if (GuideDetailModel.sharedBuntton) {
        GuideDetailModel.sharedBuntton(self.dict, self.indexPath);
    }
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    //设置logo
    self.gameLogoImageView.image = CURRENT_GAME.game_logo_image;
    //设置标题
    self.guideTitleLabel.text = [NSString stringWithFormat:@"%@",dict[@"title"] ?: CURRENT_GAME.game_name];
    //设置置顶
    self.guideTopImageView.hidden = !([NSString stringWithFormat:@"%@",dict[@"is_top"]].boolValue);
    //设置作者
    self.guideAuthorLabel.text = [NSString stringWithFormat:@"%@",dict[@"author"] ?: CURRENT_GAME.game_name];
    //设置时间
    self.guideTimeLabel.text = [NSString stringWithFormat:@"%@",dict[@"release_time"] ?: @""];

    //阅读数
    [self.readNumberButton setTitle:[NSString stringWithFormat:@" %@",dict[@"view_counts"] ?: @"0"] forState:(UIControlStateNormal)];
    //赞数
    [self.likeNumberButton setTitle:[NSString stringWithFormat:@" %@",dict[@"likes"] ?: @"0"] forState:(UIControlStateNormal)];
    //踩数
    [self.dislikeNumberButton setTitle:[NSString stringWithFormat:@" %@",dict[@"dislikes"] ?: @"0"] forState:(UIControlStateNormal)];
    //分享数
    [self.sharedNumberButton setTitle:[NSString stringWithFormat:@" %@",dict[@"shares"] ?: @"0"] forState:(UIControlStateNormal)];

    //设置是否赞踩
    NSString *likeType = [NSString stringWithFormat:@"%@",dict[@"like_type"] ?: @"0"];
    if (likeType.integerValue == 0) {
        self.likeNumberButton.selected = NO;
        self.dislikeNumberButton.selected = YES;
        self.likeNumberButton.userInteractionEnabled = NO;
        self.dislikeNumberButton.userInteractionEnabled = NO;
    } else if (likeType.integerValue == 1) {
        self.likeNumberButton.selected = YES;
        self.dislikeNumberButton.selected = NO;
        self.likeNumberButton.userInteractionEnabled = NO;
        self.dislikeNumberButton.userInteractionEnabled = NO;
    } else if (likeType.integerValue == 2) {
        self.likeNumberButton.selected = NO;
        self.dislikeNumberButton.selected = NO;
        self.likeNumberButton.userInteractionEnabled = YES;
        self.dislikeNumberButton.userInteractionEnabled = YES;
    }
}


#pragma mark - getter








@end
