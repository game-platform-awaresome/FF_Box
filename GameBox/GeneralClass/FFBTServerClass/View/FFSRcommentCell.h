//
//  FFSRcommentCell.h
//  GameBox
//
//  Created by 燚 on 2018/5/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFServersModel.h"
@class FFSRcommentCell;

@protocol FFSRcommentCellDelegate <NSObject>


- (void)FFSRcommentCell:(FFSRcommentCell *)cell didSelectItemInfo:(id)info;


@end

@interface FFSRcommentCell : UITableViewCell

@property (nonatomic, strong) FFTopGameModel *model;

@property (nonatomic, strong) id <FFSRcommentCellDelegate> delegate;

@property (nonatomic, strong) NSArray *gameArray;

@property (nonatomic, assign) BOOL isH5Game;

@end
