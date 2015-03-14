//
//  YJHomeCell.m
//  ListenVideo
//
//  Created by Lee on 1/24/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJHomeCell.h"
#import "UIView+MJ.h"

@interface YJHomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *countView;

@end
@implementation YJHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"home";
    YJHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSLog(@"sd");
    }
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

- (void)setMusicGroup:(YJMusicGroup *)musicGroup
{
    _musicGroup = musicGroup;
    self.iconView.image = [UIImage imageNamed:musicGroup.icon];
    self.titleView.text = musicGroup.title;
    self.countView.text = [NSString stringWithFormat:@"共%d篇",musicGroup.count];
}

@end
