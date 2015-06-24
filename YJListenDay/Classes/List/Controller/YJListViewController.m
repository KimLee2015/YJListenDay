#import "YJListViewController.h"
#import "YJListBasicCell.h"
#import "MJExtension.h"
#import "UIView+MJ.h"
#import "YJMusicDetailViewController.h"
#import "YJWordViewController.h"
#import "YJMusicGroup.h"
#import "YJMusicDetail.h"
#import "MJAudioTool.h"
#import "YJTopMusic.h"
#import "YJTopMusicCell.h"

@interface YJListViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSArray *musicGroups;
@property (nonatomic,strong) NSArray *topMusics;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

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
        self.pageControl.numberOfPages = _topMusics.count;
    }
    return _topMusics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    UICollectionViewFlowLayout *layout = (id) self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.collectionView.bounds.size.height);
    self.pageControl.numberOfPages = self.topMusics.count;
    
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topMusics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YJTopMusicCell *cell = [YJTopMusicCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.topMusic = self.topMusics[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)((scrollView.contentOffset.x +scrollView.frame.size.width * 0.5)/ scrollView.frame.size.width);
    self.pageControl.currentPage = page;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YJWordViewController *wordController = [story instantiateViewControllerWithIdentifier:@"words"];
    YJMusicDetail *detail = [[YJMusicDetail alloc] init];
    YJTopMusic *top = self.topMusics[indexPath.row];
    detail.wordsURL = top.wordsURL;
    detail.mp3 = top.mp3;
    detail.title = top.title;
    
    wordController.detail = detail;
    [self.navigationController pushViewController:wordController animated:YES];
}
@end
