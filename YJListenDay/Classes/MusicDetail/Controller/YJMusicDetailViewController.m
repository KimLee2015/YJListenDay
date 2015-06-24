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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.view.window.rootViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
    // except 6+
    [self performSegueWithIdentifier:@"ShowWord" sender:indexPath];
  } else { // iPad
    self.splitViewDetail.detail = self.musicDetails[indexPath.row];
  }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowWord"]) {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    YJWordViewController *wordViewController = segue.destinationViewController;
    YJMusicDetail *detail = self.musicDetails[path.row];
    wordViewController.detail = detail;
  }
}
@end
