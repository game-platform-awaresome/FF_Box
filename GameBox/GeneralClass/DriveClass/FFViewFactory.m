//
//  FFViewFactory.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFViewFactory.h"

@implementation FFViewFactory

+ (UITableView *)creatTableView:(UITableView *)tablView WithFrame:(CGRect)frame WithDelegate:(id)delegate {
    
    tablView = [[UITableView alloc] initWithFrame:frame style:(UITableViewStylePlain)];

    tablView.dataSource = delegate;
    tablView.delegate = delegate;

    tablView.showsVerticalScrollIndicator = NO;
    tablView.showsHorizontalScrollIndicator = NO;


    tablView.tableFooterView = [UIView new];

    if (@available(iOS 11.0, *)) {

        tablView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;

    } else {
 
    }


    return tablView;
}

+ (MJRefreshNormalHeader *)customRefreshHeaderWithTableView:(UITableView *)tableView WithTarget:(id)target {

    MJRefreshNormalHeader *customRefreshHeader = [[MJRefreshNormalHeader alloc] init];
    [customRefreshHeader setRefreshingTarget:target];

    //自动更改透明度
    tableView.mj_header.automaticallyChangeAlpha = YES;

    tableView.mj_header = customRefreshHeader;

    [customRefreshHeader setTitle:@"数据已加载" forState:MJRefreshStateIdle];
    [customRefreshHeader setTitle:@"刷新数据" forState:MJRefreshStatePulling];
    [customRefreshHeader setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    [customRefreshHeader setTitle:@"即将刷新" forState:MJRefreshStateWillRefresh];
    [customRefreshHeader setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];

    [customRefreshHeader.lastUpdatedTimeLabel setText:@"0"];

    return customRefreshHeader;
}


/** 显示提示 */
+ (void)showAlertMessage:(NSString *)message dismissTime:(float)second dismiss:(void (^)(void))dismiss  {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleAlert];

    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;

    [vc presentViewController:alertController animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}


/** 加载动画 */
+ (void)startWaitAnimation {
    if (_animationBack == nil) {
        [[FFViewFactory animationBack] makeKeyAndVisible];
        [_animationView startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [FFViewFactory stopWaitAnimation];
    }
}

/** 停止加载动画 */
+ (void)stopWaitAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_animationBack resignKeyWindow];
        _animationBack = nil;
        _animationView = nil;
    });
}


//动画背景
static UIWindow *_animationBack = nil;
+ (UIWindow *)animationBack {
    if (!_animationBack) {
        _animationBack = [[UIWindow alloc] init];
        _animationBack.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _animationBack.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
        _animationBack.rootViewController = [UIViewController new];
        [_animationBack addSubview:[FFViewFactory animationView]];
    }
    return _animationBack;
}

static UIImageView *_animationView = nil;
+ (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] init];
        _animationView.bounds = CGRectMake(0, 0, 44, 44);
        _animationView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);

        NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];

        for (NSInteger i = 1; i <= 12; i++) {

            NSString *str = [NSString stringWithFormat:@"downLoadin_%ld",i];

            UIImage *image = [UIImage imageNamed:str];
            if (image) {

                [imageArray addObject:image];
            }
        }

//        _animationView.backgroundColor = [UIColor blackColor];
        _animationView.animationImages = imageArray;
        _animationView.animationDuration = 0.8;
        _animationView.animationRepeatCount = 1111111;
    }
    return _animationView;
}




@end










