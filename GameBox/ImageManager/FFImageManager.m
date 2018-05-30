//
//  FFImageManager.m
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFImageManager.h"

#define RETURN_IMAGE(name) return [UIImage imageNamed:name]

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
+ (UIImage *)General_back_black             {RETURN_IMAGE(@"General_back_black");}
+ (UIImage *)General_back_white             {RETURN_IMAGE(@"General_back_white");}


+ (UIImage *)Home_new_game                  {RETURN_IMAGE(@"Home_new_game");}
+ (UIImage *)Home_hight_vip                 {RETURN_IMAGE(@"Home_hight_vip");}
+ (UIImage *)Home_discount                  {RETURN_IMAGE(@"Home_discount");}
+ (UIImage *)Home_classify                  {RETURN_IMAGE(@"Home_classify");}
+ (UIImage *)Home_activity                  {RETURN_IMAGE(@"Home_activity");}
+ (UIImage *)Home_search_image              {RETURN_IMAGE(@"Home_search_image");}
+ (UIImage *)Home_message_light             {RETURN_IMAGE(@"Home_message_light");}
+ (UIImage *)Home_message_dark              {RETURN_IMAGE(@"Home_message_dark");}
+ (UIImage *)Home_mission_center_image      {RETURN_IMAGE(@"Home_mission_center_image");}

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
+ (UIImage *)Game_shared_image              {RETURN_IMAGE(@"Game_shared_image");}

#pragma makr - mine view
+ (UIImage *)Mine_not_login_avatar          {RETURN_IMAGE(@"Mine_not_login_avatar");}
+ (UIImage *)Mine_setting_image             {RETURN_IMAGE(@"Mine_setting_image");}
+ (UIImage *)Mine_about_us                  {RETURN_IMAGE(@"Mine_about_us");}
+ (UIImage *)Mine_activiity_center          {RETURN_IMAGE(@"Mine_activiity_center");}
+ (UIImage *)Mine_binding_phone             {RETURN_IMAGE(@"Mine_binding_phone");}
+ (UIImage *)Mine_collection                {RETURN_IMAGE(@"Mine_collection");}
+ (UIImage *)Mine_customer_service          {RETURN_IMAGE(@"Mine_customer_service");}
+ (UIImage *)Mine_everyday_comment          {RETURN_IMAGE(@"Mine_everyday_comment");}
+ (UIImage *)Mine_everyday_drive            {RETURN_IMAGE(@"Mine_everyday_drive");}
+ (UIImage *)Mine_flash_back                {RETURN_IMAGE(@"Mine_flash_back");}
+ (UIImage *)Mine_gold_exchange             {RETURN_IMAGE(@"Mine_gold_exchange");}
+ (UIImage *)Mine_gold_list                 {RETURN_IMAGE(@"Mine_gold_list");}
+ (UIImage *)Mine_gold_lottery              {RETURN_IMAGE(@"Mine_gold_lottery");};
+ (UIImage *)Mine_invite_firend             {RETURN_IMAGE(@"Mine_invite_firend");}
+ (UIImage *)Mine_invite_list               {RETURN_IMAGE(@"Mine_invite_list");}
+ (UIImage *)Mine_message                   {RETURN_IMAGE(@"Mine_message");}
+ (UIImage *)Mine_modify_password           {RETURN_IMAGE(@"Mine_modify_password");}
+ (UIImage *)MIne_package                   {RETURN_IMAGE(@"MIne_package");}
+ (UIImage *)Mine_platform_list             {RETURN_IMAGE(@"Mine_platform_list");}
+ (UIImage *)Mine_rebate_apply              {RETURN_IMAGE(@"Mine_rebate_apply");}
+ (UIImage *)Mine_sign_in                   {RETURN_IMAGE(@"Mine_sign_in");}
+ (UIImage *)Mine_transfer_game             {RETURN_IMAGE(@"Mine_transfer_game");}
+ (UIImage *)Mine_vip_no                    {RETURN_IMAGE(@"Mine_vip_no");}
+ (UIImage *)Mine_vip_yes                   {RETURN_IMAGE(@"Mine_vip_yes");}




#pragma mark - invite viwe
+ (UIImage *)InviteFriend_Background_image  {RETURN_IMAGE(@"InviteFriend_Background_image");}


#pragma mark - mission class
+ (UIImage *)Mission_header                 {RETURN_IMAGE(@"Mission_header");}
+ (UIImage *)Mission_comment                {RETURN_IMAGE(@"Mission_comment");}
+ (UIImage *)Mission_drive                  {RETURN_IMAGE(@"Mission_drive");}
+ (UIImage *)Mission_gold_exchange          {RETURN_IMAGE(@"Mission_gold_exchange");}
+ (UIImage *)Mission_gold_lottary           {RETURN_IMAGE(@"Mission_gold_lottary");};
+ (UIImage *)Mission_invite_list            {RETURN_IMAGE(@"Mission_invite_list");}
+ (UIImage *)Mission_invite                 {RETURN_IMAGE(@"Mission_invite");}
+ (UIImage *)Mission_sign_in                {RETURN_IMAGE(@"Mission_sign_in");}
+ (UIImage *)Mission_vip                    {RETURN_IMAGE(@"Mission_vip");}


#pragma makr - logo image
+ (UIImage *)logoImage                      {RETURN_IMAGE(@"Mine_logo_image");}


#pragma mark - drvie class
+ (UIImage *)Drive_like                     {RETURN_IMAGE(@"Drive_like");}
+ (UIImage *)Drive_unlike                   {RETURN_IMAGE(@"Drive_unLike");}
+ (UIImage *)Drive_shared                   {RETURN_IMAGE(@"Drive_shared");}
+ (UIImage *)Drive_comment                  {RETURN_IMAGE(@"Drive_comment");}
+ (UIImage *)Drive_commentlike              {RETURN_IMAGE(@"Drive_commentlike");}
+ (UIImage *)Drive_attention                {RETURN_IMAGE(@"Drive_attention");}
+ (UIImage *)Drive_attention_cancel         {RETURN_IMAGE(@"Drive_attention_cancel");}




@end














