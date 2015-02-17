//
//  YJMusicViewController.m
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJMusicViewController.h"
#import "YJWord.h"
#import "YJMusicDetail.h"
#import "MJExtension.h"
#import "YJMusicCell.h"
#import "MJAudioTool.h"

@interface YJMusicViewController () <YJMusicCellDelegate>
/**
 *  YJMusic数组
 */
@property (nonatomic,strong) NSArray *musics;

/**
 *  播放的MP3文件
 */
@property (nonatomic,copy) NSString *mp3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AVAudioPlayer *wordPlayer;
@property (nonatomic,strong) CADisplayLink *link;
/**
 *  YJWord(句子和时间)
 */
@property (nonatomic,strong) NSArray *words;
@end

@implementation YJMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.rowHeight = 200;
    self.wordPlayer = [MJAudioTool playMusic:self.mp3];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)setDetail:(YJMusicDetail *)detail
{
    _detail = detail;
    self.words = [YJWord objectArrayWithFilename:detail.musicURL];
    self.mp3 = detail.mp3;
}

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}

#pragma mark - 实时高亮显示cell
- (void)update
{
    // 当前播放的位置 11.5
    double currentTime = self.wordPlayer.currentTime;
    
    int count = self.words.count;
    for (int i = 0; i<count; i++) {
        // 1.当前词句
        YJWord *word = self.words[i];
        
        // 2.获得下一条词句
        int nextI = i + 1;
        YJWord *nextWord = nil;
        if (nextI < count) {
            nextWord = self.words[nextI];
        }
        else { // 解决最后一段没有nextWord的问题
            nextWord = [[YJWord alloc] init];
            nextWord.time = MAXFLOAT;
        }
        //9.0 13.0 16.0 27-0
        
        if (currentTime < nextWord.time && currentTime > word.time) {
            [self showCell:[NSIndexPath indexPathForRow:i inSection:0]];
            break;
        }
    }
}

- (void)showCell:(NSIndexPath *)path
{
    YJMusicCell *cell = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:path];
    for (int i = 0; i < self.words.count; i++) {
        if (i == path.row) {
            cell.word.play = YES;
            [cell hightLighted];
        } else { // 其它cell普通显示
            YJMusicCell *c = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            c.word.play = NO;
            [c normal];
        }
    }
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJMusicCell *cell = [YJMusicCell cellWithTableView:self.tableView];
    cell.delegate = self;
    cell.word = self.words[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJMusicCell *cell = (YJMusicCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


#pragma mark - YJMusicCell delegate
- (void)didClickedLabel:(YJWord *)word
{
    // 0.05为延时时间，防止update方法的多次选择
    self.wordPlayer.currentTime = word.time +0.05;
    
}
@end
