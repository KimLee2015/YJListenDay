//
//  YJDetailCell.m
//  ListenVideo
//
//  Created by Lee on 1/25/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJDetailCell.h"
#import "YJMusicDetail.h"

@interface YJDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;


@end
@implementation YJDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    return [tableView dequeueReusableCellWithIdentifier:@"detail"];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.backgroundColor = [UIColor blackColor];
  self.titleView.textColor = [UIColor whiteColor];
  self.titleView.highlightedTextColor = self.titleView.textColor;
  
  UIView *selectionView = [[UIView alloc] initWithFrame:CGRectZero];
  selectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
  self.selectedBackgroundView = selectionView;
}

- (void)setDetail:(YJMusicDetail *)detail
{
    _detail = detail;
    self.titleView.text = detail.title;
}

- (void)setIcon:(NSString *)icon
{
    self.iconView.image = [UIImage imageNamed:icon];
}

@end
