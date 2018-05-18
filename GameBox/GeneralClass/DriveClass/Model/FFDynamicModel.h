//
//  FFDynamicModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/7.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFDynamicModel : NSObject

/** 动态 ID */
@property (nonatomic, strong) NSString *dynamic_id;
/** 动态时间 */
@property (nonatomic, strong) NSString *creat_time;
/** 动态内容 */
@property (nonatomic, strong) NSString *content;
/** 动态图片的 url */
@property (nonatomic, strong) NSArray<NSString *> *imageUrlStringArray;
@property (nonatomic, strong) NSArray<NSURL *> *imageUrlArray;
@property (nonatomic, strong) NSString *imageUrlString;
@property (nonatomic, strong) NSURL *imageUrl;

/** 发布动态的 uid */
@property (nonatomic, strong) NSString *present_user_uid;
/** 发布动态的昵称 */
@property (nonatomic, strong) NSString *present_user_nickName;
/** 发布动态的 头像 */
@property (nonatomic, strong) NSString *present_user_iconImageUrlString;
@property (nonatomic, strong) NSURL *present_user_iconImageUrl;
@property (nonatomic, strong) UIImage *present_user_iconImage;
/** 发布动态的性别 */
@property (nonatomic, strong) NSString *present_user_sex;
/** 发布动态的 vip */
@property (nonatomic, strong) NSString *present_user_vip;
/** 发布动态的 vip */
@property (nonatomic, assign) BOOL isVip;

/** 发布动态的老司机指数 */
@property (nonatomic, strong) NSString *present_user_driver_level;
/** 简介 */
@property (nonatomic, strong) NSString *present_user_desc;

/** 动态的赞数目 */
@property (nonatomic, strong) NSString *likes_number;
/** 动态的踩数目 */
@property (nonatomic, strong) NSString *dislikes_number;
/** 动态分享数目 */
@property (nonatomic, strong) NSString *shared_number;
/** 动态评论数目 */
@property (nonatomic, strong) NSString *comments_number;
/** 显示的两条的评论 */
@property (nonatomic, strong) NSArray *comments_Array;

/** 在或者踩 */
@property (nonatomic, strong) NSString *operate;
/** 是否有赞或者踩的操作 */
@property (nonatomic, assign) BOOL isOperate;
/** 用户是否点赞 */
@property (nonatomic, assign) BOOL isLike;
/** 用户是否点踩 */
@property (nonatomic, assign) BOOL isDislike;

/** 是否关注 */
@property (nonatomic, strong) NSString *attention;
@property (nonatomic, assign) BOOL isAttention;

/** 审核 */
@property (nonatomic, strong) NSString *verifyDynamics;
/** 显示审核标签 */
@property (nonatomic, assign) BOOL showVerifyDynamics;

/** 评级 */
@property (nonatomic, strong) NSString *ratings;
/** 小编点评 */
@property (nonatomic, strong) NSString *remark;

/** dataArray */
@property (nonatomic, strong) NSMutableArray<FFDynamicModel *> *dataArray;

/** 类方法 */
+ (FFDynamicModel *)modelWithDict:(NSDictionary *)dict;

/** 设置属性 */
- (void)setAllPropertyWihtDict:(NSDictionary *)dict;
/** 评论列表设置属性 */
- (void)setPropertyWithDetailCommentLishVeiwDictionary:(NSDictionary *)dict;
/** 用户详情页面的属性 */
- (void)setPropertyWithUserInfoViewDictionary:(NSDictionary *)dict;


- (NSMutableArray *)dataArrayWithArray:(NSArray *)array;
- (NSMutableArray *)dataArrayAddArray:(NSArray *)array;







@end
