//
//  FFBlockHeader.h
//  FFTools
//
//  Created by Sans on 2018/8/28.
//  Copyright © 2018年 Sans. All rights reserved.
//

#ifndef FFBlockHeader_h
#define FFBlockHeader_h

#import <UIKit/UIKit.h>

//#import "Masonry.h"
//#import "MASConstraintMaker.h"
@class MASConstraintMaker;



/**
 *  This is void block.
 */
typedef void(^FFVoidBlock)(void);

/**
 *  For return object value.
 */
typedef void(^FFObjectBlock)(id result);

/**
 *  For return string value.
 */
typedef void(^FFStringBlock)(NSString *result);

/**
 *  For return dictionary value.
 */
typedef void(^FFDictionaryBlock)(NSDictionary *content);

/**
 *  For return dictionary and message value
 */
typedef void(^FFDictionaryMessageBlock)(NSDictionary *content, NSString *msg);

/**
 *  For return dictionary and bool value
 */
typedef void(^FFDictionaryBoolBlock)(NSDictionary *content, BOOL success);

/**
 *  For return array value.
 */
typedef void(^FFArrayBlock)(NSArray *list);

/**
 *  For return array and messge value.
 */
typedef void(^FFArrayMessageBlock)(NSArray *list, NSString *msg);

/**
 *  For return array and bool value.
 */
typedef void(^FFArrayBoolBlock)(NSArray *list, BOOL success);

/**
 *  For return number block.
 */
typedef void(^FFNumberBlock)(NSNumber *number);

/**
 *  For retun int block.
 */
typedef void(^FFIntBlock)(int result);

/**
 *  For return button block.
 */
typedef void(^FFButtonBlock)(UIButton *sender);

/**
 *  For return Gesture block.
 */
typedef void(^FFGestureBlock)(UIGestureRecognizer *sender);

/**
 *  For return tap gesture block.
 */
typedef void(^FFTapGestureBlock)(UITapGestureRecognizer *sender);

/**
 *  For return long press gesture block.
 */
typedef void(^FFLongPressGestureBlock)(UILongPressGestureRecognizer *sender);

/**
 *  For return constraint maker block.
 */
typedef void(^FFConstraintMakerBlock)(MASConstraintMaker *make);


#endif /* FFBlockHeader_h */
























