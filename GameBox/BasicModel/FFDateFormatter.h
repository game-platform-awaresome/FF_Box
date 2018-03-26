//
//  FFDateFormatter.h
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFDateFormatter : NSObject

/**
 *  @para   date
 *  @para   formatterString -> defaule : YYYY-MM-dd HH:mm SSS
 */
+ (NSString *)dateStringWithDate:(NSDate *)date
                 FormatterString:(NSString *)formatterString;

/** formatter :  YYYY-MM-dd HH:mm SSS */
+ (NSString *)stringFromeDate:(NSDate *)date;

/**
 *  @para   date
 *  @para   formatterString -> defaule : YYYY-MM-dd HH:mm
 */
+ (NSDate *)dateWithDateString:(NSString *)string
               FormatterString:(NSString *)formatterString;

/** formatter :  YYYY-MM-dd HH:mm */
+ (NSDate *)dateFromeString:(NSString *)string;



@end
