//
//  FFPostStatusModel.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/9.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFPostStatusModel.h"
#import "FFDriveModel.h"
#import <UIKit/UIKit.h>

static FFPostStatusModel *model = nil;

@implementation FFPostStatusModel

+ (instancetype)sharedModel {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil) {
            model = [[FFPostStatusModel alloc] init];
        }
    });
    return model;
}


- (void)userUploadPortraitWithContent:(NSString *)text Image:(NSArray *)array {
    WeakSelf;
    START_NET_WORK;
    [FFDriveModel userUploadPortraitWithContent:text Image:array Completion:^(NSDictionary *content, BOOL success) {
        STOP_NET_WORK;
        if (weakSelf.callBackBlock) {
            weakSelf.callBackBlock(content, success);
        }
    }];
}





@end
