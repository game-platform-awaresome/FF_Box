//
//  FFSRcommentCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFSRcommentCell.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import <UIImageView+WebCache.h>

#define ITEM_SIZE CGSizeMake(60, 120)

#ifndef DEBUg

//#define ViewTest

#endif

@interface FFSRcommentCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *typeLabel;
@property (nonatomic, strong) UILabel       *coinLabel;
@property (nonatomic, strong) UIButton      *discountView;

@property (nonatomic, assign) BOOL isH5Game;

@end


@implementation FFSRcommentCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.imageView = [UIImageView hyb_imageViewWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(ITEM_SIZE.width, ITEM_SIZE.width));
    }];

    self.nameLabel = [UILabel hyb_labelWithFont:11 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(ITEM_SIZE.width, (ITEM_SIZE.height - ITEM_SIZE.width) / 3));
    }];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [FFColorManager textColorMiddle];

    self.typeLabel = [UILabel hyb_labelWithFont:10 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(ITEM_SIZE.width, (ITEM_SIZE.height - ITEM_SIZE.width) / 3));
    }];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.textColor = [FFColorManager textColorLight];
    self.typeLabel.font = [UIFont boldSystemFontOfSize:10];

    self.coinLabel = [UILabel hyb_labelWithFont:11 superView:self.contentView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLabel.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(ITEM_SIZE.width, (ITEM_SIZE.height - ITEM_SIZE.width) / 3));
    }];
    self.coinLabel.textAlignment = NSTextAlignmentCenter;
    self.coinLabel.textColor = [FFColorManager blue_dark];
    self.coinLabel.layer.cornerRadius = (ITEM_SIZE.height - ITEM_SIZE.width) / 6;
    self.coinLabel.layer.masksToBounds = YES;
    self.coinLabel.layer.borderWidth = 1;
    self.coinLabel.layer.borderColor = [FFColorManager blue_dark].CGColor;
}

- (void)setLabel:(UILabel *)label {
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self setImage:dict[@"logo"]];
    [self setName:dict[@"gamename"]];
    [self setCoin:dict[@"finetopstr"]];
    [self setDisCount:dict[@"discount"]];
    [self setType:dict[@"types"]];
//    [self setDisCount:@"3.5"];
}

- (void)setImage:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@",string];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,str]] placeholderImage:[FFImageManager gameLogoPlaceholderImage]];
}

- (void)setName:(NSString *)string {
    self.nameLabel.text = [NSString stringWithFormat:@"%@",string];
}

- (void)setType:(NSString *)type {
    self.typeLabel.text = [NSString stringWithFormat:@"%@",type ?: @"精品游戏"];
}

- (void)setCoin:(NSString *)string {
    if (string && [string isKindOfClass:[NSString class]] && string.length > 0) {
        self.coinLabel.hidden = NO;
        self.coinLabel.text = [NSString stringWithFormat:@"%@",string];
    } else {
        self.coinLabel.hidden = YES;
    }
}

- (void)setDisCount:(NSString *)string {
    if (string && [string isKindOfClass:[NSString class]] && string.length > 0 && ![string isEqualToString:@"0"]) {
        self.discountView.hidden = NO;
        [self.discountView setTitle:[NSString stringWithFormat:@"%@折",string] forState:(UIControlStateNormal)];
    } else {
        self.discountView.hidden = YES;
    }
}

#pragma mark - getter
- (UIButton *)discountView {
    if (!_discountView) {
//        _discountView = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        _discountView.frame = CGRectMake(45, 8, 30, 15);
//        [_discountView setBackgroundImage:[UIImage imageNamed:@"ZKview_recomment_discount"] forState:(UIControlStateNormal)];
//        [_discountView setTitleColor:[FFColorManager navigation_bar_white_color] forState:(UIControlStateNormal)];
//        _discountView.userInteractionEnabled = NO;
//        _discountView.titleLabel.font = [UIFont systemFontOfSize:11];
//        _discountView.backgroundColor = [FFColorManager navigation_bar_black_color];
    }
    return _discountView;
}


@end





#pragma mark - recomment cell
@interface FFSRcommentCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewlayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *showArray;


@end


@implementation FFSRcommentCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setModel:(FFTopGameModel *)model {
    if ([model isKindOfClass:[FFTopGameModel class]]) {
        _model = model;
        self.gameArray = _model.gameArray;
    }
}

- (void)setGameArray:(NSArray *)gameArray {
    if ([gameArray isKindOfClass:[NSArray class]]) {
        _gameArray = gameArray;
        [self.contentView addSubview:self.collectionView];
        [self.collectionView reloadData];
    }
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = CGRectMake(10, 0, frame.size.width - 20, frame.size.height);
}

#pragma mark - collection data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FFSRcommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    cell.dict = self.gameArray[indexPath.row];

#ifdef ViewTest
    cell.backgroundColor = kOrangeColor;
#endif

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"click  %@",self.gameArray[indexPath.row]);
    NSDictionary *dict = self.gameArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFSRcommentCell:didSelectItemInfo:)]) {
        [self.delegate FFSRcommentCell:self didSelectItemInfo:dict];
    }
}

#pragma mark - getter
- (UICollectionViewFlowLayout *)collectionViewlayout {
    if (!_collectionViewlayout) {
        _collectionViewlayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewlayout.itemSize = ITEM_SIZE;
        _collectionViewlayout.minimumLineSpacing = 10;
        _collectionViewlayout.minimumInteritemSpacing = 0;
        _collectionViewlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _collectionViewlayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height) collectionViewLayout:self.collectionViewlayout];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[FFSRcommentCollectionCell class] forCellWithReuseIdentifier:@"collectionViewCell"];

        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}





@end




















