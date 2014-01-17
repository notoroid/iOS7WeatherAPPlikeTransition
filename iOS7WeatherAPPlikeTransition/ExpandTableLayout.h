//
//  TableLayout.h
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/07.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandTableLayout : UICollectionViewLayout
- (id)initWithHeight:(CGFloat)height fullscreenIndexPath:(NSIndexPath*)indexPath;
@end