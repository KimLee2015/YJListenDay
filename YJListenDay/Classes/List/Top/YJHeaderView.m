//
//  YJHeaderView.m
//  ListenVideo
//
//  Created by Lee on 1/27/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJHeaderView.h"
#import "YJTopMusic.h"
#import "YJTopMusicCell.h"
#import "UIView+MJ.h"
#import "MJExtension.h"


static NSString *const YJTopMusicCellIdentifier = @"news";

@interface YJHeaderView () <UICollectionViewDataSource,UICollectionViewDelegate,UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation YJHeaderView
+ (instancetype)view
{
    YJHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"YJHeaderView" owner:nil options:nil] lastObject];
    [view.collectionView registerNib:[UINib nibWithNibName:@"YJTopMusicCell" bundle:nil] forCellWithReuseIdentifier:YJTopMusicCellIdentifier];
    view.collectionView.collectionViewLayout = [self flowLayout];
    return view;
}

+ (UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [self height]);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

+ (CGFloat)height
{
    return 150;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topMusics.count * 3000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YJTopMusicCell *cell = [YJTopMusicCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.topMusic = self.topMusics[indexPath.row % self.topMusics.count];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)((scrollView.contentOffset.x +scrollView.frame.size.width * 0.5)/ scrollView.frame.size.width) % self.topMusics.count;
    self.pageController.currentPage = page;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YJTopMusic *top = self.topMusics[indexPath.row % self.topMusics.count];
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectedCell:)]) {
        [self.delegate headerView:self didSelectedCell:top];
    }
}

@end
