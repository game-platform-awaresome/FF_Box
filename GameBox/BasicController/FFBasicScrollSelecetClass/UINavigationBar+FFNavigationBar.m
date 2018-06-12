//
//  UINavigationBar+FFNavigationBar.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "UINavigationBar+FFNavigationBar.h"
#import <objc/runtime.h>

@implementation UINavigationBar (FFNavigationBar)


- (void)setLineLayer:(CALayer *)lineLayer {
    CALayer *layer = objc_getAssociatedObject(self, @selector(lineLayer));
    if (layer) {
        [layer removeFromSuperlayer];
    }
    [self setShadowImage:[UIImage new]];
    objc_setAssociatedObject(self, @selector(lineLayer),lineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.layer addSublayer:lineLayer];
}

- (CALayer *)lineLayer {
    return objc_getAssociatedObject(self, @selector(lineLayer));
}





@end
