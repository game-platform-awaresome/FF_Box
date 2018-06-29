//
//  FFDefaultWindow.m
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFDefaultWindow.h"

@implementation FFDefaultWindow

+ (FFDefaultWindow *)window {
    FFDefaultWindow *window = [[FFDefaultWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    window.rootViewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchSreen"];
//    [window.rootViewController setstatu] = YES;
    return window;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}





@end
