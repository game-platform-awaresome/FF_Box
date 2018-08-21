//
//  FFRankListCell.h
//  GameBox
//
//  Created by 燚 on 2018/8/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFRankListCell : UITableViewCell

/**
 *  Set cell interface based on dict
 */
@property (nonatomic, strong) NSDictionary *dict;

/**
 *  game logo
 */
@property (nonatomic, strong) UIImageView *gameLogoImageView;

/**
 *  is h5 game
 */
@property (nonatomic, assign) BOOL isH5Game;

/**
 * right butto image
 */
@property (nonatomic, strong) id rigthButtonImage;

@property (nonatomic, strong) NSIndexPath   *indexPath;


@property (nonatomic, assign) NSInteger     idx;


@end
