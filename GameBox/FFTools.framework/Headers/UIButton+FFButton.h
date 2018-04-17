//
//  UIButton+FFButton.h
//  FFViewFactory
//
//  Created by 燚 on 2018/1/16.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FFButtonImageStyle) {
    FFButtonImageOnTop,       // image is on top, label is on the ground
    FFButtonImageOnLeft,
    FFButtonImageOnBottom,
    FFButtonImageOnRight,
    FFBUttonImageLabelCenter
};


typedef void(^tapActionBlock)(UIButton * _Nonnull button);

@interface UIButton (FFButton)

@property(nonatomic,copy)tapActionBlock _Nullable actionBlock;

/** Create button */
+ (instancetype _Nonnull)createButton;

/** Create button with action block */
+ (instancetype _Nonnull)createButtonWithAction:(tapActionBlock _Nullable)actionBlock;

/**
 * Creat button with frame
 * @param frame       frame
 * @param title       title
 * @param imageName   image name
 * @param actionBlock call back block
 * @return button
 * */
+ (instancetype _Nonnull )createButtonFrame:(CGRect)frame
                                      title:(NSString * _Nullable)title
                                  imageName:(NSString * _Nullable)imageName
                                     action:(tapActionBlock _Nullable)actionBlock;

/**
 * Creat button with bounds and center
 * @param bounds      bounds
 * @param center      center
 * @param title       title
 * @param imageName   imageName
 * @param actionBlock call back block
 * @return button
 */
+ (instancetype _Nonnull )createButtonBounds:(CGRect)bounds
                                      center:(CGPoint)center
                                       title:(NSString * _Nullable)title
                                   imageName:(NSString * _Nullable)imageName
                                      action:(tapActionBlock _Nullable)actionBlock;


/**
 * set button titleLabel and imageView style，
 * @param style : titleLabe imageView
 * @param space : titleLabel和imageView的间距
 */
- (void)layoutButtonWithImageStyle:(FFButtonImageStyle)style
                   imageTitleSpace:(CGFloat)space;

/*
 * set button sshadows
 */
- (void)setShadowWithOffset:(CGSize)shadowOffset
              shadowOpacity:(CGFloat)shadowOpacity
               shadowRadius:(CGFloat)shadowRadius
                      color:(UIColor * _Nullable)shadowColor
                 shadowPath:(UIBezierPath * _Nullable)shadowPath;

- (void)setNormalTitle:(NSString * _Nullable)title
                 image:(UIImage * _Nullable)image;

- (void)setHighlightedTitle:(NSString * _Nullable)title
                      image:(UIImage * _Nullable)image;

- (void)setNormalTitle:(NSString * _Nullable)normalTitle
      HighlightedTitle:(NSString * _Nullable)highlightedTitle
           NormalImage:(UIImage * _Nullable)normalImage
      HighlightedImage:(UIImage * _Nullable)highlightedImage
      NormalTitleColor:(UIColor * _Nullable)normalTitleColor
 HighlightedTitleColor:(UIColor * _Nullable)highlightedTitleColor;


@end









