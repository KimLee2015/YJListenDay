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
#import "YJCustomLayout.h"

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
    return view;
}

+ (CGFloat)height
{
    return 150;
}

- (void)setTopMusics:(NSArray *)topMusics
{
    _topMusics = topMusics;
    self.pageController.numberOfPages = topMusics.count;
}

- (void)awakeFromNib
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"YJTopMusicCell" bundle:nil] forCellWithReuseIdentifier:YJTopMusicCellIdentifier];
    self.collectionView.collectionViewLayout = [YJCustomLayout layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.pageController.numberOfPages = self.topMusics.count;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topMusics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YJTopMusicCell *cell = [YJTopMusicCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.topMusic = self.topMusics[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)((scrollView.contentOffset.x +scrollView.frame.size.width * 0.5)/ scrollView.frame.size.width);
    self.pageController.currentPage = page;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YJTopMusic *top = self.topMusics[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectCell:)]) {
        [self.delegate headerView:self didSelectCell:top];
    }
}

@end
