//
//  UIColor+FFColor.h
//  FFTools
//
//  Created by 燚 on 2018/9/4.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (FFColor)


/**
 *  Color with Hexadecimal.
 */
UIColor *ff_ColorWithHex(int hex);
UIColor *ff_ColorWithHexAndAlpha(int hex, CGFloat alpha);

/**
 *  Color with Red Green Blue.
 *  max value: 255.
 *  min value: 0.
 */
UIColor *ff_RGBColor(CGFloat red, CGFloat green, CGFloat blue);
UIColor *ff_RGBAColor(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

/**
 *  Generate an image to the specified size with current color.
 *
 *  @param size     The returning image size.
 *
 *  @return         The image instance.
 */
- (UIImage *)ff_toImageWithSize:(CGSize)size;

/**
 *  Generate an image to the specified size with specified color.
 *
 *  @param color    The color to be used to generate an image.
 *  @param size     The result image size.
 *
 *  @return         The image instance.
 */
+ (UIImage *)ff_imageWithColor:(UIColor *)color size:(CGSize)size;





@end









