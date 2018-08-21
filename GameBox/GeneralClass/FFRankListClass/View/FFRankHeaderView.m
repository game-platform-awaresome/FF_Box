//
//  FFRankHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/8/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRankHeaderView.h"
#import <UIImageView+WebCache.h>
#import "FFColorManager.h"

#define Cell_width ((kScreenWidth - 30) / 3)

@interface FFRankHeaderView ()

@property (nonatomic, strong) UIImageView       *backgroundView;

/** 第一 */
@property (nonatomic, strong) UIView            *firstView;
@property (nonatomic, strong) UIImageView       *firstHeaderView;
@property (nonatomic, strong) UIImageView       *firstLogo;
@property (nonatomic, strong) UIImageView       *firstFooterView;
@property (nonatomic, strong) UILabel           *firstName;

/** 第二 */
@property (nonatomic, strong) UIView            *secondView;
@property (nonatomic, strong) UIImageView       *secondHeaderView;
@property (nonatomic, strong) UIImageView       *secondLogo;
@property (nonatomic, strong) UIImageView       *secondFooterView;
@property (nonatomic, strong) UILabel           *secondName;

/** 第三 */
@property (nonatomic, strong) UIView            *thirdView;
@property (nonatomic, strong) UIImageView       *thirdHeaderView;
@property (nonatomic, strong) UIImageView       *thirdLogo;
@property (nonatomic, strong) UIImageView       *thirdFooterView;
@property (nonatomic, strong) UILabel           *thirdName;

@property (nonatomic, strong) NSArray<UIImageView *>    *logoArray;
@property (nonatomic, strong) NSArray<UILabel *>        *nameArray;


@end



@implementation FFRankHeaderView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {

    //背景
    self.backgroundView = [UIImageView hyb_imageViewWithImage:@"Ranklist_header_background" superView:self constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self).offset(0);
        make.right.mas_equalTo(self).offset(0);
    }];

    //第一
    self.firstView = [UIView hyb_viewWithSuperView:self constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.center.mas_equalTo(0);
        make.bottom.mas_equalTo(self).offset(-10);
        make.width.mas_equalTo(Cell_width);
    } onTaped:^(UITapGestureRecognizer *sender) {
        [self respondsTo1st];
    }];
    [self addcornerRadius:self.firstView];

    self.firstHeaderView = [UIImageView hyb_imageViewWithImage:@"Ranklist_1st" superView:self.firstView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.firstView).offset(4);
        make.height.mas_equalTo(30);
    }];

    self.firstLogo = [UIImageView hyb_imageViewWithImage:@"" superView:self.firstView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.firstHeaderView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(Cell_width - 20, Cell_width - 20));
    }];

    self.firstFooterView = [UIImageView hyb_imageViewWithImage:@"Ranklist_1st_footer" superView:self.firstView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.firstLogo.mas_bottom).offset(0);
        make.height.mas_equalTo(25);
    }];

    self.firstName = [UILabel hyb_labelWithFont:15 superView:self.firstView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.firstView).offset(0);
        make.top.mas_equalTo(self.firstFooterView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.firstView).offset(0);
        make.right.mas_equalTo(self.firstView).offset(0);
    }];
    self.firstName.font = [UIFont boldSystemFontOfSize:17];
    self.firstName.textAlignment = NSTextAlignmentCenter;


    self.secondView = [UIView hyb_viewWithSuperView:self constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(35);
        make.right.mas_equalTo(self.firstView.mas_left).offset(-5);
        make.bottom.mas_equalTo(self).offset(-10);
        make.width.mas_equalTo(Cell_width);
    } onTaped:^(UITapGestureRecognizer *sender) {
        [self respondsTo2ec];
    }];
    [self addcornerRadius:self.secondView];

    self.secondHeaderView = [UIImageView hyb_imageViewWithImage:@"Ranklist_2ec" superView:self.secondView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.secondView).offset(4);
        make.height.mas_equalTo(30);
    }];

    self.secondLogo = [UIImageView hyb_imageViewWithImage:@"" superView:self.secondView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.secondHeaderView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(Cell_width - 30, Cell_width - 30));
    }];

    self.secondFooterView = [UIImageView hyb_imageViewWithImage:@"Ranklist_2ec_footer" superView:self.secondView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.secondLogo.mas_bottom).offset(0);
        make.height.mas_equalTo(25);
    }];

    self.secondName = [UILabel hyb_labelWithFont:15 superView:self.secondView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.secondView).offset(0);
        make.top.mas_equalTo(self.secondFooterView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.secondView).offset(0);
        make.right.mas_equalTo(self.secondView).offset(0);
    }];
    self.secondName.textAlignment = NSTextAlignmentCenter;


    self.thirdView = [UIView hyb_viewWithSuperView:self constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(35);
        make.left.mas_equalTo(self.firstView.mas_right).offset(5);
        make.bottom.mas_equalTo(self).offset(-10);
        make.width.mas_equalTo(Cell_width);
    } onTaped:^(UITapGestureRecognizer *sender) {
        [self respondsTo3rd];
    }];
    [self addcornerRadius:self.thirdView];


    self.thirdHeaderView = [UIImageView hyb_imageViewWithImage:@"Ranklist_3rd" superView:self.thirdView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.thirdView).offset(4);
        make.height.mas_equalTo(30);
    }];

    self.thirdLogo = [UIImageView hyb_imageViewWithImage:@"" superView:self.thirdView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.thirdHeaderView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(Cell_width - 30, Cell_width - 30));
    }];

    self.thirdFooterView = [UIImageView hyb_imageViewWithImage:@"Ranklist_3rd_footer" superView:self.thirdView constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.thirdLogo.mas_bottom).offset(0);
        make.height.mas_equalTo(25);
    }];

    self.thirdName = [UILabel hyb_labelWithFont:15 superView:self.thirdView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.thirdView).offset(0);
        make.top.mas_equalTo(self.thirdFooterView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.thirdView).offset(0);
        make.right.mas_equalTo(self.thirdView).offset(0);
    }];
    self.thirdName.textAlignment = NSTextAlignmentCenter;


    self.logoArray = @[self.firstLogo,self.secondLogo,self.thirdLogo];
    self.nameArray = @[self.firstName,self.secondName,self.thirdName];

    for (UILabel *label in self.nameArray) {
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [FFColorManager textColorMiddle];
    }
    self.firstName.font = [UIFont boldSystemFontOfSize:16];
}

- (void)addcornerRadius:(UIView *)view {
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
}


#pragma mark - responds
- (void)respondsTo1st {
    [self respondsTo:0];
}

- (void)respondsTo2ec {
    [self respondsTo:1];
}

- (void)respondsTo3rd {
    [self respondsTo:2];
}

- (void)respondsTo:(NSInteger)idx {
    if (self.clickGame) {
        self.clickGame(self.showArray[idx]);
    }
}


#pragma mark - setter
- (void)setShowArray:(NSArray *)showArray {
    _showArray = showArray;

    if (showArray.count == 3) {
        for (int i = 0; i < 3; i++) {
            //set game logo iamge view
            NSDictionary *dict = showArray[i];
            [self.logoArray[i] sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,dict[@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];

            self.nameArray[i].text = [NSString stringWithFormat:@"%@",dict[@"gamename"]];
        }


    }

}




@end








