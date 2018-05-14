//
//  FFImageManager.m
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFImageManager.h"

#define image(name) [UIImage imageNamed:name]
#define RETURN_IMAGE(name) return image(name)

@implementation FFImageManager

/** tabbar */
+ (UIImage *)Tabbar_0_Normal            {RETURN_IMAGE(@"Tabbar_Game_Normal");}
+ (UIImage *)Tabbar_0_Select            {RETURN_IMAGE(@"Tabbar_Game_Select");}
+ (UIImage *)Tabbar_1_Normal            {RETURN_IMAGE(@"Tabbar_Server_Normal");}
+ (UIImage *)Tabbar_1_Select            {RETURN_IMAGE(@"Tabbar_Server_Select");}
+ (UIImage *)Tabbar_2_Normal            {RETURN_IMAGE(@"Tabbar_Station_Normal");}
+ (UIImage *)Tabbar_2_Select            {RETURN_IMAGE(@"Tabbar_Station_Select");}
+ (UIImage *)Tabbar_3_Normal            {RETURN_IMAGE(@"Tabbar_User_Normal");}
+ (UIImage *)Tabbar_3_Select            {RETURN_IMAGE(@"Tabbar_User_Select");}
+ (UIImage *)Tabbar_Center_button       {RETURN_IMAGE(@"Tabbar_Center_button");}
/** banner placeholder image */
+ (UIImage *)Basic_Banner_placeholder   {RETURN_IMAGE(@"Basic_Banner_placeholder");}

+ (UIImage *)Home_new_game      {RETURN_IMAGE(@"Home_new_game");}
+ (UIImage *)Home_hight_vip     {RETURN_IMAGE(@"Home_hight_vip");}
+ (UIImage *)Home_discount      {RETURN_IMAGE(@"Home_discount");}
+ (UIImage *)Home_classify      {RETURN_IMAGE(@"Home_classify");}
+ (UIImage *)Home_activity      {RETURN_IMAGE(@"Home_activity");}






@end
