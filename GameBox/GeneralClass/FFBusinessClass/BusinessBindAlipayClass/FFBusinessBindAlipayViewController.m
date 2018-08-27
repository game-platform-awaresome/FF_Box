//
//  FFBusinessBindAlipayViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBindAlipayViewController.h"
#import "FFBusinessModel.h"

@interface FFBusinessBindAlipayViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;


@end

@implementation FFBusinessBindAlipayViewController

- (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessBindAlipayViewController"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"编辑支付宝账号";
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;

    //    self.userNameTF;
    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.accountTF.frame.origin.x, CGRectGetMaxY(self.accountTF.frame), CGRectGetWidth(self.accountTF.frame), 0.5)]];

    //    self.nameTF;
    [self.view.layer addSublayer:[self creatLineWithFrame:CGRectMake(self.nameTF.frame.origin.x, CGRectGetMaxY(self.nameTF.frame), CGRectGetWidth(self.nameTF.frame), 0.5)]];

    self.bindButton.backgroundColor = [FFColorManager blue_dark];
    self.bindButton.layer.cornerRadius = self.bindButton.bounds.size.height / 2;
    self.bindButton.layer.masksToBounds = YES;
    [self.bindButton setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}


- (IBAction)respondsBindButton:(id)sender {
    if (self.accountTF.text.length < 1) {
        [UIAlertController showAlertMessage:@"请输入账号" dismissTime:0.7 dismissBlock:Nil];
        return;
    }

    if (self.nameTF.text.length < 1) {
        [UIAlertController showAlertMessage:@"请输入姓名" dismissTime:0.7 dismissBlock:Nil];
        return;
    }


    [self startWaiting];
    [FFBusinessModel editUserInfoWithQQ:nil AlipayAccount:self.accountTF.text Icon:nil Name:self.nameTF.text Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"alipay === %@",content);
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
            [UIAlertController showAlertMessage:@"绑定成功" dismissTime:0.7 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.accountTF resignFirstResponder];
}




@end





