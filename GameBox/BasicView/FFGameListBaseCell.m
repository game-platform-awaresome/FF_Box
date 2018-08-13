//
//  FFGameListBaseCell.m
//  GameBox
//
//  Created by 燚 on 2018/8/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameListBaseCell.h"
#import <Masonry.h>
#import "HYBHelperMasonryMaker.h"
#import "FFColorManager.h"

@interface FFGameListBaseCell()

/** right button */
@property (nonatomic, strong) UIButton *rightButton;
/** game name label */
@property (nonatomic, strong) UILabel *gameNameLabel;
/** game size label */
@property (nonatomic, strong) UILabel *gameSizeLabel;



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

    self.gameLogoImageView = [UIImageView hyb_imageViewWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];

    self.rightButton = [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    } touchUp:^(UIButton *sender) {
        [self respondsToRigthButton];
    }];

    self.gameNameLabel = [UILabel hyb_labelWithFont:16 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];

    self.gameSizeLabel = [UILabel hyb_labelWithFont:12 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.gameNameLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.rightButton.mas_left).offset(-4);
        make.left.mas_equalTo(self.gameNameLabel.mas_right).offset(4);
    }];
    self.gameSizeLabel.textAlignment = NSTextAlignmentLeft;
    self.gameSizeLabel.textColor = [FFColorManager textColorLight];



    [UIView hyb_addBottomLineToView:self.contentView leftPadding:10 rightPadding:0 height:1 color:[FFColorManager view_separa_line_color]];
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

    //set game size label
    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@M",dict[@"size"] ?: @"0"];

    //标签1
//    NSString *labelString = dict[@"label"];
//    NSArray<UILabel *> *labelArray = @[self.label1,self.label2,self.label3];
//    labelString = [labelString stringByReplacingOccurrencesOfString:@"，" withString:@","];
//    NSArray *array = [labelString componentsSeparatedByString:@","];
//    for (UILabel *label in labelArray) {
//        label.text = @"";
//    }
//    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (idx < 3) {
//            labelArray[idx].text = [NSString stringWithFormat:@" %@ ",obj];
//        }
//    }];


//    NSString *content = dict[@"content"];
//    self.gameNumber.text = [NSString stringWithFormat:@"%@",content];
//    self.gameNumber.textAlignment = NSTextAlignmentLeft;

//    //折扣
//    NSString *discount = dict[@"discount"];
//    if (discount && discount.integerValue > 0) {
//        [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"Home_cell_ZK"] forState:(UIControlStateNormal)];
//        self.zkLabel.hidden = NO;
//        self.zkLabel.text = [NSString stringWithFormat:@" %.1f折 ",discount.floatValue];
//        self.zkLabel.layer.cornerRadius = self.zkLabel.bounds.size.height / 2;
//        self.zkLabel.layer.masksToBounds = YES;
//    } else {
//        [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"Home_cell_BT"] forState:(UIControlStateNormal)];
//        self.zkLabel.hidden = YES;
//    }

//    //预约时间
//    if (dict[@"newgame_time"]) {
//        self.gameDownload.hidden = [[NSString stringWithFormat:@"%@",dict[@"newgame_time"]] isEqualToString:@"0"];
//    }
//
//    //设置预约按钮图标
//    if (dict[@"is_reserved"]) {
//        [self setBetaGameImage:[NSString stringWithFormat:@"%@",dict[@"is_reserved"]]];
//    }
//
//    if (dict[@"downloadImage"]) {
//        [self setDownloadImage:dict[@"downloadImage"]];
//    }
//
//    if (dict[@"rank"]) {
//        [self setRankString:dict[@"rank"]];
//    }
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












