//
//  SearchCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFCustomizeCell.h"
#import <UIImageView+WebCache.h>
#import "FFColorManager.h"


#warning missing model


@interface FFCustomizeCell ()

/** 分割线 */
@property (weak, nonatomic) IBOutlet UIView *SeparaLine;

/** 游戏名称 */
@property (weak, nonatomic) IBOutlet UILabel *gameName;
/** 下载次数 */
@property (weak, nonatomic) IBOutlet UILabel *gameNumber;
/** 下载游戏 */
@property (weak, nonatomic) IBOutlet UIButton *gameDownload;
/** 游戏大小 */
@property (weak, nonatomic) IBOutlet UILabel *gameSize;
/** 标签1 */
@property (weak, nonatomic) IBOutlet UILabel *label1;
/** 标签2 */
@property (weak, nonatomic) IBOutlet UILabel *label2;
/** 标签3 */
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UILabel *zkLabel;


@property (strong, nonatomic) UILabel *rankLabel;


//约束布局
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lefLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigthLayout;

@end

@implementation FFCustomizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.gameDownload.userInteractionEnabled = NO;

    [self setLabel:self.label1 BackgroundColor:[FFColorManager custom_cell_text1_color]];
    [self setLabel:self.label2 BackgroundColor:[FFColorManager custom_cell_text2_color]];
    [self setLabel:self.label3 BackgroundColor:[FFColorManager custom_cell_text3_color]];

    self.gameNumber.font = [UIFont systemFontOfSize:12];
    self.gameNumber.textColor = [UIColor lightGrayColor];

    //414  375  320
    if (kSCREEN_WIDTH == 320) {
        _lefLayout.constant = 8;
        _rigthLayout.constant = 8;
        self.gameName.font = [UIFont systemFontOfSize:13];
        [self.gameName sizeToFit];
        self.gameSize.font = [UIFont systemFontOfSize:12];
        self.gameSize.textColor = [UIColor lightGrayColor];
    } else if (kSCREEN_WIDTH == 375) {
        _lefLayout.constant = 8;
        _rigthLayout.constant = 8;
        self.gameName.font = [UIFont systemFontOfSize:14];
        [self.gameName sizeToFit];
        self.gameSize.font = [UIFont systemFontOfSize:13];
        self.gameSize.textColor = [UIColor lightGrayColor];
    } else if (kSCREEN_WIDTH == 414) {
        _lefLayout.constant = 8;
        _rigthLayout.constant = 8;
        self.gameName.font = [UIFont systemFontOfSize:16];
        [self.gameName sizeToFit];
        self.gameSize.font = [UIFont systemFontOfSize:15];
        self.gameSize.textColor = [UIColor lightGrayColor];
    }

    self.SeparaLine.backgroundColor = [FFColorManager view_separa_line_color];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)setLabel:(UILabel *)label BackgroundColor:(UIColor *)backgroundColor {
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = @"";
    label.backgroundColor = backgroundColor;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    [label sizeToFit];
    CGRect bounds = label.bounds;
    bounds.size.width += 1;
    bounds.size.height += 1;
    label.bounds = bounds;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
//    syLog(@"game cell dict === %@",dict);
    //设置名称
    self.gameName.text = _dict[@"gamename"];
    //游戏大小
    if (dict[@"size"]) {
        self.gameSize.hidden = NO;
        self.gameSize.text = [NSString stringWithFormat:@"%@M",_dict[@"size"]];
    } else {
        self.gameSize.hidden = YES;
    }
    //标签1
    NSString *labelString = dict[@"label"];
    NSArray<UILabel *> *labelArray = @[self.label1,self.label2,self.label3];
    labelString = [labelString stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray *array = [labelString componentsSeparatedByString:@","];
    for (UILabel *label in labelArray) {
        label.text = @"";
    }
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 3) {
            labelArray[idx].text = [NSString stringWithFormat:@" %@ ",obj];
        }
    }];

    [self.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,dict[@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];

    //下载次数
    //    NSInteger dlNumber = ((NSString *)_dict[@"download"]).integerValue;
    //    if (dlNumber > 10000) {
    //        dlNumber = dlNumber / 10000;
    //        self.gameNumber.text = [NSString stringWithFormat:@"%ld万+次下载",dlNumber];
    //    } else {
    //        self.gameNumber.text = [NSString stringWithFormat:@"%ld次下载",dlNumber];
    //    }
    NSString *content = dict[@"content"];
    self.gameNumber.text = [NSString stringWithFormat:@"%@",content];
    self.gameNumber.textAlignment = NSTextAlignmentLeft;

    //折扣
    NSString *discount = dict[@"discount"];
    if (discount && discount.integerValue > 0) {
        [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"Home_cell_ZK"] forState:(UIControlStateNormal)];
        self.zkLabel.hidden = NO;
        self.zkLabel.text = [NSString stringWithFormat:@" %.1f折 ",discount.floatValue];
        self.zkLabel.layer.cornerRadius = self.zkLabel.bounds.size.height / 2;
        self.zkLabel.layer.masksToBounds = YES;
    } else {
        [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"Home_cell_BT"] forState:(UIControlStateNormal)];
        self.zkLabel.hidden = YES;
    }

    //预约时间
    if (dict[@"newgame_time"]) {
        self.gameDownload.hidden = [[NSString stringWithFormat:@"%@",dict[@"newgame_time"]] isEqualToString:@"0"];
    }

    //设置预约按钮图标
    if (dict[@"is_reserved"]) {
        [self setBetaGameImage:[NSString stringWithFormat:@"%@",dict[@"is_reserved"]]];
    }
    
    if (dict[@"downloadImage"]) {
        [self setDownloadImage:dict[@"downloadImage"]];
    }
    
    if (dict[@"rank"]) {
        [self setRankString:dict[@"rank"]];
    }
}

