//
//  FFServersModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SectionOfBoutique,      //精品推荐
    SectionOfNewArrival,    //新品上架
    SectionOfPopulayWeekly, //每周热门
    SectionOfRecommentGame  //推荐游戏
} FFSectionType;


@interface FFTopGameModel : NSObject

@property (nonatomic, assign) FFSectionType type;

@property (nonatomic, strong) NSString *sectionHeaderTitle;     //标题
@property (nonatomic, strong) NSString *sectionFooterPic;       //图片
@property (nonatomic, strong) NSString *sectionFooterGid;       //游戏 id
@property (nonatomic, strong) NSString *sectionFooterType;
@property (nonatomic, strong) NSString *sectionFooterUrl;       //链接地址
@property (nonatomic, strong) NSString *slideGid;
@property (nonatomic, strong) NSString *slidePic;

// ??使用 CGFloat error ????
@property (nonatomic, strong) NSString *sectionFooterHeight;

@property (nonatomic, strong) NSMutableArray *gameArray;
@property (nonatomic, strong) NSDictionary *gameSlide;


+ (instancetype)setTopModelWithDictionary:(NSDictionary *)dict;


@end


@interface FFServersModel : NSObject

@property (nonatomic, strong) NSDictionary *contentDataDict;

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray<FFTopGameModel *> *sectionArray;

@property (nonatomic, strong) FFTopGameModel    *gameBoutiqueTop;
@property (nonatomic, strong) FFTopGameModel    *gameNewTop;
@property (nonatomic, strong) FFTopGameModel    *gameWeeklyTop;
@property (nonatomic, strong) FFTopGameModel    *gameRecomment;



@end








