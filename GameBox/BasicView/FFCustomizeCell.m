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


@interface FFCustomizeCell ()

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

    [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"New_cell_returnButton"] forState:(UIControlStateNormal)];

    //414  375  320
    if (kSCREEN_WIDTH == 320) {
        _lefLayout.constant = 8;
        _rigthLayout.constant = 8;
        self.gameName.font = [UIFont systemFontOfSize:13];
        [self.gameName sizeToFit];
        self.gameSize.font = [UIFont systemFontOfSize:13];
        self.gameSize.textColor = [UIColor lightGrayColor];
    } else if (kSCREEN_WIDTH == 375) {
        _lefLayout.constant = 20;
        _rigthLayout.constant = 20;
        self.gameName.font = [UIFont systemFontOfSize:14];
        [self.gameName sizeToFit];
        self.gameSize.font = [UIFont systemFontOfSize:14];
        self.gameSize.textColor = [UIColor lightGrayColor];
    } else if (kSCREEN_WIDTH == 414) {
        _lefLayout.constant = 30;
        _rigthLayout.constant = 30;
        self.gameName.font = [UIFont systemFontOfSize:16];
        [self.gameName sizeToFit];
        self.gameSize.font = [UIFont systemFontOfSize:16];
        self.gameSize.textColor = [UIColor lightGrayColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)setLabel:(UILabel *)label BackgroundColor:(UIColor *)backgroundColor {
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = @"";
//    label.backgroundColor = backgroundColor;
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
    self.gameSize.text = [NSString stringWithFormat:@"%@M",_dict[@"size"]];
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
            labelArray[idx].text = obj;
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
}


- (IBAction)downLoad:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFCustomizeCell:didSelectCellRowAtIndexPathWith:)]) {
        [self.delegate FFCustomizeCell:self didSelectCellRowAtIndexPathWith:self.dict];
    }
}







@end
