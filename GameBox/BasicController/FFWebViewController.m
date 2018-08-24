//
//  FFWebViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFWebViewController.h"
#import "FFColorManager.h"
#import <FFTools/FFTools.h>

@interface FFWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>

///**web视图*/
//@property (nonatomic, strong) WKWebView * webView;

/** 进度条 */
@property (nonatomic, strong) UIImageView *progressView;

/** 无法加载页面 */
@property (nonatomic, strong) UIImageView *ImageBackView;

@end

@implementation FFWebViewController

- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";

    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    self.navBarBGAlpha = @"1.0";
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)setWebURL:(NSString *)webURL {
    _webURL = webURL;
    [self.ImageBackView removeFromSuperview];
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    url = [NSURL URLWithString:webURL];
    request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.progressView];
    [self startWaiting];
}


#pragma mark - web view delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}


- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    [webView loadRequest:navigationAction.request];

    return nil;
}

// API是根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    WKNavigationActionPolicy  actionPolicy = WKNavigationActionPolicyAllow;
    NSURLRequest * request = navigationAction.request;
    NSURL * url = [request URL];
    syLog(@"url === %@", url);

    !([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]) ? [[UIApplication sharedApplication] openURL:url] : 0;

    decisionHandler(actionPolicy);
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.progressView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 3);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        NSString *new = change[@"new"];
        self.progressView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * new.floatValue * 2, 3);

        if(_webView.estimatedProgress >= 1.0f) {
            

            self.progressView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 2, 3);

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopWaiting];
                [self.progressView removeFromSuperview];
            });

        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        [self stopWaiting];
    }

}



#pragma makr - getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    }
    return _webView;
}

- (UIImageView *)progressView {
    if (!_progressView) {
        //        _progressView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webView_progress"]];

        _progressView = [[UIImageView alloc] init];
        _progressView.backgroundColor = [FFColorManager web_waitng_color];
        _progressView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 3);
    }
    return _progressView;
}

- (UIImageView *)ImageBackView {
    if (!_ImageBackView) {
        _ImageBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _ImageBackView.image = [UIImage imageNamed:@"wuwangluo"];
    }
    return _ImageBackView;
}



- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}

// ================
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //页面加载失败
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"页面加载失败,请检查网络" preferredStyle:UIAlertControllerStyleAlert];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
    [self.view addSubview:self.ImageBackView];

}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end












