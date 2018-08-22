//
//  FFPhotoViewController.m
//  GameBox
//
//  Created by 燚 on 2018/8/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFPhotoViewController.h"
#import "FFImageManager.h"
#import <FLAnimatedImageView+WebCache.h>
#import <FFTools/FFTools.h>

@interface FFPhotoViewController ()

@property (nonatomic, strong) id            info;

@property (nonatomic, strong) NSString      *imageUrlString;


@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) NSMutableArray<NSURL *>               *imageUrls;
@property (nonatomic, strong) NSMutableArray<FLAnimatedImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray<UIScrollView *>        *childScrollViews;



@end

@implementation FFPhotoViewController

+ (UINavigationController *)showPhotoWith:(id)info {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self controllerWith:info]];
//    [nav.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication].keyWindow.rootViewController showDetailViewController:nav sender:nil];
    return nav;
}

+ (FFPhotoViewController *)controllerWith:(id)info {
    FFPhotoViewController *controller = [FFPhotoViewController new];
    controller.info = info;
    return controller;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[FFImageManager General_back_white] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToLeftButton)];
    [self.navigationController.navigationBar setTintColor:kWhiteColor];
    self.navBarBGAlpha = @"0.1";

    self.scrollView = [UIScrollView hyb_scrollViewWithDelegate:self superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.left.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
    }];
    self.scrollView.backgroundColor = kBlackColor;
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {

    }

}

- (void)loadImageView {
    UIScrollView *lastScrollView;

    if (!self.scrollView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadImageView];
        });
        return;
    }

//    UIView* contentView = UIView.new;
//    contentView.backgroundColor = kBlueColor;
//    [self.scrollView addSubview:contentView];
//
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.height.equalTo(self.scrollView);
//    }];

    if (self.imageUrls.count) {
        
        for (NSURL *url in self.imageUrls) {

            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSCREEN_HEIGHT)];

            [self.scrollView addSubview:imageView];

            [imageView sd_setImageWithURL:url];
            imageView.contentMode = UIViewContentModeScaleAspectFit;

//            UIScrollView *scrollView = [UIScrollView hyb_scrollViewWithDelegate:self superView:contentView constraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(@0);
//                make.left.equalTo(lastScrollView ? lastScrollView.mas_right : @0);
//                make.width.equalTo(contentView.mas_width);
//                make.height.equalTo(contentView.mas_height);
//            }];
//
//            lastScrollView = scrollView;
//
//            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//            [scrollView addSubview:imageView];
//
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(scrollView);
//            }];
//
//            [imageView sd_setImageWithURL:url];
//            [imageView startAnimating];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [self.imageViews addObject:imageView];
//            [self.childScrollViews addObject:scrollView];

        }

//        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(lastScrollView.mas_right);
//        }];

        self.scrollView.contentSize = CGSizeMake(0, 0);


    } else {
        [self respondsToLeftButton];
    }
}

#pragma mark - responds
- (void)respondsToLeftButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - setter
- (void)setInfo:(id)info {

    [self.imageUrls removeAllObjects];
    [self.imageViews removeAllObjects];
    [self.childScrollViews removeAllObjects];

    if ([info isKindOfClass:[NSString class]]) {
        self.imageUrlString = info;
    } else {
        [self respondsToLeftButton];
    }
}

- (void)setImageUrlString:(NSString *)imageUrlString {
    _imageUrlString = imageUrlString;
    [self.imageUrls addObject:[NSURL URLWithString:_imageUrlString]];
    [self loadImageView];
}



#pragma mark - getter
- (NSMutableArray<NSURL *> *)imageUrls {
    if (!_imageUrls) {
        _imageUrls = [NSMutableArray array];
    }
    return _imageUrls;
}

- (NSMutableArray<FLAnimatedImageView *> *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}


@end
