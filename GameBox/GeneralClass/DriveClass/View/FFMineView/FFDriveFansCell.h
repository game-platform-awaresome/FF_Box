//
//  FFDriveFansCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/31.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFDriveFansCell;


@protocol FFDriveCellDelegate <NSObject>

- (void)FFDriveFansCell:(FFDriveFansCell *)cell clickAttentionButtonWitDict:(NSDictionary *)dict;


@end


@interface FFDriveFansCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, weak) id<FFDriveCellDelegate> delegate;

@end
