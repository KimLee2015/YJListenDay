//
//  YJTopMusicCell.m
//  ListenVideo
//
//  Created by Lee on 1/26/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJTopMusicCell.h"
#import "YJTopMusic.h"
#import "UIView+MJ.h"
@interface YJTopMusicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation YJTopMusicCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)view forIndexPath:(NSIndexPath *)path
{
    return [view dequeueReusableCellWithReuseIdentifier:@"news" forIndexPath:path];
}

- (void)setTopMusic:(YJTopMusic *)topMusic
{
    _topMusic = topMusic;
    self.iconView.image = [UIImage imageNamed:topMusic.icon];
    self.titleView.text = topMusic.title;
}
@end
