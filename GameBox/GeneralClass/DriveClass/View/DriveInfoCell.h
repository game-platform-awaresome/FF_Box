//
//  DriveInfoCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/12.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDynamicModel.h"
@class DriveInfoCell;

typedef enum : NSUInteger {
    likeButton,
    dislikeButton,
    sharedButton,
    commentButoon,
    noonButton
} CellButtonType;

@protocol DriveInfoCellDelegate <NSObject>
//点击头像响应
- (void)DriveInfoCell:(DriveInfoCell *)cell didClickIconWithUid:(NSString *)uid WithIconImage:(UIImage *)iconImage;

@optional
//cell 下面的 4个按钮响应事件
- (void)DriveInfoCell:(DriveInfoCell *)cell didClickButtonWithType:(CellButtonType)type;



@end

@interface DriveInfoCell : UITableViewCell

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) FFDynamicModel *model;

@property (nonatomic, strong, readonly) NSString *dynamicsID;

@property (nonatomic, weak) id<DriveInfoCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

- (void)starGif;

- (void)stopGif;



@end








