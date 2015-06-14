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

#define setPlayButtonPlayImage [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

@interface YJWordViewController () <YJMusicCellDelegate,UITableViewDataSource,UITableViewDelegate>
/**
 *  YJMusic
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
/**
 *  播放器
 */
@property (nonatomic, strong) AVAudioPlayer *wordPlayer;
@property (nonatomic,strong) CADisplayLink *link;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITableViewCell *prototypeCell;
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
  [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
  self.navigationItem.backBarButtonItem.title = self.detail.title;
  
  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 160.0;
}

- (void)setDetail:(YJMusicDetail *)detail
{
    _detail = detail;
    self.words = [YJWord objectArrayWithFilename:detail.wordsURL];
    self.mp3 = detail.mp3;
  if (self.isViewLoaded) {
    [self.tableView reloadData];
  }
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
    [self checkButtonState];
    // 当前播放的位置
    double currentTime = self.wordPlayer.currentTime;
    
    float count = self.words.count;
    for (int i = 0; i < count; i++) {
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
        
      if (currentTime > word.time && currentTime < nextWord.time ) {
        [self showCell:[NSIndexPath indexPathForRow:i inSection:0]];
        break;
      }
    }
}

/* button的启用和禁用*/
- (void)checkButtonState
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path.row == 0) {
        self.backButton.enabled = NO;
    } else if (path.row == self.words.count - 1){
        self.nextButton.enabled = NO;
    } else {
        self.backButton.enabled = YES;
        self.nextButton.enabled = YES;
    }
}

#pragma mark - UITableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self basicCellAtIndexPath:indexPath];
}

- (YJMusicCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath
{
    YJMusicCell *cell = [YJMusicCell cellWithTableView:self.tableView];
    YJWord *word = [self.words objectAtIndex:indexPath.row];
  [self configureBasicCell:cell withYJWord:word];
  [self configureStateForBasicCell:cell withYJWord:word];
  return cell;
}

- (void)configureBasicCell:(YJMusicCell *)cell withYJWord:word
{

    cell.word = word;
}

- (void)configureStateForBasicCell:(YJMusicCell *)cell withYJWord:(YJWord *)word
{
  if (word.isPlayed) {
    [cell hightLighted];
  } else {
    [cell normal];
  }
}

#pragma mark - UITableViewDelegate
/**
 *  高亮并播放cell中的内容
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  YJWord *word = [self.words objectAtIndex:indexPath.row];
  YJMusicCell *cell = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  [self playMusic];
  self.wordPlayer.currentTime = word.time;
  [word toggleChecked];
  [self configureStateForBasicCell:cell withYJWord:word];
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/**
 *  让被取消选中行普通显示
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJWord *word = [self.words objectAtIndex:indexPath.row];
    word.play = false;
    YJMusicCell *cell = (YJMusicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - 播放器相关操作
- (IBAction)back {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if (path.row <= 0) return;
    NSIndexPath *backPath = [NSIndexPath indexPathForRow:path.row - 1 inSection:0];
    [self scrollAndSelectCell:backPath];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];
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
    if (!path) {
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    NSIndexPath *nextPath = [NSIndexPath indexPathForRow:path.row + 1 inSection:0];
    [self scrollAndSelectCell:nextPath];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];
    setPlayButtonStopImage;
}

- (void)stopPlayMusic
{
    [self.wordPlayer stop];
}
@end
