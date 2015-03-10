//
//  YJHeaderView.h
//  ListenVideo
//
//  Created by Lee on 1/27/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJHeaderView,YJTopMusic;

@protocol YJHeaderViewDelegate <NSObject>
- (void)headerView:(YJHeaderView *)headerView didSelectedCell:(YJTopMusic *)music;
@end

@interface YJHeaderView : UIView
@property(nonatomic,weak) id delegate;
+ (instancetype)view;
/**
 *  headView的高度
 */
+ (CGFloat)height;
@end
