//
//  YJMusic.h
//  ListenVideo
//
//  Created by Lee on 1/31/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJWord : NSObject
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) double time;
@property (nonatomic,assign,getter=isPlayed) BOOL play;
@end
