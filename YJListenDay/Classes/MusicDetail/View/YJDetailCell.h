//
//  YJDetailCell.h
//  ListenVideo
//
//  Created by Lee on 1/25/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJMusicDetail;
@interface YJDetailCell : UITableViewCell
/**
 *  图片URL
 */
@property (nonatomic,copy) NSString *icon;
/**
 *  MusicDetailxx.plist URL
 */
@property (nonatomic,strong) YJMusicDetail *detail;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
