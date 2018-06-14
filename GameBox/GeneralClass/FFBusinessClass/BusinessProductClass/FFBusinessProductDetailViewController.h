//
//  FFBusinessProductDetailViewController.h
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"

typedef void(^ProductDetailBlock)(NSString *detailString);

@interface FFBusinessProductDetailViewController : FFBasicViewController


+ (instancetype)controllerWithCompletBlock:(ProductDetailBlock)block;




@end
