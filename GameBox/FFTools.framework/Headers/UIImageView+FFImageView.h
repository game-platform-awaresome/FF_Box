//
//  UIImageView+FFImageView.h
//  FFTools
//
//  Created by 燚 on 2018/9/3.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UIImageView (FFImageView)


+ (instancetype)ff_imageView;

+ (instancetype)ff_imageViewWithSuperView:(UIView *)superView
                              constraints:(FFConstraintMakerBlock)constraints;

+ (instancetype)ff_imageViewWithSuperView:(UIView *)superView
                              constraints:(FFConstraintMakerBlock)constraints
                                  onTaped:(FFTapGestureBlock)onTaped;

+ (instancetype)ff_imageViewWithImage:(id)image
                            superView:(UIView *)superView
                           onstraints:(FFConstraintMakerBlock)constraints;

+ (instancetype)ff_imageViewWithImage:(id)image
                            superView:(UIView *)superView
                          constraints:(FFConstraintMakerBlock)constraints
                              onTaped:(FFTapGestureBlock)onTaped;

+ (instancetype)ff_imageViewWithImage:(id)image
                             isCircle:(BOOL)isCircle
                            superView:(UIView *)superView
                           onstraints:(FFConstraintMakerBlock)constraints
                              onTaped:(FFTapGestureBlock)onTaped;


+ (instancetype)ff_imageViewWithImage:(id)image
                         cornerRadius:(float)cornerRadius
                        masksToBounds:(BOOL)masksToBounds
                            superView:(UIView *)superView
                           onstraints:(FFConstraintMakerBlock)constraints
                              onTaped:(FFTapGestureBlock)onTaped;



@end





