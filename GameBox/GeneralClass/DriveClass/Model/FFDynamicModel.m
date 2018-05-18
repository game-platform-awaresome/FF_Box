//
//  FFDynamicModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/7.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDynamicModel.h"
#import "SYKeychain.h"
#import "UIImage+MultiFormat.h"

@implementation FFDynamicModel

/** 类方法 */
+ (FFDynamicModel *)modelWithDict:(NSDictionary *)dict {
    FFDynamicModel *model = [[FFDynamicModel alloc] init];
    [model setAllPropertyWihtDict:dict];
    return model;
}

/** 设置属性 */
- (void)setAllPropertyWihtDict:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }

//    syLog(@"set dict == %@",dict);
    NSDictionary *dynamics = dict[@"dynamics"];
    if (dynamics != nil) {
        [self setPropertyWithDynamics:dynamics];
    }

    NSDictionary *userInfo = dict[@"user"];
    if (userInfo != nil) {
        [self setPropertyWithUserInfo:userInfo];
        return;
    }
}


/** 初始化 dataarray */
- (NSMutableArray *)dataArrayWithArray:(NSArray *)array {
    if (array == nil) {
        return nil;
    }
    _dataArray = nil;
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray addObject:[FFDynamicModel modelWithDict:obj]];
    }];
    return self.dataArray;
}

- (NSMutableArray *)dataArrayAddArray:(NSArray *)array {
    if (array == nil) {
        return self.dataArray;
    }
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray addObject:[FFDynamicModel modelWithDict:obj]];
    }];
    return self.dataArray;
}

#pragma mark - setter
- (void)setPropertyWithDynamics:(NSDictionary *)dynamics {
    if (dynamics == nil) {
        return;
    }
    self.dynamic_id = dynamics[@"id"];
    self.present_user_uid = dynamics[@"uid"];
    self.comments_number = dynamics[@"comment"];
    self.content = dynamics[@"content"];
    self.creat_time = dynamics[@"create_time"];
    self.likes_number = dynamics[@"likes"];
    self.dislikes_number = dynamics[@"dislike"];
    self.shared_number = dynamics[@"share"];
    self.imageUrlStringArray = dynamics[@"imgs"];
    self.comments_Array = dynamics[@"comment_info"];
    self.verifyDynamics = dynamics[@"status"];
    self.ratings = [NSString stringWithFormat:@"%@",dynamics[@"level"]];
    self.remark = [NSString stringWithFormat:@"%@",dynamics[@"remark"]];
//     syLog(@"uid === %@",self.verifyDynamics);
}

- (void)setPropertyWithUserInfo:(NSDictionary *)userInfo {
    if (userInfo == nil) {
        return;
    }
    self.present_user_iconImageUrlString = userInfo[@"icon_url"];
    self.present_user_nickName = userInfo[@"nick_name"];
    self.present_user_sex = userInfo[@"sex"];
    self.present_user_vip = userInfo[@"vip"];
    self.operate = userInfo[@"operate"];
    self.attention = userInfo[@"follow"];
}

- (void)setPropertyWithDetailCommentLishVeiwDictionary:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }
    self.comments_number = dict[@"comment"];
    self.content = dict[@"content"];
    [self setCreat_time:dict[@"create_time"]];
    [self setDislikes_number:dict[@"dislike"]];
    self.present_user_iconImageUrlString = dict[@"icon_url"];
    self.dynamic_id = dict[@"id"];
    self.imageUrlStringArray = dict[@"imgs"];
    self.attention = dict[@"is_follow"];
    self.likes_number = dict[@"likes"];
    self.present_user_nickName = dict[@"nick_name"];
    self.operate = dict[@"operate"];
    self.present_user_sex = dict[@"sex"];
    self.shared_number = dict[@"share"];
    self.present_user_uid = dict[@"uid"];
    self.present_user_vip = dict[@"vip"];
    syLog(@"uid ======== %@",self.present_user_uid);
}

- (void)setPropertyWithUserInfoViewDictionary:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }
    self.present_user_desc = dict[@"desc"];
    self.present_user_driver_level = dict[@"driver_level"];
    self.present_user_iconImageUrlString = dict[@"icon_url"];
    self.present_user_nickName = dict[@"nick_name"];
    self.present_user_vip = dict[@"vip"];
    self.present_user_sex = dict[@"sex"];
    self.isAttention = dict[@"is_follow"];
}

/** 动态 ID */
- (void)setDynamic_id:(NSString *)dynamic_id {
    _dynamic_id = dynamic_id;
}

/** 设置时间 */
- (void)setCreat_time:(NSString *)creat_time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:creat_time.integerValue];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    _creat_time = [formatter stringFromDate:date];
}

/** 设置动态图片 array */
- (void)setImageUrlStringArray:(NSArray<NSString *> *)imageUrlStringArray {
    if ([imageUrlStringArray isKindOfClass:[NSArray class]]) {
        _imageUrlStringArray = imageUrlStringArray;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:imageUrlStringArray.count];
        [imageUrlStringArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[NSURL URLWithString:obj]];
        }];
        self.imageUrlArray = array;
    } else {
        _imageUrlStringArray = nil;
    }
}

- (void)setPresent_user_uid:(NSString *)present_user_uid {
    if (present_user_uid == nil) {
        return;
    }
    _present_user_uid = present_user_uid;
}
/** 设置 vip */
- (void)setPresent_user_vip:(NSString *)present_user_vip {
    _present_user_vip = [NSString stringWithFormat:@"%@",present_user_vip];
    _isVip = _present_user_vip.boolValue;
}

/** 是否赞或者踩 */
- (void)setOperate:(NSString *)operate {
    NSString *string = [NSString stringWithFormat:@"%@",operate];
    _operate = operate;
    if ([string isEqualToString:@"2"]) {
        _isLike = NO;
        _isDislike = NO;
        _isOperate = NO;
    } else if ([string isEqualToString:@"1"]) {
        _isLike = YES;
        _isDislike = NO;
        _isOperate = YES;
    } else if ([string isEqualToString:@"0"]) {
        _isLike = NO;
        _isDislike = YES;
        _isOperate = YES;
    }
}

- (void)setPresent_user_iconImageUrlString:(NSString *)present_user_iconImageUrlString {
    _present_user_iconImageUrlString = present_user_iconImageUrlString;
    self.present_user_iconImageUrl = [NSURL URLWithString:_present_user_iconImageUrlString];
}


- (void)setAttention:(NSString *)attention {
    _attention = attention;
    syLog(@"attention === %@",attention);
}


#pragma mark - getter
- (NSMutableArray<FFDynamicModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
