//
//  FFBasicModel.m
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"
#import <objc/runtime.h>



@implementation FFBasicModel

/** 获取类的所有属性 */
+ (NSArray *)getAllPropertyWithClass:(id)classType {
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([classType class], &count);

    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count;  i++) {

        objc_property_t property = properties[i];

        const char *cName = property_getName(property);

        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];

        [mArray addObject:name];
    }
    return [mArray copy];
}

/** 对类的属性赋值 */
- (void)setAllPropertyWithDict:(NSDictionary *)dict {
    WeakSelf;

    NSArray *names = [FFBasicModel getAllPropertyWithClass:self];
    if (dict != nil && dict.count > 0) {
        NSArray *mapArray = [dict allKeys];
        syLog(@"inpute property count %ld",mapArray.count);
        syLog(@"original property count %ld",names.count);
        NSMutableSet *namesSet = [NSMutableSet setWithArray:names];
        NSMutableSet *mapSet = [NSMutableSet setWithArray:mapArray];
        NSString *className = NSStringFromClass([weakSelf class]);
        if (namesSet.count > mapSet.count) {
            [namesSet minusSet:mapSet];
            syLog(@"%@ 没有添加的属性 %@",className, namesSet);
        } else {
            [mapSet minusSet:namesSet];
            syLog(@"%@ 多余的属性 %@",className, mapSet);
        }
    }


    if (dict == nil) {
        for (NSString *name in names) {
            [weakSelf setValue:nil forKey:name];
        }
    } else {

        for (NSString *name in names) {
            //如果字典中的值为空，赋值可能会出问题
            if (!name) {
                continue;
            }

            if ([name isEqualToString:@"isLogin"]) {
//                [weakSelf setValue:@YES forKey:name];
                continue;
            }

            if ([name isEqualToString:@"uid"]) {
                [weakSelf setValue:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:name];
                continue;
            }

            if(dict[name]) {
                [weakSelf setValue:[NSString stringWithFormat:@"%@",dict[name]] forKey:name];
            }
        }
    }
}







@end

















