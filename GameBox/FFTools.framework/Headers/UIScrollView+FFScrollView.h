//
//  UIScrollView+FFScrollView.h
//  FFTools
//
//  Created by 燚 on 2018/9/5.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UIScrollView (FFScrollView)


/**
 *  Create a scroll view with delegate, without layout.
 *
 *  @param delegate    The scroll view delegate
 *
 *  @return Instance of UIScrollView.
 */
+ (instancetype)ff_scrollViewWithDelegate:(id)delegate;

/**
 *  Create a scroll view with delegate and superview, and will make it
 *  hold it's super view's edges.
 *
 *  @param delegate     The scroll view delegate
 *  @param superView    The scroll view's super view.
 *
 *  @return Instance of UIScrollView.
 */
+ (instancetype)ff_scrollViewWithDelegate:(id)delegate
                                 SuperView:(UIView *)superView;

/**
 *  Create a scroll view with delegate, superview, and add constraints to it.
 *  If super view is nil, constraints will be ignored.
 *
 *  @param delegate     The scroll view delegate
 *  @param superView    The scroll view's super view.
 *  @param constraints  Add constraints to the scroll view.
 *
 *  @return Instance of UIScrollView.
 */
+ (instancetype)ff_scrollViewWithDelegate:(id)delegate
                                SuperView:(UIView *)superView
                            PagingEnabled:(BOOL)pagingEnabled
                              Constraints:(FFConstraintMakerBlock)constraints;





@end
