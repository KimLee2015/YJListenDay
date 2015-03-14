//
//  YJWordViewController.h
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJMusicDetail;
@interface YJWordViewController : UIViewController
@property (nonatomic,strong) YJMusicDetail *detail;

/**
 *  停止播放听力
 */
- (void)stopPlayMusic;
@end
