//
//  YJTestViewController.m
//  ListenVideo
//
//  Created by Lee on 2/7/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJTestViewController.h"
#import "MJAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@interface YJTestViewController ()
@end

@implementation YJTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MJAudioTool playMusic:@"Background.caf"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = @"asdasdas";
    return cell;
}

@end
