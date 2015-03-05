//
//  YJMusic.h
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
// 代表听力中每段对话

#import <Foundation/Foundation.h>

@interface YJWord : NSObject
/**
 *  播放文本
 */
@property (nonatomic,copy) NSString *text;
/**
 *  播放时间
 */
@property (nonatomic,assign) double time;
/**
 *  播放状态
 */
@property (nonatomic,assign,getter=isPlayed) BOOL play;
@end
