//
//  UIButton+FFButton.h
//  FFViewFactory
//
//  Created by 燚 on 2018/1/16.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

typedef NS_ENUM(NSUInteger, FFButtonImageStyle) {
    FFButtonImageOnTop,         // image on top, label below
    FFButtonImageOnLeft,        // image on left, label right
    FFButtonImageOnBottom,      // image below, label ont top
    FFButtonImageOnRight,       // image on right, label left
    FFBUttonImageLabelCenter    // image center
};

@interface UIButton (FFButton)

@property(nonatomic,copy)FFButtonBlock _Nullable actionBlock;

#pragma mark - layout button style
/**
 *  Set the style of the button with image and label.
 *
 *  @warning Use this method to set the appropriate size.
 *  @warning Use before setting font size and image.
 *
 *  @param style        style @see FFButtonImageStyle.
 *  @param space        Image and label distance
 *
 */
- (void)layoutButtonWithImageStyle:(FFButtonImageStyle)style
                   imageTitleSpace:(CGFloat)space;

#pragma mark - Quick init method
/**
 *  Create a button.
 *
 *  @param touchUp      The touch up event callback block.
 *
 *  @return UIButton    instance.
 */
+ (instancetype)ff_buttonWithTouchUp:(FFButtonBlock)touchUp;

/**
 *  Create a button.
 *
 *  @param superView        Add the button to the superView.
 *  @param constraints      Using Masonry to add constraints.
 *  @param touchUp          The callback of touching up event.
 *
 *  @return UIButton instance.
 */
+ (instancetype)ff_buttonSuperView:(UIView *)superView
                       Constraints:(FFConstraintMakerBlock)constraints
                           TouchUp:(FFButtonBlock)touchUp;
/**
 *  Create a button.
 *
 *  @param title            Normal title.
 *  @param superView        Add the button to the superView.
 *  @param constraints      Using Masonry to add constraints.
 *  @param touchUp          The callback of touching up event.
 *
 *  @return UIButton instance.
 */
+ (instancetype)ff_buttonWithTitle:(NSString *)title
                         SuperView:(UIView *)superView
                       Constraints:(FFConstraintMakerBlock)constraints
                           TouchUp:(FFButtonBlock)touchUp;
/**
 *  Create a button.
 *
 *  @param image            Normal image.
 *  @param superView        Add the button to the superView.
 *  @param constraints      Using Masonry to add constraints.
 *  @param touchUp          The callback of touching up event.
 *
 *  @return UIButton instance.
 */
+ (instancetype)ff_buttonWithImage:(id)image
                         SuperView:(UIView *)superView
                       Constraints:(FFConstraintMakerBlock)constraints
                           TouchUp:(FFButtonBlock)touchUp;
/**
 *  Create a button.
 *
 *  @param image            Normal image.
 *  @param selectedImage    Select image.
 *  @param superView        Add the button to the superView.
 *  @param constraints      Using Masonry to add constraints.
 *  @param touchUp          The callback of touching up event.
 *
 *  @return UIButton instance.
 */
+ (instancetype)ff_buttonWithImage:(id)image
                     SelectedImage:(id)selectedImage
                         SuperView:(UIView *)superView
                       Constraints:(FFConstraintMakerBlock)constraints
                           TouchUp:(FFButtonBlock)touchUp;

#pragma mark - shadow
/** set button shadow */
- (void)setShadowWithOffset:(CGSize)shadowOffset
              shadowOpacity:(CGFloat)shadowOpacity
               shadowRadius:(CGFloat)shadowRadius
                      color:(UIColor * _Nullable)shadowColor
                 shadowPath:(UIBezierPath * _Nullable)shadowPath;







@end









