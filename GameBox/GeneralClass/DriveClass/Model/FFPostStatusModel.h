//
//  FFPostStatusModel.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/9.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PostStatusCallBackBlock)(NSDictionary *content,BOOL success);

@interface FFPostStatusModel : NSObject


@property (nonatomic, strong) PostStatusCallBackBlock callBackBlock;


+ (instancetype)sharedModel;

- (void)userUploadPortraitWithContent:(NSString *)text Image:(NSArray *)array;


@end
