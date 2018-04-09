//
//  FFCustomeTabBar.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFCustomizeTabBar.h"

@interface FFCustomizeTabBar()



@end


@implementation FFCustomizeTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeUserInterface];
        [self initializeDataSource];
    }
    return self;
}

- (void)initializeUserInterface {
    [self addSubview:self.centerBtn];
    self.layer.masksToBounds = NO;
}

- (void)initializeDataSource {

}

- (void)clickCenterBtn:(UIButton *)sender {
    if (self.customizeDelegate && [self.customizeDelegate respondsToSelector:@selector(CustomizeTabBar:didSelectCenterButton:)]) {
        [self.customizeDelegate CustomizeTabBar:self didSelectCenterButton:sender];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.clipsToBounds || self.hidden || (self.alpha == 0.f)) {
        return nil;
    }
    UIView *result = [super hitTest:point withEvent:event];
    // 如果事件发生在 tabbar 里面直接返回
    if (result) {
        return result;
    }
    // 这里遍历那些超出的部分就可以了，不过这么写比较通用。
    for (UIView *subview in self.subviews) {
        // 把这个坐标从tabbar的坐标系转为 subview 的坐标系
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        // 如果事件发生在 subView 里就返回
        if (result) {
            return result;
        }
    }
    return nil;
}



- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat barHeight = self.bounds.size.height;

    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.center = CGPointMake(kSCREEN_WIDTH / 2, barHeight - view.frame.size.height / 2 - 5);
        } else if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonArray addObject:view];
        }
    }

    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = 0;
        if (idx < 2) {
            index = idx;
        } else {
            index = idx + 1;
        }

        obj.frame = CGRectMake(kSCREEN_WIDTH / 5 * index, 0, kSCREEN_WIDTH / 5, barHeight);
    }];

    // 把中间按钮带到视图最前面
    [self bringSubviewToFront:self.centerBtn];
}



#pragma mark - getter
- (UIButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_centerBtn setImage:[UIImage imageNamed:@"tabBar_CenterButton"] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(clickCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
#ifdef DEBUG
        //        _centerBtn.backgroundColor = [UIColor orangeColor];
#endif
    }
    return _centerBtn;
}





@end
