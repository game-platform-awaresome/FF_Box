//
//  UILabel+FFLabel.h
//  FFTools
//
//  Created by 燚 on 2018/9/6.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UILabel (FFLabel)

/**
 *  Create label with system font
 */
+ (instancetype)ff_labelWithFont:(CGFloat)font;
/**
 *  Create label with aotu font
 *  About autoFont  @see "UIFont+FFFont.h"
 */
+ (instancetype)ff_labelWithAutoFont:(CGFloat)autofont;

/**
 *  Create  label.
 *
 *  @param  text         label text.
 *  @param  font         system font size.
 *
 *  About autoFont  @see "UIFont+FFFont.h"
 *  @return label
 */
+ (instancetype)ff_labelWithText:(NSString *)text
                            font:(CGFloat)font;
/**
 *  Create  label.
 *
 *  @param  text         label text.
 *  @param  autoFont     automatically adapt to font size.
 *
 *  About autoFont  @see "UIFont+FFFont.h"
 *  @return label
 */
+ (instancetype)ff_labelWithText:(NSString *)text
                        autofont:(CGFloat)autoFont;

/**
 *  Create  label.
 *
 *  @param  font         system font size.
 *  @param  superView    the label super's view
 *  @param  constraints  add constraints to label
 *
 *  @return label
 */
+ (instancetype)ff_labelWithFont:(CGFloat)font
                       superView:(UIView *)superView
                     constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create  label.
 *
 *  @param  autoFont     automatically adapt to font size.
 *  @param  superView    the label super's view
 *  @param  constraints  add constraints to label
 *
 *  About autoFont  @see "UIFont+FFFont.h"
 *  @return label
 */
+ (instancetype)ff_labelWithAutoFont:(CGFloat)autoFont
                           superView:(UIView *)superView
                         constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create  label.
 *
 *  @param  text         label text.
 *  @param  font         system font size.
 *  @param  superView    the label super's view
 *  @param  constraints  add constraints to label
 *
 *  @return label
 */
+ (instancetype)ff_labelWithText:(NSString *)text
                            font:(CGFloat)font
                       superView:(UIView *)superView
                     constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create  label.
 *
 *  @param  text         label text.
 *  @param  autoFont     automatically adapt to font size.
 *  @param  superView    the label super's view
 *  @param  constraints  add constraints to label
 *
 *  About autoFont  @see "UIFont+FFFont.h"
 *  @return label
 */
+ (instancetype)ff_labelWithText:(NSString *)text
                        autoFont:(CGFloat)autoFont
                       superView:(UIView *)superView
                     constraints:(FFConstraintMakerBlock)constraints;

/**
 *  Create  label.
 *
 *  @param  text         label text.
 *  @param  autoFont     automatically adapt to font size.
 *  @param  font         system font size.
 *  @param  lines        label numberoflines
 *  @param  superView    the label super's view
 *  @param  constraints  add constraints to label
 *
 *  About autoFont  @see "UIFont+FFFont.h"
 *  @return label
 */
+ (instancetype)ff_labelWithText:(NSString *)text
                        autoFont:(CGFloat)autoFont
                            font:(CGFloat)font
                           lines:(NSInteger)lines
                       superView:(UIView *)superView
                     constraints:(FFConstraintMakerBlock)constraints;










@end
