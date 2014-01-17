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
    CGFloat _contentHeight;
    NSIndexPath* _indexPath;
}
@end

@implementation ExpandTableLayout

- (id)initWithHeight:(CGFloat)height fullscreenIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if (self) {
        [self setInitialValues];
        _indexPath = indexPath;
        _contentHeight = height;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setInitialValues];
    }
    return self;
}

- (void)setInitialValues {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setInitialValues];
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
    return size;
}

- (CGRect) rectForRow:(NSInteger)row
{
    CGFloat top = .0f;
    CGFloat height = .0f;
    
    if( row < _indexPath.row ){
        top = (row - _indexPath.row) * _contentHeight;
        if( row == 0 )
            top -= 20.0f;
        
        height = _contentHeight;
        if( row == 0 )
            top += 20.0f;
    }else if( row == _indexPath.row ){
        top = .0f;
        height = self.collectionView.bounds.size.height;
    }else{
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