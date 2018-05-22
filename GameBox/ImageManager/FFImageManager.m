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

/**  gameLogoPlaceholderImage */
+ (UIImage *)gameLogoPlaceholderImage       {RETURN_IMAGE(@"gameLogoPlaceholderImage");}

/** tabbar */
+ (UIImage *)Tabbar_0_Normal                {RETURN_IMAGE(@"Tabbar_Game_Normal");}
+ (UIImage *)Tabbar_0_Select                {RETURN_IMAGE(@"Tabbar_Game_Select");}
+ (UIImage *)Tabbar_1_Normal                {RETURN_IMAGE(@"Tabbar_Server_Normal");}
+ (UIImage *)Tabbar_1_Select                {RETURN_IMAGE(@"Tabbar_Server_Select");}
+ (UIImage *)Tabbar_2_Normal                {RETURN_IMAGE(@"Tabbar_Station_Normal");}
+ (UIImage *)Tabbar_2_Select                {RETURN_IMAGE(@"Tabbar_Station_Select");}
+ (UIImage *)Tabbar_3_Normal                {RETURN_IMAGE(@"Tabbar_User_Normal");}
+ (UIImage *)Tabbar_3_Select                {RETURN_IMAGE(@"Tabbar_User_Select");}
+ (UIImage *)Tabbar_Center_button           {RETURN_IMAGE(@"Tabbar_Center_button");}
/** banner placeholder image */
+ (UIImage *)Basic_Banner_placeholder       {RETURN_IMAGE(@"Basic_Banner_placeholder");}

+ (UIImage *)Home_new_game                  {RETURN_IMAGE(@"Home_new_game");}
+ (UIImage *)Home_hight_vip                 {RETURN_IMAGE(@"Home_hight_vip");}
+ (UIImage *)Home_discount                  {RETURN_IMAGE(@"Home_discount");}
+ (UIImage *)Home_classify                  {RETURN_IMAGE(@"Home_classify");}
+ (UIImage *)Home_activity                  {RETURN_IMAGE(@"Home_activity");}
+ (UIImage *)Home_search_image              {RETURN_IMAGE(@"Home_search_image");}
+ (UIImage *)Home_message_light             {RETURN_IMAGE(@"Home_message_light");}
+ (UIImage *)Home_message_dark              {RETURN_IMAGE(@"Home_message_dark");}

#pragma mark - game view
+ (UIImage *)Game_header_background_image   {RETURN_IMAGE(@"Game_header_background_image");}
+ (UIImage *)Game_header_discount_iamge     {RETURN_IMAGE(@"Game_header_discount_image");}
+ (UIImage *)Game_header_stars_half         {RETURN_IMAGE(@"Game_header_stars_half");}
+ (UIImage *)Game_header_stars_light        {RETURN_IMAGE(@"Game_header_stars_light");}
+ (UIImage *)Game_header_stars_dark         {RETURN_IMAGE(@"Game_header_stars_dark");}
+ (UIImage *)Game_header_QQ                 {RETURN_IMAGE(@"Game_header_QQ");}
+ (UIImage *)Game_detail_header_placeholder {RETURN_IMAGE(@"Game_detail_header_placeholder");}
+ (UIImage *)Game_detail_footer_collection  {RETURN_IMAGE(@"Game_detail_footer_collection");}
+ (UIImage *)Game_detail_footer_nocollection{RETURN_IMAGE(@"Game_detail_footer_nocollection");}
+ (UIImage *)Game_detail_footer_comment     {RETURN_IMAGE(@"Game_detail_footer_comment");}

#pragma makr - mine view
+ (UIImage *)Mine_not_login_avatar          {RETURN_IMAGE(@"Mine_not_login_avatar");}
+ (UIImage *)Mine_setting_image             {RETURN_IMAGE(@"Mine_setting_image");}



@end














