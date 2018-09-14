//
//  UITextField+FFTextField.h
//  FFTools
//
//  Created by 燚 on 2018/9/6.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UITextField (FFTextField)

/**
 *    Create a text field.
 *
 *    @param holder         The place holder.
 *    @param superView      The super view of created text field.
 *    @param constraints    Add constraints to the text field, if superview is nil, it will be ignored.
 *
 *    @return The text field instance.
 */
+ (instancetype)ff_textFieldWithPlaceHolder:(NSString *)holder
                                  SuperView:(UIView *)superView
                                Constraints:(FFConstraintMakerBlock)constraints;
/**
 *    Create a text field.
 *
 *    @param holder         The place holder.
 *    @param delegate       The text field delegate.
 *    @param superView      The super view of created text field.
 *    @param constraints    Add constraints to the text field, if superview is nil, it will be ignored.
 *
 *    @return The text field instance.
 */
+ (instancetype)ff_textFieldWithPlaceHolder:(NSString *)holder
                                   Delegate:(id<UITextFieldDelegate>)delegate
                                  SuperView:(UIView *)superView
                                Constraints:(FFConstraintMakerBlock)constraints;
/**
 *    Create a text field.
 *
 *    @param holder         The place holder.
 *    @param text           The text field default text.
 *    @param superView      The super view of created text field.
 *    @param constraints    Add constraints to the text field, if superview is nil, it will be ignored.
 *
 *    @return The text field instance.
 */
+ (instancetype)ff_textFieldWithPlaceHolder:(NSString *)holder
                                       Text:(NSString *)text
                                  SuperView:(UIView *)superView
                                Constraints:(FFConstraintMakerBlock)constraints;
/**
 *    Create a text field.
 *
 *    @param holder         The place holder.
 *    @param text           The text field default text.
 *    @param delegate       The text field delegate.
 *    @param superView      The super view of created text field.
 *    @param constraints    Add constraints to the text field, if superview is nil, it will be ignored.
 *
 *    @return The text field instance.
 */
+ (instancetype)ff_textFieldWithPlaceHolder:(NSString *)holder
                                       Text:(NSString *)text
                                   Delegate:(id<UITextFieldDelegate>)delegate
                                  SuperView:(UIView *)superView
                                Constraints:(FFConstraintMakerBlock)constraints;








@end












