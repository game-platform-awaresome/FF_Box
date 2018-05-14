//
//  FFColorManager.h
//  GameBox
//
//  Created by 燚 on 2018/5/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


UIColor *RGBAColor(float red, float green, float blue, float alpha);
UIColor *RGBColor(float red, float green, float blue);

@interface FFColorManager : NSObject

+ (UIColor *)navigationColor;
+ (UIColor *)tabbarColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)textColorDark;
+ (UIColor *)tabbar_item_color;

+ (UIColor *)home_select_view_color;
+ (UIColor *)home_select_view_lineColor;

+ (UIColor *)custom_cell_text1_color;
+ (UIColor *)custom_cell_text2_color;
+ (UIColor *)custom_cell_text3_color;

+ (UIColor *)web_waitng_color;


+ (UIColor *)blue_dark;
+ (UIColor *)blue_light;
+ (UIColor *)gray_color;



/**
 // RGB Color
 #define TEXTCOLOR RGBCOLOR(55,60,65) */







@end
