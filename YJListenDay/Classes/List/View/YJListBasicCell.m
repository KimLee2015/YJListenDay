//
//  YJListBasicCell.m
//  ListenVideo
//
//  Created by Lee on 1/24/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJListBasicCell.h"
#import "UIView+MJ.h"

static NSString *const YJListBasicCellIdentifier = @"home";

@interface YJListBasicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *countView;

@end
@implementation YJListBasicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    YJListBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:YJListBasicCellIdentifier];
    return cell;
}

+ (NSString *)ID
{
    return @"home";
}

+ (CGFloat)cellHight
{
    return 56;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.backgroundColor = [UIColor blackColor];
  self.titleView.textColor = [UIColor whiteColor];
  self.titleView.highlightedTextColor = self.titleView.textColor;
  
  self.countView.textColor = [UIColor colorWithWhite:1.0 alpha:0.4];
  self.countView.highlightedTextColor = self.countView.textColor;
  
  UIView *selectionView = [[UIView alloc] initWithFrame:CGRectZero];
  selectionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
  self.selectedBackgroundView = selectionView;
}

- (void)setMusicGroup:(YJMusicGroup *)musicGroup
{
    _musicGroup = musicGroup;
    self.iconView.image = [UIImage imageNamed:musicGroup.icon];
    self.titleView.text = musicGroup.title;
    self.countView.text = [NSString stringWithFormat:@"共%d期",musicGroup.count];
}

@end
