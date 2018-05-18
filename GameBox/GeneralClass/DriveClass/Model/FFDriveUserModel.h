//
//  FFDriveUserModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/31.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDriveUserModel : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *buid;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) id iconImage;
@property (nonatomic, strong) id iconImageData;


+ (instancetype)sharedModel;


@end
