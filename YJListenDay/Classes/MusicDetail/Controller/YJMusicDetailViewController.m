//
//  YJMusicDetailViewController.m
//  ListenVideo
//
//  Created by Lee on 1/25/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClick)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJDetailCell *cell = [YJDetailCell cellWithTableView:tableView];
    cell.detail = self.musicDetails[indexPath.row];
    cell.icon = self.icon;
    return cell;
}

#pragma mark - 跳转控制器
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    self.wordViewController = segue.destinationViewController;
    self.wordViewController.detail = self.musicDetails[path.row];
}

#pragma mark - YJWordViewController 返回
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    [self.wordViewController stopPlayMusic];
}
@end
