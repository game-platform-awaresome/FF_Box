//
//  FFGameDetailHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/5/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameDetailHeaderView.h"
#import <UIImageView+WebCache.h>
#import "FFImageManager.h"

#define CELLIDE @"DetialTableHeaderCELL"


@interface FFCustomLayout : UICollectionViewLayout

- (instancetype)init;

@property (nonatomic) CGSize itemSize;

@property (nonatomic) NSInteger visibleCount;

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;


@end


@interface FFCustomLayout ()

{
    CGFloat _viewHeight;
    CGFloat _itemHeight;
}

@property (nonatomic, assign) BOOL isCenter;

@end

@implementation FFCustomLayout

- (instancetype)init {
    if (self = [super init]) {
        _isCenter = NO;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    if (self.visibleCount < 1) {
        self.visibleCount = 7;
    }
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _viewHeight = CGRectGetHeight(self.collectionView.frame);
        _itemHeight = self.itemSize.height;
        self.collectionView.contentInset = UIEdgeInsetsMake((_viewHeight - _itemHeight) / 2, 0, (_viewHeight - _itemHeight) / 2, 0);
    } else {
        _viewHeight = CGRectGetWidth(self.collectionView.frame);
        _itemHeight = self.itemSize.width;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewHeight - _itemHeight) / 2, 0, (_viewHeight - _itemHeight) / 2);
    }

    //    if (!_isCenter) {
    //        [self.collectionView setContentOffset:CGPointMake(([self.collectionView numberOfItemsInSection:0] / 2 - 2) * _itemSize.width / 2, 0)];
    //        _isCenter = YES;
    //    }

}

- (CGSize)collectionViewContentSize {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), cellCount * _itemHeight);
    }
    return CGSizeMake(cellCount * _itemHeight, CGRectGetHeight(self.collectionView.frame));
}

//
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerY = (self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x) + _viewHeight / 2;
    NSInteger index = centerY / _itemHeight;
    NSInteger count = (self.visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;

    CGFloat cY = (self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.collectionView.contentOffset.y : self.collectionView.contentOffset.x) + _viewHeight / 2;
    CGFloat attributesY = _itemHeight * indexPath.row + _itemHeight / 2;
    attributes.zIndex = -ABS(attributesY - cY);

    CGFloat delta = cY - attributesY;
    CGFloat ratio =  - delta / (_itemHeight * 2);

    CGFloat scale = 1 - ABS(delta) / (_itemHeight * 5.0) * cos(ratio * M_PI_4);

    attributes.transform = CGAffineTransformMakeScale(scale, scale);

    CGFloat centerY = attributesY;

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        attributes.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, centerY);
    } else {
        attributes.center = CGPointMake(centerY, CGRectGetHeight(self.collectionView.frame) / 2);
    }

    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat index = roundf(((self.scrollDirection == UICollectionViewScrollDirectionVertical ? proposedContentOffset.y : proposedContentOffset.x) + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        proposedContentOffset.y = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
    } else {
        proposedContentOffset.x = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
    }
    return proposedContentOffset;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end


@interface FFGameDetailHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) FFCustomLayout *customLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FFGameDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.collectionView];
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self.collectionView reloadData];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDE forIndexPath:indexPath];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.backgroundColor = [UIColor orangeColor];

    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.row]] placeholderImage:[FFImageManager Game_detail_header_placeholder]];

    [cell.contentView addSubview:imageView];

    cell.contentView.layer.cornerRadius = 12;
    cell.contentView.layer.masksToBounds = YES;


    return cell;
}


#pragma mark - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(self.bounds.size.width * 0.4 , self.bounds.size.height - 10);
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    }
    return _layout;
}

- (FFCustomLayout *)customLayout {
    if (!_customLayout) {
        _customLayout = [[FFCustomLayout alloc]init];
        _customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _customLayout.itemSize = CGSizeMake(self.bounds.size.height * 0.7 , self.bounds.size.height - 10);
    }
    return _customLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.customLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLIDE];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

    }
    return _collectionView;
}



@end
