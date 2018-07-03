//
//  FFWeViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import <WebKit/WebKit.h>

@interface FFWebViewController : FFBasicViewController

/**链接地址*/
@property (nonatomic, strong) NSString  *webURL;

/**web视图*/
@property (nonatomic, strong) WKWebView * webView;

@end
