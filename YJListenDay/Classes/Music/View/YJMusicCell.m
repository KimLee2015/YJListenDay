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
    [cell.textView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(clickLabel)]];
    return cell;
}

#pragma mark - 播放点击label时,其对应的文本
- (void)clickLabel
{
    if ([self.delegate respondsToSelector:@selector(didClickedLabel:)]) {
        [self.delegate didClickedLabel:self.word];
    }
}

#pragma mark - label显示状态
- (void)hightLighted
{
    self.textView.textColor = [UIColor blueColor];
}

- (void)normal
{
    self.textView.textColor = [UIColor blackColor];
}

- (void)setWord:(YJWord *)word
{
    _word = word;
    self.textView.text = word.text;
    if (_word.isPlayed) {
        [self hightLighted];
    } else {
        [self normal];
    }
}
@end
