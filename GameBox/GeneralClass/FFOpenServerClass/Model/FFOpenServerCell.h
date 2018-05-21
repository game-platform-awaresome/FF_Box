//
//  NewServerTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFOpenServerCell;

@protocol FFopenServerCellDelegate <NSObject>

- (void)FFOpenServerCell:(FFOpenServerCell *)cell clickRemindButton:(BOOL)addRemind;

@end

@interface FFOpenServerCell : UITableViewCell

/** 游戏logo */
@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

/** 游戏数据 */
@property (nonatomic, strong) NSDictionary *dict;


@property (nonatomic, strong) id<FFopenServerCellDelegate> delegate;




@end
