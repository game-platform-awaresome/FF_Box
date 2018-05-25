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

#define ITEM_SIZE CGSizeMake(80, 120)



@interface FFSRcommentCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *coinLabel;


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
    if (string && [string isKindOfClass:[NSString class]]) {
        self.coinLabel.hidden = NO;
        self.coinLabel.text = [NSString stringWithFormat:@"%@",string];
        CGPoint center = self.coinLabel.center;
        CGRect bounds = self.coinLabel.bounds;
        [self.coinLabel sizeToFit];
        bounds.size.width = self.coinLabel.bounds.size.width + 8;
        self.coinLabel.bounds = bounds;
        self.coinLabel.center = center;
    } else {
        self.coinLabel.hidden = YES;
    }

}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 80, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [FFColorManager textColorMiddle];
    }
    return _nameLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 80, 20)];
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        _coinLabel.font = [UIFont systemFontOfSize:13];
        _coinLabel.textColor = [FFColorManager current_version_main_color];
        _coinLabel.layer.borderColor = [FFColorManager current_version_main_color].CGColor;
        _coinLabel.layer.borderWidth = 1;
        _coinLabel.layer.cornerRadius = 10;
        _coinLabel.layer.masksToBounds = YES;
    }
    return _coinLabel;
}


@end





#pragma mark - recomment cell
@interface FFSRcommentCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewlayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *showArray;


@end


@implementation FFSRcommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

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
    self.collectionView.frame = self.bounds;
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

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"click  %ld",indexPath.row);
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
        _collectionViewlayout.minimumLineSpacing = (kSCREEN_WIDTH - 340) / 3;
        _collectionViewlayout.minimumInteritemSpacing = 0;
        _collectionViewlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewlayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _collectionViewlayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewlayout];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;

        [_collectionView registerClass:[FFSRcommentCollectionCell class] forCellWithReuseIdentifier:@"collectionViewCell"];

        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}





@end




