- (void)setBetaGameImage:(NSString *)string {
    self.zkLabel.hidden = YES;
    self.gameDownload.userInteractionEnabled = YES;
    [self.gameDownload setBackgroundImage:nil forState:(UIControlStateNormal)];
    if (string.integerValue == 0) {
        [self.gameDownload setImage:[UIImage imageNamed:@"Reservation_reservation"] forState:(UIControlStateNormal)];
    } else {
        [self.gameDownload setImage:[UIImage imageNamed:@"Reservation_cancel"] forState:(UIControlStateNormal)];
    }
}

- (void)setBetaGame:(NSString *)betaGame {
    self.zkLabel.hidden = YES;
    self.gameDownload.userInteractionEnabled = YES;
//    [self.gameDownload setBackgroundImage:nil forState:(UIControlStateNormal)];
//    [self.gameDownload setImage:[UIImage imageNamed:betaGame] forState:(UIControlStateNormal)];
}

- (void)setReservationGame:(NSString *)ReservationGame {
    self.zkLabel.hidden = YES;
//    [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"Home_cell_BT"] forState:(UIControlStateNormal)];
}


- (IBAction)downLoad:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFCustomizeCell:didSelectCellRowAtIndexPathWith:)]) {
        [self.delegate FFCustomizeCell:self didSelectCellRowAtIndexPathWith:self.dict];
    }
}

- (void)setIsH5Game:(BOOL)isH5Game {
    _isH5Game = isH5Game;
    [self.gameDownload setBackgroundImage:nil forState:(UIControlStateNormal)];
    [self.gameDownload setImage:[UIImage imageNamed:@"Game_H5_Start_game"] forState:(UIControlStateNormal)];
}

- (void)setDownloadImage:(NSString *)imageString {
    if (imageString) {
        [self.gameDownload setBackgroundImage:nil forState:(UIControlStateNormal)];
        [self.gameDownload setImage:[UIImage imageNamed:imageString] forState:(UIControlStateNormal)];
        self.rankLabel.text = self.dict[@"rank"];
//        [self.rankLabel sizeToFit];
        [self.rankLabel sizeToFit];
        if (self.rankLabel.text.integerValue < 4) {
            self.rankLabel.center = CGPointMake(self.gameDownload.bounds.size.width / 2, self.gameDownload.bounds.size.height / 2 - 4);
        } else {
            self.rankLabel.center = CGPointMake(self.gameDownload.bounds.size.width / 2, self.gameDownload.bounds.size.height / 2);
        }
        [self.gameDownload addSubview:self.rankLabel];
    }
}

- (void)setRankString:(NSString *)string {
    if (string) {
        self.rankLabel.text = string;
        [self.rankLabel sizeToFit];
    } else {
        [self.rankLabel removeFromSuperview];
    }
}


#pragma mark - getter
- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = [UIColor whiteColor];
        _rankLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _rankLabel;
}





@end
