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

@interface YJMusicViewController () <YJMusicCellDelegate,UITableViewDataSource,UITableViewDelegate>
/**
 *  YJMusic数组
 */
@property (nonatomic,strong) NSArray *musics;

/**
 *  MP3文件名
 */
@property (nonatomic,copy) NSString *mp3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  播放器
 */
@property (nonatomic, strong) AVAudioPlayer *wordPlayer;
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic,strong) CADisplayLink *link2;
/**
 *  YJWord(句子和时间)
 */
@property (nonatomic,strong) NSArray *words;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)back;
- (IBAction)play;
- (IBAction)next;
@end

@implementation YJMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 200;
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
        
        if (currentTime < nextWord.time && currentTime > word.time) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

            [self showCell:[NSIndexPath indexPathForRow:i inSection:0]];
            break;
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

/**
 *  选择并播放cell中的内容
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJMusicCell *cell = (YJMusicCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    [self playMusic];
    self.wordPlayer.currentTime = cell.word.time + 0.05;
    [cell hightLighted];
//    YJWord *w = self.words[indexPath.row];
//    w.play = YES;
//    [self showCell:indexPath];
}

/**
 *  选择并滚动到该cell
 */
- (void)scrollAndSelectCell:(NSIndexPath *)path
{
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中行恢复普通显示
    YJMusicCell *cell = (YJMusicCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    [cell normal];
//    YJWord *w = self.words[indexPath.row];
//    w.play = NO;
}

/**
 *  高亮显示选中行，其他恢复为普通状态
 */
- (void)showCell:(NSIndexPath *)path
{

    YJMusicCell *cell = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:path];
    for (int i = 0; i < self.words.count; i++) {
        if (i == path.row) {
//            [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
            [cell hightLighted];
        }
        else { // 其它cell普通显示
            YJMusicCell *c = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [c normal];
        }
    }
}

#pragma mark - 播放器相关操作
- (IBAction)back {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if (path.row <= 0) return;
    NSIndexPath *backPath = [NSIndexPath indexPathForRow:path.row - 1 inSection:0];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];
    [self scrollAndSelectCell:backPath];
}

- (IBAction)play {
    if (self.wordPlayer.isPlaying) {
        [self.wordPlayer stop];
        [self.backButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else { // 还没播放
        [self playMusic];
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        if (path.row > 0) { // 先按了下一个按钮跳转到其他语句
            [self tableView:self.tableView didSelectRowAtIndexPath:path];
        }
        [self.backButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
}

- (IBAction)next {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if (path.row == self.words.count - 1) { // 到文本末尾
        return;
    }
    NSIndexPath *nextPath = [NSIndexPath indexPathForRow:path.row + 1 inSection:0];
    [self scrollAndSelectCell:nextPath];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];

}

/**
 *  播放音乐
 */
- (void)playMusic
{
    if (!self.wordPlayer.isPlaying) {
        self.wordPlayer = [MJAudioTool playMusic:self.mp3];
    }
}
@end
