#import "YJListViewController.h"
#import "YJListBasicCell.h"
#import "MJExtension.h"
#import "YJHeaderView.h"
#import "UIView+MJ.h"
#import "YJMusicDetailViewController.h"
#import "YJWordViewController.h"
#import "YJMusicGroup.h"
#import "YJMusicDetail.h"
#import "MJAudioTool.h"
#import "YJTopMusic.h"
#import "YJHeaderView.h"

@interface YJListViewController () <YJHeaderViewDelegate>
@property(nonatomic,strong) YJHeaderView *headerView;
@property (nonatomic,strong) NSArray *musicGroups;
/**
 *  顶部推荐的YJTopMusic
 */
@property (nonatomic,strong) NSArray *topMusics;
@end

@implementation YJListViewController

- (NSArray *)musicGroups
{
    if (!_musicGroups) {
        _musicGroups = [YJMusicGroup objectArrayWithFilename:@"list.plist"];
    }
    return _musicGroups;
}

- (NSArray *)topMusics
{
    if (!_topMusics) {
        _topMusics = [YJTopMusic objectArrayWithFilename:@"top.plist"];
    }
    return _topMusics;
}

- (YJHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [YJHeaderView view];
        _headerView.topMusics = self.topMusics;
        _headerView.delegate = self;
        
    }
    return _headerView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.2];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
}

#pragma mark - UITableViewDateSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicGroups.count * 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self basicCellAtIndexPath:indexPath];
}

- (YJListBasicCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath
{
    YJListBasicCell *cell = [YJListBasicCell cellWithTableView:self.tableView];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(YJListBasicCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    YJMusicGroup *group = self.musicGroups[indexPath.row % self.musicGroups.count];
    cell.musicGroup = group;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YJListBasicCell cellHight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"asdasd";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [YJHeaderView height];
}

#pragma mark - YJHeaderViewDelegate
- (void)headerView:(YJHeaderView *)headerView didSelectedCell:(YJTopMusic *)music
{
    // 获得控制器
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YJWordViewController *word = [story instantiateViewControllerWithIdentifier:@"words"];
    // 传入模型
    YJMusicDetail *detail = [[YJMusicDetail alloc] init];
    detail.wordsURL = music.wordsURL;
    detail.mp3 = music.mp3;
    word.detail = detail;
    
    [self.navigationController pushViewController:word animated:YES];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//        YJMusicDetailViewController *control = segue.destinationViewController;
//        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        YJMusicGroup *g = self.musicGroups[path.row % self.musicGroups.count];
//        control.detailURL = g.detailURL;
//        control.icon = g.icon;
  
    YJMusicDetailViewController *control = segue.destinationViewController;
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    YJMusicGroup *g = self.musicGroups[path.row % self.musicGroups.count];
    control.detailURL = g.detailURL;
    control.icon = g.icon;

  
}
@end
