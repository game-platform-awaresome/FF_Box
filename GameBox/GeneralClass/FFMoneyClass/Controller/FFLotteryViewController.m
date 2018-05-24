//
//  FFLotteryViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFLotteryViewController.h"
#import <WebKit/WebKit.h>
#import "SYKeychain.h"
#import "FFMyPrizeViewController.h"

@interface FFLotteryViewController ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,WKUIDelegate,UIScrollViewDelegate>

/**web视图*/
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) WKWebViewConfiguration *webConfig;

/** 进度条 */
@property (nonatomic, strong) UIImageView *progressView;

/** 无法加载页面 */
@property (nonatomic, strong) UIImageView *ImageBackView;

/** 我的奖品 */
@property (nonatomic, strong) FFMyPrizeViewController *myPrizeViewController;

@end

@implementation FFLotteryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"抽奖";
    [self.view addSubview:self.webView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setWebURL:[NSString stringWithFormat:@"http://api.185sy.com/index.php?g=api&m=luckydraw&a=show&uid=%@",SSKEYCHAIN_UID]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的奖品" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];
}

- (void)respondsToRightButton {
    HIDE_PARNENT_TABBAR;
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.myPrizeViewController animated:YES];
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
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - web view delegate
// API是根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURLRequest * request = navigationAction.request;

    NSURL * url = [request URL];
    syLog(@"url === %@", url);

    WKNavigationActionPolicy  actionPolicy = WKNavigationActionPolicyAllow;
    if ([[url scheme] isEqualToString:@"weixin"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {

        }
    }

    if ([[url scheme] isEqualToString:@"alipays"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {

        }
    }

    if ([[url scheme] isEqualToString:@"alert"]) {

    }
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

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView removeFromSuperview];
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma makr - getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT)];

        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;


        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    }
    return _webView;
}

- (UIImageView *)progressView {
    if (!_progressView) {
        _progressView = [[UIImageView alloc] init];
        _progressView.backgroundColor = RGBCOLOR(111, 177, 218);
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

- (FFMyPrizeViewController *)myPrizeViewController {
    if (!_myPrizeViewController) {
        _myPrizeViewController = [[FFMyPrizeViewController alloc] init];
    }
    return _myPrizeViewController;
}



@end
