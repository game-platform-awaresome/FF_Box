//
//  UIFont+FFFont.h
//  FFTools
//
//  Created by Sans on 2018/8/28.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (FFFont)

+ (UIFont *)ff_boldFontWithSize:(CGFloat)size;
+ (UIFont *)ff_systemFontWithSize:(CGFloat)size;
+ (UIFont *)ff_fontWithName:(NSString *)name Size:(CGFloat)size;



@end
