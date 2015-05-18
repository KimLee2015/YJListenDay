//
//  YJMusicCell.h
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJWord,YJMusicCell;

@protocol YJMusicCellDelegate <NSObject>

@optional
- (void)didClickedLabel:(YJWord *)word;
@end

@interface YJMusicCell : UITableViewCell
@property (nonatomic,strong) YJWord *word;
@property(nonatomic,weak) id delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  cell中的文字高亮显示
 */
- (void)hightLighted;
/**
 *  普通显示
 */
- (void)normal;

- (CGFloat)cellHight;
@end
