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
