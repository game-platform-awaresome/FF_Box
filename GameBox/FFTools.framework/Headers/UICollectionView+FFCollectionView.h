//
//  UICollectionView+FFCollectionView.h
//  FFTools
//
//  Created by 燚 on 2018/9/6.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBlockHeader.h"

@interface UICollectionView (FFCollectionView)


/**
 *    Create a colellection.
 *
 *    @param delegate                   collection view delegate and data source.
 *    @param isHorizontal               UICollectionViewScrollDirection
 *    @param superView                  The super view of collection view.
 *
 *    @return collectionView.
 */
+ (instancetype)ff_collectionViewWithDelegate:(id)delegate
                                   Horizontal:(BOOL)isHorizontal
                                    SuperView:(UIView *)superView;
/**
 *    Create a colellection.
 *
 *    @param delegate                   collection view delegate and data source.
 *    @param isHorizontal               UICollectionViewScrollDirection
 *    @param itemSize                   The size of collection view cell.
 *    @param superView                  The super view of collection view.
 *
 *    @return collectionView.
 */
+ (instancetype)ff_collectionViewWithDelegate:(id)delegate
                                   Horizontal:(BOOL)isHorizontal
                                         Size:(CGSize)itemSize
                                    SuperView:(UIView *)superView;
/**
 *    Create a colellection.
 *
 *    @param delegate                   collection view delegate and data source.
 *    @param isHorizontal               UICollectionViewScrollDirection
 *    @param itemSize                   The size of collection view cell.
 *    @param minimumInteritemSpacing    The minunum interitem spacing.
 *    @param minimumLineSpacing         The mininum line spacing.
 *    @param superView                  The super view of collection view.
 *
 *    @return collectionView.
 */
+ (instancetype)ff_collectionViewWithDelegate:(id)delegate
                                   Horizontal:(BOOL)isHorizontal
                                         Size:(CGSize)itemSize
                                  ItemSpacing:(CGFloat)minimumInteritemSpacing
                                  LineSpacing:(CGFloat)minimumLineSpacing
                                    SuperView:(UIView *)superView;
/**
 *    Create a colellection.
 *
 *    @param delegate                   collection view delegate and data source.
 *    @param isHorizontal               UICollectionViewScrollDirection
 *    @param itemSize                   The size of collection view cell.
 *    @param minimumInteritemSpacing    The minunum interitem spacing.
 *    @param minimumLineSpacing         The mininum line spacing.
 *    @param superView                  The super view of collection view.
 *    @param constraints                The constraints added to the collection view.
 *
 *    @return collectionView.
 */
+ (instancetype)ff_collectionViewWithDelegate:(id)delegate
                                   Horizontal:(BOOL)isHorizontal
                                         Size:(CGSize)itemSize
                                  ItemSpacing:(CGFloat)minimumInteritemSpacing
                                  LineSpacing:(CGFloat)minimumLineSpacing
                                    SuperView:(UIView *)superView
                                  Constraints:(FFConstraintMakerBlock)constraints;
/**
 *  Create collectionview.
 *
 *  @param  delegate         collection view delegate and data source.
 *  @param  layout           collection view layout.
 *  @param  superView        The super view of collection view.
 *  @param  constraints      The constraints added to the collection view.
 *
 *  @return collectionView;
 */
+ (instancetype)ff_collectionViewWithDelegate:(id)delegate
                         CollectionViewLayout:(UICollectionViewLayout *)layout
                                    SuperView:(UIView *)superView
                                  Constraints:(FFConstraintMakerBlock)constraints;



@end
