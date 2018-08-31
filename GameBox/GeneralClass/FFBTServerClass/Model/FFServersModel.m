//
//  FFServersModel.m
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFServersModel.h"


@implementation FFTopGameModel

+ (instancetype)setTopModelWithDictionary:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        FFTopGameModel *model = [[FFTopGameModel alloc] init];
        model.gameArray = dict[@"game"];
        model.gameSlide = dict[@"slide"];
        model.sectionFooterHeight = 0;
        return model;
    } else {
        return nil;
    }
}

- (void)setGameArray:(NSArray *)gameArray {
    _gameArray = ([gameArray isKindOfClass:[NSArray class]]) ? [gameArray mutableCopy] : [NSMutableArray array];
}

- (void)setGameSlide:(NSDictionary *)gameSlide {
    if ([gameSlide isKindOfClass:[NSDictionary class]]) {
        _gameSlide = gameSlide;
    } else {
        _gameSlide = @{};
    }

    self.slideGid = _gameSlide[@"gid"];
    self.slidePic = _gameSlide[@"pic"];
    self.slideUrl = _gameSlide[@"url"];
}

- (void)setSlideGid:(NSString *)slideGid {
    _slideGid = [NSString stringWithFormat:@"%@",slideGid];
}

- (void)setSlidePic:(NSString *)slidePic {
    if ([slidePic isKindOfClass:[NSString class]]) {
        _slidePic = [NSString stringWithFormat:@"%@",slidePic];
        _sectionFooterHeight = @"200";
    } else {
        _slidePic = nil;
        _sectionFooterHeight = @"0";
    }
}

- (void)setSlideUrl:(NSString *)slideUrl {
    if ([slideUrl isKindOfClass:[NSString class]]) {
        _slideUrl = [NSString stringWithFormat:@"%@",slideUrl];
    } else {
        _slideUrl = @"";
    }
}

- (void)setType:(FFSectionType)type {
    _type = type;
    switch (type) {
        case SectionOfBoutique:         self.sectionHeaderTitle = @"精品推荐";    break;
        case SectionOfNewArrival:       self.sectionHeaderTitle = @"新品上架";    break;
        case SectionOfPopulayWeekly:    self.sectionHeaderTitle = @"每周热门";    break;
        case SectionOfRecommentGame:    self.sectionHeaderTitle = @"游戏列表";    break;
        default:
            break;
    }
}

@end


@implementation FFServersModel

- (void)setContentDataDict:(NSDictionary *)contentDataDict {
    self.sectionArray = nil;
    if ([contentDataDict isKindOfClass:[NSDictionary class]]) {
        _contentDataDict = contentDataDict;
        [self setModelWithDictionary:_contentDataDict];
    } else {
        _contentDataDict = nil;
    }
}

- (void)setModelWithDictionary:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        [self setBoutiqueTop:dict[@"finetop"]];
        [self setNewTop:dict[@"newtop"]];
        [self setWeeklyTop:dict[@"weektop"]];
        [self setRecomment:dict[@"gamelist"]];

        self.bannerArray = dict[@"banner"];
    } else {
        syLog(@"%s error : dict == nil",__func__);
    }
}


- (void)setBannerArray:(NSArray *)bannerArray {
    [bannerArray isKindOfClass:[NSArray class]] ? (_bannerArray = bannerArray) : (bannerArray = nil);
}

- (void)setBoutiqueTop:(NSDictionary *)dict {
    if ((self.gameBoutiqueTop = [FFTopGameModel setTopModelWithDictionary:dict])) {
        self.gameBoutiqueTop.type = SectionOfBoutique;
        if (self.gameBoutiqueTop.gameArray.count > 0) {
            [self.sectionArray addObject:self.gameBoutiqueTop];
        }
    }
}

- (void)setNewTop:(NSDictionary *)dict {
    if ((self.gameNewTop = [FFTopGameModel setTopModelWithDictionary:dict])) {
        self.gameNewTop.type = SectionOfNewArrival;
        if (self.gameNewTop.gameArray.count > 0) {
            [self.sectionArray addObject:self.gameNewTop];
        }
    }
}

- (void)setWeeklyTop:(NSDictionary *)dict {
    if ((self.gameWeeklyTop = [FFTopGameModel setTopModelWithDictionary:dict])) {
        self.gameWeeklyTop.type = SectionOfPopulayWeekly;
        if (self.gameWeeklyTop.gameArray.count > 0) {
            [self.sectionArray addObject:self.gameWeeklyTop];
        }
    }
}

- (void)setRecomment:(id)dict {
    NSDictionary *redict = nil;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        redict = dict;
    } else if ([dict isKindOfClass:[NSArray class]]) {
        redict = @{@"game":dict};
    }
    if ((self.gameRecomment = [FFTopGameModel setTopModelWithDictionary:redict])) {
        self.gameRecomment.type = SectionOfRecommentGame;
        if (self.gameRecomment.gameArray.count > 0) {
            [self.sectionArray addObject:self.gameRecomment];
        }
    }
}

- (NSMutableArray<FFTopGameModel *> *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}


@end










