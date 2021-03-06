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
#pragma mark - Properties
@property (nonatomic,strong) NSArray *musics;
@property (nonatomic,strong) NSArray *words;
@property (nonatomic,copy) NSString *mp3;
/**
 *  播放器
 */
@property (nonatomic, strong) AVAudioPlayer *wordPlayer;
@property (nonatomic,strong) UIImage *playImage;
@property (nonatomic,strong) UIImage *stopImage;
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic, strong) UITableViewCell *prototypeCell;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *quitButton;
@end

@implementation YJWordViewController
- (UIImage *)playImage {
    if (_playImage == nil) {
        _playImage = [UIImage imageNamed:@"play"];
    }
    return _playImage;
}

- (UIImage *)stopImage {
    if (_stopImage == nil) {
        _stopImage = [UIImage imageNamed:@"stop"];
    }
    return _stopImage;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
  self.navigationItem.backBarButtonItem.title = self.detail.title;
  [self.backBarButton setTitle:self.detail.title];
  
  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 50;
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

#pragma mark - IBAction
- (IBAction)back:(UIBarButtonItem *)sender {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if (path.row <= 0) return;
    NSIndexPath *backPath = [NSIndexPath indexPathForRow:path.row - 1 inSection:0];
    [self scrollAndSelectCell:backPath];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];
}

- (IBAction)play:(UIBarButtonItem *)sender {
    if (self.wordPlayer.isPlaying) {
        [self.wordPlayer stop];
        sender.image = self.playImage;
    } else { // 还没播放
        [self playMusic];
        sender.image = self.stopImage;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        if (path.row > 0) { // 先按了下一个按钮跳转到其他语句
            [self tableView:self.tableView didSelectRowAtIndexPath:path];
        }
    }
}

- (IBAction)next:(UIBarButtonItem *)sender {
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if (!path) {
        path = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    NSIndexPath *nextPath = [NSIndexPath indexPathForRow:path.row + 1 inSection:0];
    [self scrollAndSelectCell:nextPath];
    [self tableView:self.tableView didDeselectRowAtIndexPath:path];
    sender.image = self.stopImage;
}

- (IBAction)quit:(UIBarButtonItem *)sender {
    [self stopPlayMusic];
    [self.navigationController popViewControllerAnimated:self];
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
    self.playButton.image = self.stopImage;
    self.wordPlayer.currentTime = word.time;
    [word toggleChecked];
    [self configureStateForBasicCell:cell withYJWord:word];

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
- (void)playMusic
{
    if (!self.wordPlayer.isPlaying) {
      self.wordPlayer = [MJAudioTool playMusic:self.mp3];
    }
}

- (void)stopPlayMusic
{
    [self.wordPlayer stop];
}

@end
