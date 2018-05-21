//
//  FFGameDetailSectionModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailSectionModel.h"
#import "FFCurrentGameModel.h"
#import "FFColorManager.h"

@implementation FFGameDetailSectionModel

+ (instancetype)initWithType:(SecTionType)type {
    FFGameDetailSectionModel *model = [[FFGameDetailSectionModel alloc] init];
    model.sectionType = type;
    model.openUp = NO;
    return model;
}


#pragma makr - setter
- (void)setSectionType:(SecTionType)sectionType {
    _sectionType = sectionType;
    self.sectionItemNumber = 1;
    switch (_sectionType) {
        case SecTionTypeGameIntroduction:
            self.sectionHeaderTitle = @"游戏简介";
            self.contentString = CURRENT_GAME.game_introduction;
            break;
        case SecTionTypeFeature:
            self.sectionHeaderTitle = @"游戏特征";
            self.contentString = CURRENT_GAME.game_feature;
            break;
        case SecTionTypeActivity:
            self.sectionHeaderTitle = @"独家活动";
            self.contentString = CURRENT_GAME.game_version;
            break;
        case SecTionTypeGif:
            self.sectionHeaderTitle = @"精彩时刻";
            self.contentString = CURRENT_GAME.gif_url;
            break;
        case SecTionTypeVip:
            self.sectionHeaderTitle = @"VIP 价格";
            self.contentString = CURRENT_GAME.game_vip_amount;
            break;
        case SecTionTypeLike:
            self.sectionHeaderTitle = @"猜你喜欢";
            self.contentString = CURRENT_GAME.gif_url;
            break;
        default:
            break;
    }
}

- (void)refreshDataWith:(SecTionType)type {
    self.sectionType = type;
}

- (void)setOpenUp:(BOOL)openUp {
    _openUp = openUp;
    self.sectionFooterTitle = openUp ? @"收起" :@"展开";
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    _openUpHeight = [self heightForString:contentString] + 10.f;
}

- (CGFloat)normalHeight {
    return 100;
}

- (CGFloat)openUpHeight {
    return (_openUpHeight < 100) ? 100.f : _openUpHeight;
}



#pragma mark - other
/** 计算字符串需要的尺寸 */
- (CGSize)sizeForString:(NSString *)string Width:(CGFloat)width Height:(CGFloat)height {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, height)
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return retSize;
}

- (CGFloat)heightForString:(NSString *)string {
    return [self sizeForString:string Width:kSCREEN_WIDTH Height:MAXFLOAT].height;
}


- (UIView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];

        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);
        layer.backgroundColor = [FFColorManager light_gray_color].CGColor;
        [_sectionHeaderView.layer addSublayer:layer];

        CALayer *layer2 = [[CALayer alloc] init];
        layer2.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 1);
        layer2.backgroundColor = [FFColorManager light_gray_color].CGColor;
        [_sectionHeaderView.layer addSublayer:layer2];
    }
    return _sectionHeaderView;
}





@end
