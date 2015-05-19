#import "YJMusicDetailViewController.h"
#import "YJMusicDetail.h"
#import "YJDetailCell.h"
#import "MJExtension.h"
#import "YJWordViewController.h"

@interface YJMusicDetailViewController ()
/**
 *  YJMusicDetail
 */
@property (nonatomic,strong) NSArray *musicDetails;
@property(nonatomic,weak) YJWordViewController *wordViewController;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@end

@implementation YJMusicDetailViewController

- (NSArray *)musicDetails
{
    if (!_musicDetails) {
        _musicDetails = [YJMusicDetail objectArrayWithFilename:self.detailURL];
    }
    return _musicDetails;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor blackColor];
  self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.2];
  self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

#pragma mark - UITableViewDataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [self basicCellAtIndexPath:indexPath];
}

- (YJDetailCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath
{
    YJDetailCell *cell = [YJDetailCell cellWithTableView:self.tableView];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(YJDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.detail = self.musicDetails[indexPath.row];
    cell.icon = self.icon;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSIndexPath *path = [self.tableView indexPathForSelectedRow];
  self.wordViewController = segue.destinationViewController;
  YJMusicDetail *detail = self.musicDetails[path.row];
  self.wordViewController.detail = detail;
}

#pragma mark - UnWind

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    [self.wordViewController stopPlayMusic];
}
@end
