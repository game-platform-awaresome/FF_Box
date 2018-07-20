//
//  FFImageManager.h
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//


/**

 这个页面工作量有点大, 也有点繁琐, app还会时不时的要求动态修改页面.
 所以这么个管理类是想的以后可以动态修改图标或者图片. 有点类似更换皮肤 .
 因为时间赶的急,所以暂时想的这个点子预留, 感觉有很多不足的地方.

 */






#import <UIKit/UIKit.h>


@interface FFImageManager : NSObject

/** game logo placeholder image */
+(UIImage *)gameLogoPlaceholderImage;

/** tabbar */
+ (UIImage *)Tabbar_0_Normal;
+ (UIImage *)Tabbar_0_Select;
+ (UIImage *)Tabbar_1_Normal;
+ (UIImage *)Tabbar_1_Select;
+ (UIImage *)Tabbar_2_Normal;
+ (UIImage *)Tabbar_2_Select;
+ (UIImage *)Tabbar_3_Normal;
+ (UIImage *)Tabbar_3_Select;
+ (UIImage *)Tabbar_4_Normal;
+ (UIImage *)Tabbar_4_Select;
+ (UIImage *)Tabbar_Center_button;

/** banner placeholder image */
+ (UIImage *)Basic_Banner_placeholder;
+ (UIImage *)General_back_black;
+ (UIImage *)General_back_white;

/** home view image */
+ (UIImage *)Home_new_game;
+ (UIImage *)Home_hight_vip;
+ (UIImage *)Home_discount;
+ (UIImage *)Home_classify;
+ (UIImage *)Home_activity;
+ (UIImage *)Home_search_image;
+ (UIImage *)Home_message_light;
+ (UIImage *)Home_message_dark;
+ (UIImage *)Home_mission_center_image;
+ (UIImage *)Home_earn_gold;

#pragma mark - game view
+ (UIImage *)Game_header_background_image;
+ (UIImage *)Game_header_discount_iamge;
+ (UIImage *)Game_header_stars_half;
+ (UIImage *)Game_header_stars_light;
+ (UIImage *)Game_header_stars_dark;
+ (UIImage *)Game_header_QQ;
+ (UIImage *)Game_detail_header_placeholder;
+ (UIImage *)Game_detail_footer_collection;
+ (UIImage *)Game_detail_footer_nocollection;
+ (UIImage *)Game_detail_footer_comment;
+ (UIImage *)Game_shared_image;

#pragma makr - mine view
+ (UIImage *)Mine_not_login_avatar;
+ (UIImage *)Mine_setting_image;
+ (UIImage *)Mine_about_us;
+ (UIImage *)Mine_activiity_center;
+ (UIImage *)Mine_binding_phone;
+ (UIImage *)Mine_collection;
+ (UIImage *)Mine_customer_service;
+ (UIImage *)Mine_everyday_comment;
+ (UIImage *)Mine_everyday_drive;
+ (UIImage *)Mine_flash_back;
+ (UIImage *)Mine_gold_exchange;
+ (UIImage *)Mine_gold_list;
+ (UIImage *)Mine_gold_lottery;
+ (UIImage *)Mine_invite_firend;
+ (UIImage *)Mine_invite_list;
+ (UIImage *)Mine_message;
+ (UIImage *)Mine_modify_password;
+ (UIImage *)MIne_package;
+ (UIImage *)Mine_platform_list;
+ (UIImage *)Mine_rebate_apply;
+ (UIImage *)Mine_sign_in;
+ (UIImage *)Mine_transfer_game;
+ (UIImage *)Mine_vip_no;
+ (UIImage *)Mine_vip_yes;
+ (UIImage *)Mine_avatar_not_login;

#pragma mark - invite viwe
+ (UIImage *)InviteFriend_Background_image;



#pragma mark - mission class
+ (UIImage *)Mission_header;
+ (UIImage *)Mission_comment;
+ (UIImage *)Mission_drive;
+ (UIImage *)Mission_gold_exchange;
+ (UIImage *)Mission_gold_lottary;
+ (UIImage *)Mission_invite_list;
+ (UIImage *)Mission_invite;
+ (UIImage *)Mission_sign_in;
+ (UIImage *)Mission_vip;


#pragma mark - logo
+ (UIImage *)logoImage;


#pragma mark - drvie class
+ (UIImage *)Drive_like;
+ (UIImage *)Drive_unlike;
+ (UIImage *)Drive_shared;
+ (UIImage *)Drive_comment;
+ (UIImage *)Drive_commentlike;
+ (UIImage *)Drive_attention;
+ (UIImage *)Drive_attention_cancel;

@end










