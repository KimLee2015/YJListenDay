//
//  YJWordViewController.m
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJWordViewController.h"
#import "YJWord.h"
#import "YJMusicDetail.h"
#import "MJExtension.h"
#import "YJMusicCell.h"
#import "MJAudioTool.h"

#define setPlayButtonStopImage [self.playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];

#define setPlayButtonPlayImage [self.playButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];

@interface YJWordViewController () <YJMusicCellDelegate,UITableViewDataSource,UITableViewDelegate>
/**
 *  YJMusic数组
 */
@property (nonatomic,strong) NSArray *musics;
/**
 *  YJWord
 */
@property (nonatomic,strong) NSArray *words;
/**
 *  MP3文件名
 */
@property (nonatomic,copy) NSString *mp3;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  播放器
 */
@property (nonatomic, strong) AVAudioPlayer *wordPlayer;
@property (nonatomic,strong) CADisplayLink *link;

- (IBAction)back;
- (IBAction)play;
- (IBAction)next;
@end

@implementation YJWordViewController

- (void)playMusic
{
    if (!self.wordPlayer.isPlaying) {
        self.wordPlayer = [MJAudioTool playMusic:self.mp3];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 200;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
     
}

- (void)backButtonClick
{
    NSLog(@"backbutton");
}

- (void)setDetail:(YJMusicDetail *)detail
{
    _detail = detail;
    self.words = [YJWord objectArrayWithFilename:detail.wordsURL];
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
    // 当前播放的位置
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
}

/**
 *  让被取消选中行普通显示
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJMusicCell *cell = (YJMusicCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    [cell normal];
}

/**
 *  高亮显示选中行，其他恢复为普通状态
 */
- (void)showCell:(NSIndexPath *)path
{

    YJMusicCell *cell = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:path];
    for (int i = 0; i < self.words.count; i++) {
        if (i == path.row) {
            [cell hightLighted];
        }
        else { // 其它cell普通显示
            YJMusicCell *c = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [c normal];
        }
    }
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

#pragma mark - 播放器相关操作
- (IBAction)back {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if (path.row <= 0) return;
    NSIndexPath *backPath = [NSIndexPath indexPathForRow:path.row - 1 inSection:0];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];
    [self scrollAndSelectCell:backPath];
    setPlayButtonPlayImage;
}

- (IBAction)play {
    if (self.wordPlayer.isPlaying) {
        [self.wordPlayer stop];
        setPlayButtonPlayImage;
    } else { // 还没播放
        [self playMusic];
        setPlayButtonStopImage;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        if (path.row > 0) { // 先按了下一个按钮跳转到其他语句
            [self tableView:self.tableView didSelectRowAtIndexPath:path];
        }
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
    setPlayButtonPlayImage;
    

}

#pragma mark - 返回
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    [self.wordPlayer pause];
}
@end
