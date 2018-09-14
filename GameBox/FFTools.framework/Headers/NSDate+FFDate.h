//
//  NSDate+FFDate.h
//  FFTools
//
//  Created by Sans on 2018/8/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FFDate)

//Date format
/** yyyy-MM-dd */
- (NSString *)ff_ymdFormat;
+ (NSString *)ff_ymdFormat;
/** HH:mm:ss */
- (NSString *)ff_hmsFormat;
+ (NSString *)ff_hmsFormat;
/** yyyy-MM-dd HH:mm:ss */
- (NSString *)ff_ymdhmsFormat;
+ (NSString *)ff_ymdhmsFormat;

/**
 *  Convert date to string with format
 */
+ (NSString *)ff_stringWithDate:(NSDate *)ff_date format:(NSString *)ff_format;
- (NSString *)ff_stringWithFormat:(NSString *)ff_format;





@end
