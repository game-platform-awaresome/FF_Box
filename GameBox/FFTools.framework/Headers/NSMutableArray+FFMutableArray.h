//
//  NSMutableArray+FFMutableArray.h
//  FFTools
//
//  Created by Sans on 2018/8/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (FFMutableArray)

/**
 *  Safa data
 */
- (BOOL)ff_addObject:(id)object;

- (BOOL)ff_insertObject:(id)object atIndex:(NSUInteger)index;

- (BOOL)ff_removeObjectAtIndex:(NSUInteger)index;

- (BOOL)ff_exchangeObjectFromIndex:(NSUInteger)fromIndex
                           ToIndex:(NSUInteger)toIndex;






@end
