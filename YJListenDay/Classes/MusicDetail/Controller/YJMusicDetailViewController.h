//
//  YJMusicDetailViewController.h
//  ListenVideo
//
//  Created by Lee on 1/25/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJWordViewController;

@interface YJMusicDetailViewController : UITableViewController
/**
 *  MusicDetailxx.plist的URL
 */
@property (nonatomic,copy) NSString *detailURL;
/**
 *  cell中的图片的URL
 */
@property (nonatomic,copy) NSString *icon;

@property(nonatomic,weak) YJWordViewController *splitViewDetail;
@end
