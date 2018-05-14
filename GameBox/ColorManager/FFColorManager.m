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

+ (UIColor *)navigationColor {
    return RGBColor(250, 121, 34);
}

+ (UIColor *)tabbarColor {
    return RGBColor(247,247,247);
}

+ (UIColor *)backgroundColor {
    return RGBColor(239, 240, 241);
}

+ (UIColor *)textColorDark {
    return RGBColor(55, 60, 65);
}

+ (UIColor *)tabbar_item_color {
    return [FFColorManager blue_dark];
}


+ (UIColor *)home_select_view_color {
    return [FFColorManager blue_dark];
}
+ (UIColor *)home_select_view_lineColor {
    return [FFColorManager blue_dark];
}


+ (UIColor *)custom_cell_text1_color {
    return RGBColor(173, 170, 217);
}
+ (UIColor *)custom_cell_text2_color {
    return RGBColor(77, 180, 180);
}
+ (UIColor *)custom_cell_text3_color {
    return RGBColor(247, 189, 52);
}

+ (UIColor *)web_waitng_color {
    return [self blue_dark];
}

+ (UIColor *)blue_dark {
    return RGBColor(54, 145, 224);
}
+ (UIColor *)blue_light {
    return RGBColor(42, 179, 231);
}
+ (UIColor *)gray_color {
    return RGBColor(230, 230, 230);
}





@end















