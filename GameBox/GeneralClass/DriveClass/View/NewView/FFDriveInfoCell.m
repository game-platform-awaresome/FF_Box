//
//  FFDriveInfoCell.m
//  GameBox
//
//  Created by 燚 on 2018/8/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFDriveInfoCell.h"
#import <FLAnimatedImageView+WebCache.h>
#import <UIImageView+WebCache.h>

#import "FFDynamicModel.h"

#define Image_height ((kScreenWidth - 50) / 4)

@interface FFDriveInfoCell()

@property (nonatomic, strong) NSArray<FLAnimatedImageView *>    *imageViews;

@end


@implementation FFDriveInfoCell {
    NSDictionary *__dict;
}

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)initUserInterface {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    FLAnimatedImageView *lastView;
    for (int i = 0; i < 4; i++) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(10);
            } else {
                make.left.mas_equalTo(self.contentView).offset(10);
            }
            make.top.mas_equalTo(self.contentView).offset(10);
            make.bottom.mas_equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(Image_height);
            make.height.mas_equalTo(Image_height);

            if (i == 3) {
                make.right.mas_equalTo(self.contentView).offset(-10);
            }
        }];
        [array addObject:imageView];
    }
    self.imageViews = array;
}

#pragma makr - setter
- (void)setDict:(NSDictionary *)dict {
//    __dict = dict;

    if ([dict isKindOfClass:NSClassFromString(@"FFDynamicModel")]) {
        FFDynamicModel *model = (FFDynamicModel *)dict;
//        NSDictionary *dynamic = dict[@"dynamics"];
//        NSDictionary *userInfo = dict[@"user"];

//        NSArray *imags = dynamic[@"imgs"];
        [self setImages:model.imageUrlStringArray];
    }

}



- (void)setImages:(NSArray *)images {
    if ([images isKindOfClass:[NSArray class]] && images.count > 0 && images.count < self.imageViews.count) {
        int i = 0;
        for (; i < images.count; i++) {
            FLAnimatedImageView *imageView = self.imageViews[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(Image_height);
            }];
            imageView.hidden = NO;
        }
        for (; i < self.imageViews.count; i++) {
            FLAnimatedImageView *imageView = self.imageViews[i];
            imageView.hidden = YES;
        }

    } else {
        for (UIImageView *imageView in self.imageViews) {
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            imageView.hidden = YES;
        }
    }
}







@end







