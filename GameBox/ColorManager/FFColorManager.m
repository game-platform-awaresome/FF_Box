//
//  FFColorManager.m
//  GameBox
//
//  Created by 燚 on 2018/5/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFColorManager.h"


/**
 * @param red       max value:255
 * @param green     max value:255
 * @param blue      max value:255
 * @param alpha     max value:255
 */
UIColor *RGBAColor(float red, float green, float blue, float alpha) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha / 255.0];
}

UIColor *RGBColor(float red, float green, float blue) {
    return RGBAColor(red, green, blue, 255);
}

UIColor *HexColorToUIColor(NSString *hexColorString) {

    if ([hexColorString length] < 6) {
        syLog(@"hex color string error : lenth < 6");
        return [UIColor blackColor];
    }

    NSString *tempString = [hexColorString lowercaseString];

    if ([tempString hasPrefix:@"0x"]) {
        tempString = [tempString substringFromIndex:2];
    } else if ([tempString hasPrefix:@"#"]) {
        tempString = [tempString substringFromIndex:1];
    }

    if ([tempString length] != 6) {
        syLog(@"hex color string error : formatter error");
        return [UIColor blackColor];
    }

    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4;
    NSString *bString = [tempString substringWithRange:range];
        // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@implementation FFColorManager

+ (UIColor *)current_version_main_color {
    return [FFColorManager blue_dark];
}

+ (UIColor *)view_default_background_color {
    return [UIColor whiteColor];
}

+ (UIColor *)navigationColor {
    return RGBColor(250, 121, 34);
}

+ (UIColor *)tabbarColor {
    return RGBColor(247,247,247);
}

+ (UIColor *)backgroundColor {
    return RGBColor(255, 255, 255);
}

//字体灰色
+ (UIColor *)textColorDark {
    return RGBColor(55, 55, 55);
}
+ (UIColor *)textColorMiddle {
    return RGBColor(102, 102, 102);
}
+ (UIColor *)textColorLight {
    return RGBColor(153, 153, 153);
}

+ (UIColor *)tabbar_item_color {
    return [FFColorManager blue_dark];
}

+ (UIColor *)light_gray_color {
    return [UIColor colorWithWhite:0.85 alpha:1];
}

#pragma mark - home view
+ (UIColor *)home_select_view_color {
    return [FFColorManager blue_dark];
}
+ (UIColor *)home_select_view_lineColor {
    return [FFColorManager blue_dark];
}
+ (UIColor *)home_select_View_separat_lineColor {
    return [FFColorManager view_separa_line_color];
}
+ (UIColor *)home_search_view_background_color {
    return [FFColorManager view_separa_line_color];
}

+ (UIColor *)custom_cell_text1_color {
    return RGBColor(90, 190, 240);
}
+ (UIColor *)custom_cell_text2_color {
    return RGBColor(251, 169, 52);
}
+ (UIColor *)custom_cell_text3_color {
    return RGBColor(252, 125, 126);
}
+ (NSArray *)text_color_array {
    return  @[[self custom_cell_text1_color],[self custom_cell_text2_color],[self custom_cell_text3_color]];
}

+ (UIColor *)web_waitng_color {
    return [self blue_dark];
}

/** 界面主蓝色 */ 
+ (UIColor *)blue_dark {
    return RGBColor(41, 161, 247);
}
+ (UIColor *)blue_light {
    return RGBColor(42, 179, 231);
}
+ (UIColor *)gray_color {
    return RGBColor(230, 230, 230);
}




+ (UIColor *)tableview_background_color {
    return [UIColor whiteColor];
}



#pragma mark - game view controller
+ (UIColor *)game_controller_navigation_color {
    return [UIColor whiteColor];
}
+ (UIColor *)game_header_setview_BKColor {
    return [UIColor whiteColor];
}

+ (UIColor *)game_header_label_color {
    return [self game_header_setview_BKColor];
}

+ (UIColor *)game_select_line_color {
    return [UIColor colorWithWhite:0.85 alpha:1];
}
+ (UIColor *)game_select_normal_color {
    return [UIColor blackColor];
}

+ (UIColor *)game_select__color {
    return [self blue_dark];
}

+ (UIColor *)game_select_cursor_color {
    return [self blue_dark];
}


#pragma mark - navigationbar color
+ (UIColor *)navigation_bar_white_color {
    return [UIColor colorWithWhite:1 alpha:1];
}
+ (UIColor *)navigation_bar_black_color {
    return [UIColor colorWithWhite:0.15 alpha:1];
}


#pragma mark - separa color
/** 界面灰色分割线 */
+ (UIColor *)view_separa_line_color {
     return RGBColor(238, 238, 238);
}
/** 标签灰色分割线 */
+ (UIColor *)text_separa_line_color {
     return RGBColor(188, 188, 188);
}


+ (UIColor *)text_background_color {
    return RGBColor(242, 242, 242);
}

@end















