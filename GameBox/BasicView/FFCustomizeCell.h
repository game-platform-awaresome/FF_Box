//
//  SearchCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFCustomizeCell;

@protocol FFCustomizeCellDelegate <NSObject>

- (void)FFCustomizeCell:(FFCustomizeCell *)cell didSelectCellRowAtIndexPathWith:(NSDictionary *)dict;

@end



@interface FFCustomizeCell : UITableViewCell

/** 游戏信息 */
@property (nonatomic, strong) NSDictionary *dict;

/** 游戏logo */
@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

/** 游戏评分 */
@property (nonatomic, assign) CGFloat source;

/** 代理 */
@property (nonatomic, weak) id<FFCustomizeCellDelegate> delegate;

/** 是否是预约游戏 */
@property (nonatomic, strong) NSString *betaGame;

@property (nonatomic, strong) NSString *ReservationGame;

/** 是否是 H5 的游戏 */
@property (nonatomic, assign) BOOL isH5Game;


@end







