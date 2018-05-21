//
//  GiftBagCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFpackageCell.h"
#import "FFColorManager.h"
#import <UIImageView+WebCache.h>

@interface FFpackageCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation FFpackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.getBtn addTarget:self action:@selector(clickGetBtn) forControlEvents:(UIControlEventTouchUpInside)];
    self.getBtn.layer.cornerRadius = self.getBtn.bounds.size.height / 2;
    self.getBtn.layer.masksToBounds = YES;
}

- (void)clickGetBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFpackageCell:select:)]) {
        [self.delegate FFpackageCell:self select:_currentIdx];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    //礼包名称
    self.name.text = _dict[@"pack_name"];
    //礼包数量
    NSString *total = _dict[@"pack_counts"];
    NSString *current = _dict[@"pack_used_counts"];
    NSUInteger lastNumber = total.integerValue - current.integerValue;

    self.contentLabel.text = [NSString stringWithFormat:@" : %@    剩余 : %lu",total,lastNumber];

    //礼包logo
    [self.gameLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,dict[@"pack_logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];

    NSString *str = _dict[@"card"];
    if ([str isKindOfClass:[NSNull class]] || str == nil) {
        [self.getBtn setTitle:@"领取" forState:(UIControlStateNormal)];
        [self.getBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.getBtn setBackgroundColor:[FFColorManager blue_dark]];
    } else {
        [self.getBtn setTitle:@"复制" forState:(UIControlStateNormal)];
        [self.getBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.getBtn setBackgroundColor:[FFColorManager light_gray_color]];
    }
}






@end
