//
//  FFMainWindow.h
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMainWindow : UIWindow

/** 单利 */
+ (FFMainWindow *)sharedWindow;

/** 显示主界面 */
+ (BOOL)showWindowWithOriWindw:(UIWindow *)oriWindow;






@end
