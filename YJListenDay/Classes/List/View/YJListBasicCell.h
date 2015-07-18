//
//  YJListBasicCell.h
//  ListenVideo
//
//  Created by Lee on 1/24/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJMusicGroup;

@interface YJListBasicCell : UITableViewCell
@property (nonatomic,strong) YJMusicGroup *musicGroup;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHight;
+ (NSString *)ID;
@end
