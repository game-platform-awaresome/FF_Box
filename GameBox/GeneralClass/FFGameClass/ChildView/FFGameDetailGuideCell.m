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


@interface FFGameDetailGuideCell ()

/** 游戏图标 */
@property (nonatomic, strong) UIImageView   *gameLogoImageView;
/** 置顶图片 */
@property (nonatomic, strong) UIImageView   *guideTopImageView;
/** 攻略标题 */
@property (nonatomic, strong) UILabel       *guideTitleLabel;


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
    self.gameLogoImageView = [UIImageView hyb_imageViewWithImage:CURRENT_GAME.game_logo_image superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
    }];

    self.guideTopImageView = [UIImageView hyb_imageViewWithImage:@"Game_guide_top" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];

    self.guideTitleLabel = [UILabel hyb_labelWithFont:14 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.guideTopImageView.mas_left).offset(-10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(20);
    }];








    [UIView hyb_addBottomLineToView:self.contentView leftPadding:10 rightPadding:0 height:0.5 color:[FFColorManager view_separa_line_color]];
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
}


#pragma mark - getter








@end
