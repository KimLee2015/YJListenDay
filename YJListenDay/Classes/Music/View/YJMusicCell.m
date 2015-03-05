//
//  YJMusicCell.m
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJMusicCell.h"
#import "YJWord.h"
#import "MJExtension.h"
#define IWStatusTableBorder 5

@interface YJMusicCell ()
@property (weak, nonatomic) IBOutlet UILabel *textView;

@end
@implementation YJMusicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    YJMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - label显示状态
- (void)hightLighted
{
    self.textView.textColor = [UIColor blueColor];
    self.word.play = YES;
}

/**
 *  普通显示，并修改模型属性，防止状态重用
 */
- (void)normal
{
    self.textView.textColor = [UIColor blackColor];
    self.word.play = NO;
}

- (void)setWord:(YJWord *)word
{
    _word = word;
    self.textView.text = word.text;
    if (word.isPlayed) {
        self.textView.textColor = [UIColor blueColor];
    } else {
        self.textView.textColor = [UIColor blackColor];
    }
}
@end
