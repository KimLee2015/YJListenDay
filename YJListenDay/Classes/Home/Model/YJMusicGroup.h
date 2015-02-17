//
//  YJMusicGroup.h
//  ListenVideo
//
//  Created by Lee on 1/23/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJMusicGroup : NSObject
/**
 *  音乐图片的URL
 */
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
/**
 *  一个专栏拥有的音频数
 */
@property (nonatomic,assign) int count;
/**
 *  音乐描述文件的URL
 */
@property (nonatomic,copy) NSString *detailURL;
@end
