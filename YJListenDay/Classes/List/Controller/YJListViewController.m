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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowMusicDetail"]) {
    YJMusicDetailViewController *detailController = segue.destinationViewController;
    NSIndexPath *path = sender;
    YJMusicGroup *g = self.musicGroups[path.row];
    detailController.detailURL = g.detailURL;
    detailController.icon = g.icon;
    detailController.splitViewDetail = self.splitViewDetail;
  }
}

#pragma mark - UITableViewDateSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicGroups.count;
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
    YJMusicGroup *group = self.musicGroups[indexPath.row];
    cell.musicGroup = group;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"ShowMusicDetail" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YJListBasicCell cellHight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [YJHeaderView height];
}

#pragma mark - YJHeaderViewDelegate
- (void)headerView:(YJHeaderView *)headerView didSelectCell:(YJTopMusic *)music
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YJWordViewController *wordController = [story instantiateViewControllerWithIdentifier:@"words"];
    YJMusicDetail *detail = [[YJMusicDetail alloc] init];
    detail.wordsURL = music.wordsURL;
    detail.mp3 = music.mp3;
    detail.title = music.title;
  
    wordController.detail = detail;
//    wordController.title = detail.title;
    [self.navigationController pushViewController:wordController animated:YES];
}
@end
