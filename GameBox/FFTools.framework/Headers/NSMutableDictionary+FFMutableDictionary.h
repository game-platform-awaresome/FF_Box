//
//  NSMutableDictionary+FFMutableDictionary.h
//  FFTools
//
//  Created by Sans on 2018/8/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (FFMutableDictionary)


- (BOOL)ff_setObject:(id)object forKey:(id<NSCopying>)key;


- (BOOL)ff_setValue:(id)value forKey:(NSString *)key;


@end
