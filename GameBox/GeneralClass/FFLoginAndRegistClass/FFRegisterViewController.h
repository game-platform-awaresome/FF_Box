//
//  FFRegisterViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicViewController.h"

typedef void(^RegistCompletionBlock)(NSString *username, NSString *password);

@interface FFRegisterViewController : FFBasicViewController

@property (nonatomic, strong) RegistCompletionBlock registCompletionBlcok;


@end
