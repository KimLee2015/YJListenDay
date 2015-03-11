//
//  YJTopMusic.h
//  ListenVideo
//
//  Created by Lee on 1/26/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJTopMusic : NSObject
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
/**
 *  播放mp3文件名
 */
@property (nonatomic,copy) NSString *mp3;
/**
 *  wordsxx.plist文件
 */
@property (nonatomic,copy) NSString *wordsURL;
@end
