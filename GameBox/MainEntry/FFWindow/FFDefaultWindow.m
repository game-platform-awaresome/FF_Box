//
//  FFDefaultWindow.m
//  GameBox
//
//  Created by 燚 on 2018/6/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFDefaultWindow.h"

@implementation FFDefaultWindow

static FFDefaultWindow *window;
+ (FFDefaultWindow *)window {
    if (window) {
        return window;
    }
    window = [[FFDefaultWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    window.rootViewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchSreen"];
    return window;
}

+ (BOOL)resignWindow {
    [window resignKeyWindow];
    window = nil;
    if (window) {
        return YES;
    }
    return NO;
}





@end
