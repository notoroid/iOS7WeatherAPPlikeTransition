//
//  TableLayout.h
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/07.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 *  展開されたテーブルレイアウト
 */

@interface ExpandTableLayout : UICollectionViewLayout
/**
 *  展開されたテーブルレイアウトを初期化
 *
 *  @param height    通常の
 *  @param indexPath フルスクリーンとするindexPath
 *
 *  @return インスタンス
 */
- (id)initWithHeight:(CGFloat)height fullscreenIndexPath:(NSIndexPath*)indexPath;
@end