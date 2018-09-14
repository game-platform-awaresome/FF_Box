//
//  NSObject+FFObject.h
//  FFTools
//
//  Created by 燚 on 2018/8/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FFObject)

+ (instancetype)ff_instancetype;

/**
 *  Get name of current object's class.
 */
- (NSString *)ff_className;


#pragma mark - Json to data and data to json
/**
 *  Transform an object to json data.
 */
+ (NSMutableData *)ff_toJsonDataWithObject:(id)object;

/**
 *  Transform self to json data.
 */
- (NSMutableData *)ff_toJsonData;

/**
 *  Transform an object to json string.
 */
+ (NSString *)ff_toJsonStringWIthObject:(id)object;

/**
 *  Transform self to json string.
 */
- (NSString *)ff_toJsonString;



- (BOOL)isNull;




@end








