//
//  YJListViewController.m
//  ListenVideo
//
//  Created by Lee on 1/24/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJListViewController.h"
#import "YJHomeCell.h"
#import "MJExtension.h"
#import "YJHeaderView.h"
#import "UIView+MJ.h"
#import "YJMusicDetailViewController.h"
#import "YJWordViewController.h"
#import "YJMusicGroup.h"

#import "MJAudioTool.h"
#import "YJTopMusic.h"

@interface YJListViewController () <YJHeaderViewDelegate>
@property (nonatomic,strong) NSArray *musicGroups;
@end

@implementation YJListViewController

- (NSArray *)musicGroups
{
    if (!_musicGroups) {
        // 从网络上获取数据
        _musicGroups = [YJMusicGroup objectArrayWithFilename:@"list.plist"];
    }
    return _musicGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"YJHomeCell" bundle:nil] forCellReuseIdentifier:[YJHomeCell ID]];
    
}

#pragma mark - dataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicGroups.count * 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJHomeCell *cell = [YJHomeCell cellWithTableView:tableView];
    cell.musicGroup = self.musicGroups[indexPath.row % self.musicGroups.count];
    return cell;
}

#pragma mark - tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YJHomeCell cellHight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YJHeaderView *view = [YJHeaderView view];
    view.delegate = self;
    return view;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"asdasd";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [YJHeaderView height];
}

#pragma mark 跳转到音乐描述控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toMusicDetail" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController class] == [YJMusicDetailViewController class]) {
        YJMusicDetailViewController *control = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        YJMusicGroup *g = self.musicGroups[path.row % self.musicGroups.count];
        control.detailURL = g.detailURL;
        control.icon = g.icon;
    } else {
        YJWordViewController *music = segue.destinationViewController;
        music.detail = [yjmus]
    }
    
}

#pragma mark - YJHeaderViewDelegate
- (void)headerView:(YJHeaderView *)headerView didSelectedCell:(YJTopMusic *)music
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:[story instantiateViewControllerWithIdentifier:@"music"] animated:YES];
}
@end
