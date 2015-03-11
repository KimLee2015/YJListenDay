//
//  YJTopMusicCell.h
//  ListenVideo
//
//  Created by Lee on 1/26/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJTopMusic;
@interface YJTopMusicCell : UICollectionViewCell
@property (nonatomic,strong) YJTopMusic *topMusic;

+ (instancetype)cellWithCollectionView:(UICollectionView *)view forIndexPath:(NSIndexPath *)path;
@end
