//
//  FFGameDetailSectionModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailSectionModel.h"
#import "FFCurrentGameModel.h"

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
            syLog(@"sdlakfjaslkj === %@",CURRENT_GAME.game_vip_amount);
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


- (float)normalHeight {
    return 100;
}

- (float)openUpHeight {
    return 200;
}











@end
