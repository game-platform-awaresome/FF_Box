//
//  FFGameListBaseCell.m
//  GameBox
//
//  Created by 燚 on 2018/8/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameListBaseCell.h"
#import "FFColorManager.h"

@interface FFGameListBaseCell()

/** right button */
@property (nonatomic, strong) UIButton  *rightButton;
/** game name label */
@property (nonatomic, strong) UILabel   *gameNameLabel;
/** game size label */
@property (nonatomic, strong) UILabel   *gameSizeLabel;
/** game type label */
@property (nonatomic, strong) UILabel   *gameTypeLabel;
/** game features label 0 */
@property (nonatomic, strong) UILabel   *gameFeaturesLabel0;
/** game features label 1 */
@property (nonatomic, strong) UILabel   *gameFeaturesLabel1;
/** game features label 2 */
@property (nonatomic, strong) UILabel   *gameFeaturesLabel2;
/** game description label */
@property (nonatomic, strong) UILabel   *gameDescriptionLabel;
/** game first label */
@property (nonatomic, strong) UILabel   *gameFirstLabel;


/** bottom line */
@property (nonatomic, strong) UIView *bottomLine;

@end



@implementation FFGameListBaseCell

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

+ (BOOL)registCellToTabelView:(UITableView *)tableView {
    return [self registCellToTabelView:tableView WithIdentifier:GamelistBaseCellIDE];
}

+ (BOOL)registCellToTabelView:(UITableView *)tableView WithIdentifier:(NSString *)Identifier {
    if (tableView && Identifier.length) {
        [tableView registerClass:[FFGameListBaseCell class] forCellReuseIdentifier:Identifier];
        return YES;
    }
    return NO;
}

+ (FFGameListBaseCell *)cellRegistWithTableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:GamelistBaseCellIDE];
}
+ (FFGameListBaseCell *)cellRegistWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:GamelistBaseCellIDE forIndexPath:indexPath];
}

#pragma mark - view method
- (void)initUserInterface {
    CGFloat normalFont = 16;

    //game logo
    self.gameLogoImageView = [UIImageView hyb_imageViewWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];

    // right button
    self.rightButton = [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView).offset(-10);
    } touchUp:^(UIButton *sender) {
        [self respondsToRigthButton];
    }];

    //game name label
    self.gameNameLabel = [UILabel hyb_labelWithFont:normalFont superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];

    //game size label
    self.gameSizeLabel = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.gameNameLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.gameNameLabel.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).offset(-10);
        make.height.mas_equalTo(18);
        //        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
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

    //game first label
    self.gameFirstLabel = [UILabel hyb_labelWithText:@"今日首发" font:14 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameTypeLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.gameTypeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(66, 18));
//        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).offset(-10);
    }];
//    UIColor *color = kRedColor;
    UIColor *color = RGBColor(210, 0, 255);
    self.gameFirstLabel.textColor = color;
    self.gameFirstLabel.layer.cornerRadius = 4;
    self.gameFirstLabel.layer.masksToBounds = YES;
    self.gameFirstLabel.layer.borderWidth = 1;
    self.gameFirstLabel.layer.borderColor = color.CGColor;
    self.gameFirstLabel.textAlignment = NSTextAlignmentCenter;
    self.gameFirstLabel.hidden = YES;

    //game features label
    self.gameFeaturesLabel0 = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.gameTypeLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(18);
    }];
    self.gameFeaturesLabel0.backgroundColor = [FFColorManager custom_cell_text1_color];
    [self setLabel:self.gameFeaturesLabel0];

    //
    self.gameFeaturesLabel1 = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameFeaturesLabel0.mas_right).offset(3);
        make.top.mas_equalTo(self.gameTypeLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(18);
    }];
    self.gameFeaturesLabel1.backgroundColor = [FFColorManager custom_cell_text2_color];
    [self setLabel:self.gameFeaturesLabel1];
    //

    self.gameFeaturesLabel2 = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameFeaturesLabel1.mas_right).offset(3);
        make.top.mas_equalTo(self.gameTypeLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).offset(-10);
        //        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
    }];
    self.gameFeaturesLabel2.backgroundColor = [FFColorManager custom_cell_text3_color];
    [self setLabel:self.gameFeaturesLabel2];

    //
    self.gameDescriptionLabel = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(0);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(self.rightButton.mas_left).offset(-10);
//        make.right.mas_lessThanOrEqualTo(self.contentView).offset(-60);
    }];
    [self setLabel:self.gameDescriptionLabel];
    self.gameDescriptionLabel.font = [UIFont systemFontOfSize:11];
    self.gameDescriptionLabel.backgroundColor = kOrangeColor;



    [UIView hyb_addBottomLineToView:self.contentView leftPadding:10 rightPadding:0 height:1 color:[FFColorManager view_separa_line_color]];
}

- (void)setLabel:(UILabel *)label {
    label.layer.cornerRadius = 4;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [FFColorManager navigation_bar_white_color];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

    UIColor *rColor = RGBColor(236, 56, 37);
    UIColor *pColor = RGBColor(210, 0, 255);
    //set game size label
    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@",[dict[@"operate"] isEqualToString:@"1"] ? @"  独家  " : @"  联合  "];
    self.gameSizeLabel.textColor = [dict[@"operate"] isEqualToString:@"1"] ? rColor: pColor;
    self.gameSizeLabel.layer.borderColor = [dict[@"operate"] isEqualToString:@"1"] ? rColor.CGColor: pColor.CGColor;

    //set game first
    self.gameFirstLabel.hidden = ![NSString stringWithFormat:@"%@",dict[@"first"] ?: @"0"].boolValue;

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

#pragma mark - getter






@end












