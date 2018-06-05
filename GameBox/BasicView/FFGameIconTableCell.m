//
//  FFGameIconTableCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/4.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameIconTableCell.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import <UIImageView+WebCache.h>

@interface FFgameIconCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *coinLabel;


@end


@implementation FFgameIconCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.coinLabel];
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
}

- (void)setImage:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@",string];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,str]] placeholderImage:[FFImageManager gameLogoPlaceholderImage]];
}

- (void)setName:(NSString *)string {
    self.nameLabel.text = [NSString stringWithFormat:@"%@",string];
}

- (void)setCoin:(NSString *)string {
    if (string && [string isKindOfClass:[NSString class]] && string.length > 0) {
        self.coinLabel.hidden = NO;
        self.coinLabel.text = [NSString stringWithFormat:@"%@",string];
        CGPoint center = self.coinLabel.center;
        CGRect bounds = self.coinLabel.bounds;
        bounds.size.width = self.coinLabel.bounds.size.width + 3;
        self.coinLabel.bounds = bounds;
        self.coinLabel.center = center;
    } else {
        self.coinLabel.hidden = YES;
    }
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 65, 60, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = [FFColorManager textColorMiddle];
    }
    return _nameLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 90, 56, 20)];
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        _coinLabel.font = [UIFont systemFontOfSize:11];
        _coinLabel.textColor = [FFColorManager current_version_main_color];
        _coinLabel.layer.borderColor = [FFColorManager current_version_main_color].CGColor;
        _coinLabel.layer.borderWidth = 1;
        _coinLabel.layer.cornerRadius = 10;
        _coinLabel.layer.masksToBounds = YES;
    }
    return _coinLabel;
}


@end


@interface FFGameIconTableCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *showArray;

@end


@implementation FFGameIconTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
    self.layout.itemSize = CGSizeMake(70, 100);
}

- (void)setArray:(NSArray *)array {
    _showArray = array;
    [self.collectionView reloadData];
}


#pragma mark - uicollection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FFgameIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FFgameIconCell" forIndexPath:indexPath];
    cell.dict = self.showArray[indexPath.row];
    cell.backgroundColor = [FFColorManager navigation_bar_white_color];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameIconTableCell:selectItemWithInfo:)]) {
        [self.delegate FFGameIconTableCell:self selectItemWithInfo:self.showArray[indexPath.row]];
    }
}


#pragma mark - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = (kSCREEN_WIDTH - 340) / 3;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FFgameIconCell class] forCellWithReuseIdentifier:@"FFgameIconCell"];
        _collectionView.backgroundColor = [FFColorManager navigation_bar_white_color];
    }
    return _collectionView;
}








@end










