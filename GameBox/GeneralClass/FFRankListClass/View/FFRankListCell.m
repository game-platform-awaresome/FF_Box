//
//  FFRankListCell.m
//  GameBox
//
//  Created by 燚 on 2018/8/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRankListCell.h"
#import "FFColorManager.h"
#import <UIImageView+WebCache.h>

@interface FFRankListCell()

/** right button */
@property (nonatomic, strong) UIButton      *rightButton;
/** game name label */
@property (nonatomic, strong) UILabel       *gameNameLabel;
/** game size label */
@property (nonatomic, strong) UILabel       *gameSizeLabel;
/** game type label */
@property (nonatomic, strong) UILabel       *gameTypeLabel;
/** game features label 0 */
@property (nonatomic, strong) UILabel       *gameFeaturesLabel0;
/** game features label 1 */
@property (nonatomic, strong) UILabel       *gameFeaturesLabel1;
/** game features label 2 */
@property (nonatomic, strong) UILabel       *gameFeaturesLabel2;
/** game description label */
@property (nonatomic, strong) UILabel       *gameDescriptionLabel;
/** game number backview */
@property (nonatomic, strong) UIImageView   *gameNumberBackView;
/** game number label */
@property (nonatomic, strong) UILabel       *gameNumberLabel;


/** bottom line */
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation FFRankListCell

#pragma mark - init method
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - view method
- (void)initUserInterface {
    CGFloat normalFont = 16;

    //game logo
    self.gameLogoImageView = [UIImageView hyb_imageViewWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    // right button
    self.rightButton = [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView).offset(-10);
    } touchUp:^(UIButton *sender) {
        [self respondsToRigthButton];
    }];

    // game number backview
    self.gameNumberBackView = [UIImageView hyb_imageViewWithImage:@"Ranklist_cell_number" superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 36));
    }];

    self.gameNumberLabel = [UILabel hyb_labelWithText:@"" font:15 superView:self.gameNumberBackView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameNumberBackView).offset(0);
        make.left.mas_equalTo(self.gameNumberBackView).offset(0);
        make.bottom.mas_equalTo(self.gameNumberBackView).offset(0);
        make.right.mas_equalTo(self.gameNumberBackView).offset(0);
    }];
    self.gameNumberLabel.textColor = [FFColorManager textColorMiddle];

    //game name label
    self.gameNameLabel = [UILabel hyb_labelWithFont:normalFont superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];

    //game size label
    self.gameSizeLabel = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.gameNameLabel.mas_bottom).offset(0);
//        make.left.mas_equalTo(self.gameNameLabel.mas_right).offset(4);
//        make.right.mas_lessThanOrEqualTo(self.gameNumberBackView.mas_left).offset(-5);
        //        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
        make.bottom.mas_equalTo(self.gameNameLabel.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.gameNameLabel.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).offset(-10);
        make.height.mas_equalTo(18);
    }];
    self.gameSizeLabel.text = @"独家";
    self.gameSizeLabel.textAlignment = NSTextAlignmentLeft;
    self.gameSizeLabel.font = [UIFont boldSystemFontOfSize:13];
    self.gameSizeLabel.layer.cornerRadius = 9;
    self.gameSizeLabel.layer.masksToBounds = YES;
    self.gameSizeLabel.layer.borderWidth = 0.5;

    //game type label
    self.gameTypeLabel = [UILabel hyb_labelWithFont:13 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.gameNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).offset(-10);
        //        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
    }];
    self.gameTypeLabel.textColor = [FFColorManager textColorMiddle];

    //game features label
    self.gameFeaturesLabel0 = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.gameNameLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(18);
    }];
    self.gameFeaturesLabel0.backgroundColor = [FFColorManager custom_cell_text1_color];
    [self setLabel:self.gameFeaturesLabel0];

    //
    self.gameFeaturesLabel1 = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameFeaturesLabel0.mas_right).offset(3);
        make.top.mas_equalTo(self.gameFeaturesLabel0.mas_top).offset(0);
        make.height.mas_equalTo(18);
    }];
    self.gameFeaturesLabel1.backgroundColor = [FFColorManager custom_cell_text2_color];
    [self setLabel:self.gameFeaturesLabel1];
    //

    self.gameFeaturesLabel2 = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameFeaturesLabel1.mas_right).offset(3);
        make.top.mas_equalTo(self.gameFeaturesLabel0.mas_top).offset(0);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(self.gameNumberBackView.mas_left).offset(-5);
        //        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
    }];
    self.gameFeaturesLabel2.backgroundColor = [FFColorManager custom_cell_text3_color];
    [self setLabel:self.gameFeaturesLabel2];

    //
    self.gameDescriptionLabel = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(0);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(self.gameNumberBackView.mas_left).offset(-5);
        //        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
    }];
    [self setLabel:self.gameDescriptionLabel];
    self.gameDescriptionLabel.font = [UIFont systemFontOfSize:11];
    self.gameDescriptionLabel.backgroundColor = kOrangeColor;



    [UIView hyb_addBottomLineToView:self.contentView leftPadding:0 rightPadding:0 height:1 color:[FFColorManager view_separa_line_color]];
}

