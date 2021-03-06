//
//  OneViewController.m
//  AutoLayoutTest
//
//  Created by 能登 要 on 2014/01/07.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "OneViewController.h"
#import "ExpandTableLayout.h"
#import "SwipeLayout.h"

@interface OneViewController () <UICollectionViewDelegateFlowLayout>
{
    BOOL _fullScreen;
}
@property (strong,nonatomic) UICollectionViewLayout *originalLayout;
@property (strong,nonatomic) NSArray* colors;
@end

@implementation OneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.colors = @[ [UIColor redColor],[UIColor grayColor],[UIColor blueColor]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
        // 回り込み有効
    
    self.originalLayout = self.collectionViewLayout;
        // オリジナルレイアウトを保存
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(fireChangeLayout:)]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//セクション内の行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"normalCell" forIndexPath:indexPath];
    normalCell.backgroundColor = self.colors[indexPath.row % self.colors.count];

    UILabel *label = (UILabel*)[normalCell viewWithTag:1];
    
    UIFontDescriptor *descriptor = [[UIFontDescriptor alloc] initWithFontAttributes:@{UIFontDescriptorNameAttribute:@"HelveticaNeue-UltraLight"}];
    
    label.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",@(indexPath.row)] attributes:@{NSFontAttributeName:[UIFont fontWithDescriptor:descriptor size:25.0f]}];

    UIButton *button = (UIButton *)[normalCell viewWithTag:2];
    [button addTarget:self action:@selector(fireChangeLayout:) forControlEvents:UIControlEventTouchUpInside];
    
    return normalCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *footerView = nil;
    if( [kind isEqualToString:UICollectionElementKindSectionFooter] ){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"normalFooter" forIndexPath:indexPath];
        
        UIButton *button = (UIButton *)[footerView viewWithTag:1];
        [button addTarget:self action:@selector(fireChangeLayout:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return footerView;
}

- (void) fireChangeLayout:(id)sender
{
    NSLog(@"fireChangeLayout: call");
    
    // フルスクリーンを有効にした場合
    if( _fullScreen == NO  ){
        _fullScreen = YES;
            // フルスクリーン

        UIButton* button = [sender isKindOfClass:[UIButton class]] ? sender : nil;
        NSIndexPath* indexPath = nil;
            // ボタンのindexを取得
        
        // 呼び出されたbuttonの元cell を探す
        NSArray *visibleCells = [self.collectionView visibleCells];
        for (UICollectionViewCell *cell in visibleCells) {
            UIButton *testButton = (UIButton *)[cell viewWithTag:2];
            if( button == testButton ){
                indexPath = [self.collectionView indexPathForCell:cell];
                    // ccell からindexPath を求める
                break;
            }
        }
        
        // ExpandTableLayout をリストの高さ65.0f、indexPath をフルスクリーンとする
        __weak OneViewController *weakSelf = self;
        [self.collectionView setCollectionViewLayout:[[ExpandTableLayout alloc] initWithHeight:65.0f fullscreenIndexPath:indexPath] animated:YES completion:^(BOOL finished) {
            
            // アニメーション終了後にmainqueue を一度通してスワイプレイアウトへ移行
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView setCollectionViewLayout:[[SwipeLayout alloc] init] animated:NO completion:^(BOOL finished) {
                    weakSelf.collectionView.alwaysBounceVertical = NO;
                    weakSelf.collectionView.alwaysBounceHorizontal = YES;
                    weakSelf.collectionView.pagingEnabled = YES;
                    // スクロール方向を変更
                }];
            });
            
        }];
    }else{
        _fullScreen = NO;
            // fullscreen を無効に
        
        NSArray *visibleItemIndexes = [self.collectionView indexPathsForVisibleItems];
        NSIndexPath *indexPath = visibleItemIndexes.count > 0 ? visibleItemIndexes[0] : nil;
            // 表示されているcellのindexPath を取得
        
        // スワイプからExpandTableLayout をリストの高さ65.0f、indexPath をフルスクリーンに変更
        __weak OneViewController *weakSelf = self;
        [self.collectionView setCollectionViewLayout:[[ExpandTableLayout alloc] initWithHeight:65.0f fullscreenIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] animated:YES completion:^(BOOL finished) {
            
            // アニメーション終了後にmainqueue を一度通してオリジナルのレイアウトへ遷移
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView setCollectionViewLayout:weakSelf.originalLayout animated:YES completion:^(BOOL finished) {
                    weakSelf.collectionView.alwaysBounceVertical = YES;
                    weakSelf.collectionView.alwaysBounceHorizontal = NO;
                    weakSelf.collectionView.pagingEnabled = NO;
                    // スクロール方向を変更
                }];
                
            });
        }];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320.0f, indexPath.row == 0 ? 85.0f : 65.0f );
}



@end
