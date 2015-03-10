//
//  MusicDetail.h
//  ListenVideo
//
//  Created by Lee on 1/25/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJMusicDetail : NSObject
@property (nonatomic,copy) NSString *title;
/**
 *  Musicxx.plist的URL
 */
@property (nonatomic,copy) NSString *wordsURL;
/**
 *  播放的mp3文件
 */
@property (nonatomic,copy) NSString *mp3;
@end
