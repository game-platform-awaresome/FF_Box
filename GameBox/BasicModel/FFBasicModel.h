//
//  FFBasicModel.h
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFNetWorkManager.h"

@interface FFBasicModel : NSObject


@property (nonatomic, assign) NSInteger currentPage;


/** 获取所有类的属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType;

/** 对类的所有属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict;







@end


















