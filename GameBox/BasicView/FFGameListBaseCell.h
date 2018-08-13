//
//  FFGameListBaseCell.h
//  GameBox
//
//  Created by 燚 on 2018/8/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

#define GamelistBaseCellIDE @"FFGameListBaseCell"

/**
 *  Custom game table list cell
 */
@interface FFGameListBaseCell : UITableViewCell

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


/** reigst cell to table with default identifier */
+ (BOOL)registCellToTabelView:(UITableView *)tableView;
/** reigst cell to table with identifier */
+ (BOOL)registCellToTabelView:(UITableView *)tableView WithIdentifier:(NSString *)Identifier;

/**
 *  Return to reused cell
 */
+ (FFGameListBaseCell *)cellRegistWithTableView:(UITableView *)tableView;
/**
 *  Return to reused cell
 */
+ (FFGameListBaseCell *)cellRegistWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

/** set right button image */
- (void)setRigthButtonImage:(id)image;



@end








