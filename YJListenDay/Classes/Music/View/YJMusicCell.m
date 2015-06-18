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
    return cell;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor blackColor];
    self.textView.textColor = [UIColor whiteColor];
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectedView;
}

- (CGFloat)cellHight{
  return self.frame.size.height + 5;
}

#pragma mark - label显示状态
- (void)hightLighted
{
    self.textView.textColor = [UIColor yellowColor];
}

- (void)normal
{
    self.textView.textColor = [UIColor whiteColor];
}

- (void)setWord:(YJWord *)word
{
    _word = word;
    self.textView.text = word.text;
}
@end
