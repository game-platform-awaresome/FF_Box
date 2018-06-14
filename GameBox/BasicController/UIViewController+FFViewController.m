//
//  UIViewController+FFViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "UIViewController+FFViewController.h"
#import <objc/runtime.h>


@implementation UIViewController (FFViewController)

#pragma responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToRightButton {

}

#pragma mark -
- (void)setLeftButton:(UIBarButtonItem *)leftButton {
    objc_setAssociatedObject(self, @selector(leftButton), leftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)leftButton {
    UIBarButtonItem *button = objc_getAssociatedObject(self, @selector(leftButton));
    if (button) {
        return button;
    } else {
        button = [[UIBarButtonItem alloc] init];
        [button setTarget:self];
        [button setAction:@selector(respondsToLeftButton)];
        objc_setAssociatedObject(self, @selector(leftButton), button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return button;
    }
}

- (void)setRightButton:(UIBarButtonItem *)rightButton {
    objc_setAssociatedObject(self, @selector(rightButton), rightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBarButtonItem *)rightButton {
    UIBarButtonItem *button = objc_getAssociatedObject(self, @selector(rightButton));
    if (button) {
        return button;
    } else {
        button = [[UIBarButtonItem alloc] init];
        [button setTarget:self];
        [button setAction:@selector(respondsToRightButton)];
        objc_setAssociatedObject(self, @selector(rightButton), button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return button;
    }
}










@end


