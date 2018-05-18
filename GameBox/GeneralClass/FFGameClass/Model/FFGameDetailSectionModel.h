//
//  FFGameDetailSectionModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SecTionTypeGameIntroduction,
    SecTionTypeFeature,
    SecTionTypeActivity,
    SecTionTypeGif,
    SecTionTypeVip,
    SecTionTypeLike
} SecTionType;


@interface FFGameDetailSectionModel : NSObject


@property (nonatomic, assign) BOOL openUp;

@property (nonatomic, assign) float openUpHeight;
@property (nonatomic, assign) float normalHeight;

@property (nonatomic, assign) SecTionType sectionType;

@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) NSString *sectionHeaderTitle;
@property (nonatomic, strong) NSString *sectionFooterTitle;

@property (nonatomic, assign) int sectionItemNumber;

@property (nonatomic, strong) id cell;


+ (instancetype)initWithType:(SecTionType)type;

- (void)refreshDataWith:(SecTionType)type;




@end






