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

@interface YJHeaderView () <UICollectionViewDataSource,UICollectionViewDelegate,UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSArray *topMusics;
@end

@implementation YJHeaderView
+ (instancetype)view
{
    YJHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"YJHeaderView" owner:nil options:nil] lastObject];
    // 注册cell
    [view.collectionView registerNib:[UINib nibWithNibName:@"YJTopMusicCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
    [view.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2500 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSLog(@"%f",view.collectionView.width);
    [view.layout setItemSize:CGSizeMake(view.collectionView.width, view.collectionView.height)];

    return view;
}


- (NSArray *)topMusics
{
    if (!_topMusics) {
        YJTopMusic *t1 = [[YJTopMusic alloc] init];
        t1.icon = @"album";
        t1.title = @"test1";
        
        YJTopMusic *t2 = [[YJTopMusic alloc] init];
        t2.icon = @"like";
        t2.title = @"test2";
        
        YJTopMusic *t3 = [[YJTopMusic alloc] init];
        t3.icon = @"card";
        t3.title = @"test3";
        _topMusics = [NSArray arrayWithObjects:t1,t2,t3,nil];
    }
    return _topMusics;
    
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
    int page = (scrollView.contentOffset.x / 2500) / scrollView.frame.size.width;
    self.pageController.currentPage = page;
}

@end
