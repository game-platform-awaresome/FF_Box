//
//  FFDrivePersonalHeader.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/30.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDynamicModel.h"

@interface FFDrivePersonalHeader : UIView

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSString *uid;
// nick name
@property (nonatomic, strong, readonly) NSString *nickName;

@property (nonatomic, strong) FFDynamicModel *model;

- (void)hideNickName:(BOOL)hide;

@end