- (void)setLabel:(UILabel *)label {
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [FFColorManager navigation_bar_white_color];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - responds
- (void)respondsToRigthButton {

}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    syLog(@"dict == %@",dict);
    //set game name label
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@",dict[@"gamename"] ?: @"游戏"];

    //set right button
    [self setRigthButtonImage:dict[@"gamelogo"]];

    //set game logo iamge view
    [self.gameLogoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,dict[@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];

    //set game size label
//    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@M",dict[@"size"] ?: @"0"];

    UIColor *rColor = RGBColor(236, 56, 37);
    UIColor *pColor = RGBColor(210, 0, 255);
    //set game size label
    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@",[dict[@"operate"] isEqualToString:@"1"] ? @"  独家  " : @"  联合  "];
    self.gameSizeLabel.textColor = [dict[@"operate"] isEqualToString:@"1"] ? rColor: pColor;
    self.gameSizeLabel.layer.borderColor = [dict[@"operate"] isEqualToString:@"1"] ? rColor.CGColor: pColor.CGColor;

    //set game type label
    self.gameTypeLabel.text = [NSString stringWithFormat:@"%@",dict[@"types"] ?: @""];

    //set game feature label
    NSString *labelString = dict[@"label"];
    NSArray<UILabel *> *labelArray = @[self.gameFeaturesLabel0,self.gameFeaturesLabel1,self.gameFeaturesLabel2];
    labelString = [labelString stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray *array = [labelString componentsSeparatedByString:@","];
    for (UILabel *label in labelArray) {
        label.text = @"";
    }
    int i = 0;
    for (NSString *obj in array) {
        if (i < labelArray.count) {
            labelArray[i].hidden = NO;
            labelArray[i].text = [NSString stringWithFormat:@"%@",obj];
            [labelArray[i] sizeToFit];
        } else {
            break;
        }
        i++;
    }
    for (; i < labelArray.count; i++) {
        labelArray[i].hidden = YES;
    }

    //set game deqcription label
    NSString *gameDescription = dict[@"content"];
    if ([gameDescription isKindOfClass:[NSString class]] && gameDescription.length > 0) {
        self.gameDescriptionLabel.text = [NSString stringWithFormat:@"%@",gameDescription];
    } else {
        self.gameDescriptionLabel.text = @"精品手游";
    }
}

- (void)setRigthButtonImage:(id)image {
    if ([image isKindOfClass:[NSString class]]) {
        [self.rightButton setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    } else if ([image isKindOfClass:[UIImage class]]) {
        [self.rightButton setImage:image forState:(UIControlStateNormal)];
    } else {
        [self.rightButton setImage:nil forState:(UIControlStateNormal)];
    }
}

- (void)setIdx:(NSInteger)idx {
    self.gameNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.gameNumberLabel.text = [NSString stringWithFormat:@"No.%ld",idx];
}

#pragma mark - getter





@end









