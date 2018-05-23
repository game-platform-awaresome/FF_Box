//
//  RebateTableViewCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFApplyRebateModel.h"
@class RebateTableViewCell;

@protocol RebateTableViewCellDelegate <NSObject>

- (void)RebateTableViewCell:(RebateTableViewCell *)cell clickApplyButtonWithUserModel:(FFApplyUserModel *)model;

@end

@interface RebateTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) FFApplyRebateModel *model;
@property (nonatomic, strong) FFApplyUserModel *userModel;

@property (nonatomic, weak) id<RebateTableViewCellDelegate> delegate;

@end
