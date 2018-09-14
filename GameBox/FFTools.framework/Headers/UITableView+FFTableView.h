//
//  UITableView+FFTableView.h
//  FFTools
//
//  Created by 燚 on 2018/9/6.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UITableView (FFTableView)

/**
 *  Create a table view.
 */
+ (instancetype)ff_tableView;

/**
 *  Create a table view.
 */
+ (instancetype)ff_tableViewWithDelegate:(id)delegate
                                   Style:(UITableViewStyle)style;

/**
 *  Create a table view.
 *
 *  @param superView    he super view for table view.
 *
 *  @return The table view instance.
 */
+ (instancetype)ff_tableViewWithSuperView:(UIView *)superView;

/**
 *  Create a table view.
 *
 *  @param superView    he super view for table view.
 *  @param constraints  Make constraints for table view.
 *
 *  @return The table view instance.
 */
+ (instancetype)ff_tableViewWithSuperView:(UIView *)superView
                              Constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create a table view.
 *
 *  @param superView    he super view for table view.
 *  @param delegate     Delgate and dataSource.
 *
 *  @return The table view instance.
 */
+ (instancetype)ff_tableViewWithSuperView:(UIView *)superView
                                 Delegate:(id)delegate;
/**
 *  Create a table view.
 *
 *  @param superView    he super view for table view.
 *  @param delegate     Delgate and dataSource.
 *  @param constraints  Make constraints for table view.
 *
 *  @return The table view instance.
 */
+ (instancetype)ff_tableViewWithSuperView:(UIView *)superView
                                 Delegate:(id)delegate
                              Constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create a table view.
 *
 *  @param superView    he super view for table view.
 *  @param delegate     Delgate and dataSource.
 *  @param style        UITableViewStyle.
 *  @param constraints  Make constraints for table view.
 *
 *  @return The table view instance.
 */
+ (instancetype)ff_tableViewWithSuperView:(UIView *)superView
                                 Delegate:(id)delegate
                                    Style:(UITableViewStyle)style
                           SeparatorStyle:(UITableViewCellSeparatorStyle)separatorstyle
                              Constraints:(FFConstraintMakerBlock)constraints;



@end












