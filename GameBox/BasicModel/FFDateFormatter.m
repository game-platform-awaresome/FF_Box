//
//  FFDateFormatter.m
//  GameBox
//
//  Created by 燚 on 2018/3/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFDateFormatter.h"

@implementation FFDateFormatter

+ (NSString *)dateStringWithDate:(NSDate *)date FormatterString:(NSString *)formatterString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = (formatterString && formatterString.length > 0) ? formatterString : @"YYYY-MM-dd HH:mm SSS";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)stringFromeDate:(NSDate *)date {
    return [self dateStringWithDate:date FormatterString:nil];
}

+ (NSDate *)dateWithDateString:(NSString *)string FormatterString:(NSString *)formatterString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = (formatterString && formatterString.length > 0) ? formatterString : @"YYYY-MM-dd HH:mm";
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateFromeString:(NSString *)string {
    return [self dateWithDateString:string FormatterString:nil];
}






@end
