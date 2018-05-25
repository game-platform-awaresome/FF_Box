//
//  FFGameDetailSectionModel.h
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SecTionTypeGameIntroduction,
    SecTionTypeFeature,
    SecTionTypeActivity,
    SecTionTypeGif,
    SecTionTypeVip,
    SecTionTypeLike
} SecTionType;

typedef void(^SelectLikeButtonBlock)(NSDictionary *info);
typedef void(^SelectActivityBlock)(NSDictionary *dict);

@interface FFGameDetailSectionModel : NSObject


@property (nonatomic, assign) BOOL openUp;

@property (nonatomic, assign) CGFloat openUpHeight;
@property (nonatomic, assign) CGFloat normalHeight;

@property (nonatomic, assign) SecTionType sectionType;

@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) NSString *sectionHeaderTitle;
@property (nonatomic, strong) NSString *sectionFooterTitle;

@property (nonatomic, assign) CGFloat sectionFooterHeight;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;

@property (nonatomic, assign) int sectionItemNumber;

@property (nonatomic, strong) id cell;

@property (nonatomic, strong) SelectLikeButtonBlock likeButtonBlock;
@property (nonatomic, strong) SelectActivityBlock ActivityBlock;

+ (instancetype)initWithType:(SecTionType)type;

- (void)refreshDataWith:(SecTionType)type;

@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) UIView *sectionFooterView;

@property (nonatomic, strong) UITableView *tableView;


- (void)modelTableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end






