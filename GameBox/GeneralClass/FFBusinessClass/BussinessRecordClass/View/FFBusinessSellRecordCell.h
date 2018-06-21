//
//  FFBusinessSellRecordCell.h
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBusinessModel.h"

@class FFBusinessSellRecordCell;

@protocol FFBusinessSellRecordCellDelegate <NSObject>

@required
- (void)FFBusinessSellRecordCell:(FFBusinessSellRecordCell *)cell clickButtonWithInfo:(id)info;



@end


@interface FFBusinessSellRecordCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) FFBusinessUserSellType type;

@property (nonatomic, weak) id<FFBusinessSellRecordCellDelegate> delegate;

@end
