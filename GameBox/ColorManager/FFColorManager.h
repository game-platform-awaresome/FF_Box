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

+ (UIColor *)current_version_main_color;
+ (UIColor *)view_default_background_color;

+ (UIColor *)navigationColor;
+ (UIColor *)tabbarColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)textColorDark;
+ (UIColor *)textColorMiddle;
+ (UIColor *)textColorLight;
+ (UIColor *)tabbar_item_color;
+ (UIColor *)light_gray_color;


+ (UIColor *)custom_cell_text1_color;
+ (UIColor *)custom_cell_text2_color;
+ (UIColor *)custom_cell_text3_color;
+ (NSArray<UIColor *> *)text_color_array;


+ (UIColor *)web_waitng_color;

#pragma mark - main color
+ (UIColor *)blue_dark;
+ (UIColor *)blue_light;
+ (UIColor *)gray_color;


+ (UIColor *)tableview_background_color;
/**
 // RGB Color
 #define TEXTCOLOR RGBCOLOR(55,60,65) */


#pragma mark - home view controller
+ (UIColor *)home_select_view_color;
+ (UIColor *)home_select_view_lineColor;
+ (UIColor *)home_select_View_separat_lineColor;
+ (UIColor *)home_search_view_background_color;

#pragma mark - game view controller
+ (UIColor *)game_controller_navigation_color;
+ (UIColor *)game_header_setview_BKColor;
+ (UIColor *)game_header_label_color;
+ (UIColor *)game_select_line_color;
+ (UIColor *)game_select_normal_color;
+ (UIColor *)game_select__color;
+ (UIColor *)game_select_cursor_color;


#pragma mark - navigationbar color
+ (UIColor *)navigation_bar_white_color;
+ (UIColor *)navigation_bar_black_color;


@end





