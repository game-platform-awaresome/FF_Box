//
//  GDLikesTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/5/4.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"


@class FFClassifyTableCell;

@protocol FFClassifyTableCellDelegate <NSObject>

- (void)FFClassifyTableCell:(FFClassifyTableCell *)cell clickGame:(NSDictionary *)dict;

@end

@interface FFClassifyTableCell : UITableViewCell

/** 游戏信息 */
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, weak) id<FFClassifyTableCellDelegate> delegate;

@end
