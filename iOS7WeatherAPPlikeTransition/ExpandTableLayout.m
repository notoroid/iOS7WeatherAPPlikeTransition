//
//  TableLayout.m
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/07.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "ExpandTableLayout.h"

@interface ExpandTableLayout ()
{
    CGFloat _contentHeight; // テーブルの高さ
    NSIndexPath* _indexPath; // フルスクリーンの
}
@end

@implementation ExpandTableLayout

- (id)initWithHeight:(CGFloat)height fullscreenIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if (self) {
        [self setInitialValues];
            // 値を初期化
        
        // 渡されたパラメータを保存
        _indexPath = indexPath;
        _contentHeight = height;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setInitialValues];
            // 値を初期化
    }
    return self;
}

- (void)setInitialValues {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setInitialValues];
            // 値を初期化
    }
    return self;
}

// 表示するセルの総数を返す（今回はセクション0のみを対象とする）
- (NSInteger)count {
    return [self.collectionView numberOfItemsInSection:0];
}

// collectionViewのスクロール可能領域の大きさを返す
- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.bounds.size;
        // コンテンツサイズはcollectionView のサイズとする
    return size;
}

/**
 *  行に対する矩形を計算
 *
 *  @param row 行番号
 *
 *  @return 矩形
 */
- (CGRect) rectForRow:(NSInteger)row
{
    CGFloat top = .0f;
    CGFloat height = .0f;
    
    // フルスクリーン上部
    if( row < _indexPath.row ){
        top = (row - _indexPath.row) * _contentHeight;
        if( row == 0 )
            top -= 20.0f;
        
        height = _contentHeight;
        if( row == 0 )
            top += 20.0f;
    }else if( row == _indexPath.row ){
        //　フルスクリーン画面
        top = .0f;
        height = [self collectionViewContentSize].height;
    }else{
        // フルスクリーン下部の計算
        top = (row - _indexPath.row - 1) * _contentHeight + self.collectionView.bounds.size.height;
        height = _contentHeight;
    }
    CGRect rect = CGRectMake(.0f, top ,self.collectionView.bounds.size.width,height);
    return rect;
}

// 指定された矩形に含まれるセルのIndexPathを返す
- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.count; i++){
        CGRect rectHittest = [self rectForRow:i];
            // 矩形を取得
        
        if( CGRectIntersectsRect(rect, rectHittest) ){
            [array addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    return array;
}

// 指定された矩形内に含まれる表示要素のレイアウト情報を返す
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *indices = [self indexPathsForItemsInRect:rect];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:indices.count];
    for (NSIndexPath *indexPath in indices) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return array;
}

// 各UICollectionViewCellに適用するレイアウト情報を返す
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attr.frame = [self rectForRow:indexPath.row];
    
    return attr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
}

@end