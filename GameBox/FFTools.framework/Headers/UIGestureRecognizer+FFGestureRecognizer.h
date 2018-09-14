//
//  UIGestureRecognizer+FFGestureRecognizer.h
//  FFTools
//
//  Created by 燚 on 2018/9/3.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UIGestureRecognizer (FFGestureRecognizer)

/**
 *  Make all gestures support block callback.
 *  This will support all kinds of gestures.
 */
@property (nonatomic, copy) FFGestureBlock ff_onGesture;

/**
 *  Make tap gesture support block callback.
 */
@property (nonatomic, copy) FFTapGestureBlock ff_onTaped;

/**
 *  Make long press gesture support block callback.
 */
@property (nonatomic, copy) FFLongPressGestureBlock ff_onLongPressed;



@end
