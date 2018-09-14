//
//  UIView+FFView.h
//  FFTools
//
//  Created by 燚 on 2018/9/3.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UIView (FFView)

#pragma makr - gesture call back block
/**
 *  The tap gesture getter. @see ff_addTapGestureWithCallback
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *ff_tapGesture;

/**
 *  The long press gesture getter, @see ff_addLongGestureWithCallback
 */
@property (nonatomic, strong,readonly) UILongPressGestureRecognizer *ff_longGesure;

/**
 *  Add a tap gesture with callback. It will automatically open userInterface to YES.
 *
 *  @param onTaped    The callback block when taped.
 */
- (void)ff_addTapGestureWithCallback:(FFTapGestureBlock)onTaped;

/**
 *  Add long press gesture with callback. It will automatically open userInterface to YES.
 *
 *  @param onLongPressed    The long press callback when long pressed.
 */
- (void)ff_addLongGestureWithCallback:(FFLongPressGestureBlock)onLongPressed;


#pragma makr - init method
/**
 *  Create an empty view with super view
 *
 *  @param superView        The super view of created view.
 *
 *  @return The view instance.
 */
+ (instancetype)ff_viewWithSuperView:(UIView *)superView;
/**
 *  Create an empty view with super view
 *
 *  @param superView        The super view of created view.
 *  @param onTaped          The tap gesture callback.
 *
 *  @return The view instance.
 */
+ (instancetype)ff_viewWithSuperView:(UIView *)superView
                             onTaped:(FFTapGestureBlock)onTaped;

/**
 *  Create an empty view with super view
 *
 *  @param superView        The super view of created view.
 *  @param constraints      The added contraints of view.
 *
 *  @return The view instance.
 */
+ (instancetype)ff_viewWithSuperView:(UIView *)superView
                             constraints:(FFConstraintMakerBlock)constraints;

/**
 *  Create an empty view with super view
 *
 *  @param superView        The super view of created view.
 *  @param constraints      The added contraints of view.
 *  @param onTaped          The tap gesture callback.
 *
 *  @return The view instance.
 */
+ (instancetype)ff_viewWithSuperView:(UIView *)superView
                         constraints:(FFConstraintMakerBlock)constraints
                             onTaped:(FFTapGestureBlock)onTaped;
/**
 *  Create an empty view with super view
 *
 *  @param superView        The super view of created view.
 *  @param backgroundColor  The backgroundColor of view.
 *  @param constraints      The added contraints of view.
 *
 *  @return The view instance.
 */
+ (instancetype)ff_viewWithSuperView:(UIView *)superView
                     backgroundColor:(UIColor *)backgroundColor
                         constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create an empty view with super view
 *
 *  @param superView        The super view of created view.
 *  @param backgroundColor  The backgroundColor of view.
 *  @param constraints      The added contraints of view.
 *  @param onTaped          The tap gesture callback.
 *
 *  @return The view instance.
 */
+ (instancetype)ff_viewWithSuperView:(UIView *)superView
                     backgroundColor:(UIColor *)backgroundColor
                         constraints:(FFConstraintMakerBlock)constraints
                             onTaped:(FFTapGestureBlock)onTaped;

#pragma mark - line
/**
 *  Add a line(view) to the view of top.
 *
 *  @param toView       The view that needs to add a line.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addTopLineToView:(UIView  *)toView
                             Height:(CGFloat  )height
                              Color:(UIColor *)color;
/**
 *  Add a line(view) to the view of top.
 *
 *  @param toView       The view that needs to add a line.
 *  @param distance     The distance of view top.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addTopLineToView:(UIView *)toView
                           Distance:(CGFloat)distance
                             Height:(CGFloat)height
                              Color:(UIColor *)color;
/**
 *  Add a line(view) to the view of top.
 *
 *  @param toView       The view that needs to add a line.
 *  @param leftPadding  The padding of left.
 *  @param rightPadding The padding of right.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addTopLineToView:(UIView *)toView
                        LeftPadding:(CGFloat)leftPadding
                       RightPadding:(CGFloat)rightPadding
                             Height:(CGFloat)height
                              Color:(UIColor *)color;
/**
 *  Add a line(view) to the view of top.
 *
 *  @param toView       The view that needs to add a line.
 *  @param distance     The distance of view top.
 *  @param leftPadding  The padding of left.
 *  @param rightPadding The padding of right.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addTopLineToView:(UIView *)toView
                           Distance:(CGFloat)distance
                        LeftPadding:(CGFloat)leftPadding
                       RightPadding:(CGFloat)rightPadding
                             Height:(CGFloat)height
                              Color:(UIColor *)color;

/**
 *  Add a line(view) to the view of bottom.
 *
 *  @param toView       The view that needs to add a line.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addBottomLineToView:(UIView *)toView
                                Height:(CGFloat)height
                                 Color:(UIColor *)color;
/**
 *  Add a line(view) to the view of bottom.
 *
 *  @param toView       The view that needs to add a line.
 *  @param distance     The distance of view bottom.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addBottomLineToView:(UIView *)toView
                              Distance:(CGFloat)distance
                                Height:(CGFloat)height
                                 Color:(UIColor *)color;
/**
 *  Add a line(view) to the view of bottom.
 *
 *  @param toView       The view that needs to add a line.
 *  @param leftPadding  The padding of left.
 *  @param rightPadding The padding of right.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addBottomLineToView:(UIView *)toView
                           LeftPadding:(CGFloat)leftPadding
                          RightPadding:(CGFloat)rightPadding
                                Height:(CGFloat)height
                                 Color:(UIColor *)color;
/**
 *  Add a line(view) to the view of bottom.
 *
 *  @param toView       The view that needs to add a line.
 *  @param distance     The distance of view bottom.
 *  @param leftPadding  The padding of left.
 *  @param rightPadding The padding of right.
 *  @param height       The line height.
 *  @param color        The color of line.
 *
 *  @return             The instance of view.
 */
+ (instancetype)ff_addBottomLineToView:(UIView *)toView
                              Distance:(CGFloat)distance
                           LeftPadding:(CGFloat)leftPadding
                          RightPadding:(CGFloat)rightPadding
                                Height:(CGFloat)height
                                 Color:(UIColor *)color;




#pragma mark - constant
/**
 * view.frame.origin.x
 */
@property (nonatomic, assign) CGFloat ff_originX;

/**
 * view.frame.origin.y
 */
@property (nonatomic, assign) CGFloat ff_originY;

/**
 * view.frame.origin
 */
@property (nonatomic, assign) CGPoint ff_origin;

/**
 * view.center.x
 */
@property (nonatomic, assign) CGFloat ff_centerX;

/**
 * view.center.y
 */
@property (nonatomic, assign) CGFloat ff_centerY;

/**
 * view.center
 */
@property (nonatomic, assign) CGPoint ff_center;

/**
 * view.frame.size.width
 */
@property (nonatomic, assign) CGFloat ff_width;

/**
 * view.frame.size.height
 */
@property (nonatomic, assign) CGFloat ff_height;

/**
 * view.frame.size
 */
@property (nonatomic, assign) CGSize  ff_size;

/**
 * view.frame.size.height + view.frame.origin.y
 */
@property (nonatomic, assign) CGFloat ff_bottomY;

/**
 * view.frame.size.width + view.frame.origin.x
 */
@property (nonatomic, assign) CGFloat ff_rightX;










@end









