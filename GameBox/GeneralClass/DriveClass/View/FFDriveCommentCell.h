//
//  FFDriveCommentCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/22.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFDriveCommentCell;


@protocol FFDriveCommentCellDelegate <NSObject>

- (void)FFDriveCommentCell:(FFDriveCommentCell *)cell didClickLikeButtonWith:(NSDictionary *)dict;

@end

@interface FFDriveCommentCell : UITableViewCell


@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, weak) id<FFDriveCommentCellDelegate> delegate;


@end
