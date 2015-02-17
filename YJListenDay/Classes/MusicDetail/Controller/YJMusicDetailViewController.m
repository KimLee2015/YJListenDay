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
#import "YJMusicViewController.h"

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    YJMusicViewController *control = segue.destinationViewController;
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    control.detail = self.musicDetails[path.row];
}
@end
