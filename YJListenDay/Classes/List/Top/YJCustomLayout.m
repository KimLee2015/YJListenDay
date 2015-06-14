//
//  YJCustomLayout.m
//  YJListenDay
//
//  Created by Lee on 15/6/14.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "YJCustomLayout.h"
#import "YJHeaderView.h"
@implementation YJCustomLayout
+ (UICollectionViewFlowLayout *)layout
{
  YJCustomLayout *layout = [[YJCustomLayout alloc] init];
  layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [YJHeaderView height]);
  layout.minimumLineSpacing = 0;
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  return layout;
}
@end
