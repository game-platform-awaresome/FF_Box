//
//  FFDriveUserModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/31.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveUserModel.h"
#import "SYKeychain.h"


static FFDriveUserModel *model = nil;
@implementation FFDriveUserModel

/** 单利 */
+ (instancetype)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFDriveUserModel alloc] init];
        }
    });
    return model;
}

@synthesize uid = _uid;
@synthesize buid = _buid;
#pragma mark - setter


#pragma mark - getter
- (NSString *)uid {
    return SSKEYCHAIN_UID;
}





@end
