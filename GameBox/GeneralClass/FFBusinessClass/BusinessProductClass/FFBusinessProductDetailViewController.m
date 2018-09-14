//
//  FFBusinessProductDetailViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessProductDetailViewController.h"

@interface FFBusinessProductDetailViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ProductDetailBlock block;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSString *content;

@end

@implementation FFBusinessProductDetailViewController

+ (instancetype)controllerWithContent:(NSString *)content CompletBlock:(ProductDetailBlock)block {
    FFBusinessProductDetailViewController *controller = [[FFBusinessProductDetailViewController alloc] init];
    controller.block = block;
    controller.content = [content isEqualToString:@"点击输入详情"] ? @"" : content;
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.sureButton];
    self.navigationItem.title = @"商品描述";
}

- (void)setContent:(NSString *)content {
    if (content && content.length > 0) {
        self.textView.text = content;
    }
}


#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, kNAVIGATION_HEIGHT + 10, kSCREEN_WIDTH - 20, kSCREEN_WIDTH * 0.6)];

        _textView.delegate = self;
        _textView.layer.cornerRadius = 8;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [FFColorManager view_separa_line_color].CGColor;
        _textView.layer.borderWidth  = 0.5;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.textColor = [FFColorManager textColorDark];
    }
    return _textView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton ff_buttonWithTitle:@"确定" SuperView:nil Constraints:nil TouchUp:^(UIButton *sender) {
            if (self.block) {
                self.block(self.textView.text);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        _sureButton.frame = CGRectMake(10, CGRectGetMaxY(self.textView.frame) + 10, kSCREEN_WIDTH - 20, 44);        [_sureButton setBackgroundColor:[FFColorManager blue_dark]];
        _sureButton.layer.cornerRadius = 22;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}






@end
