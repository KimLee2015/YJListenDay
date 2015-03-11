//
//  YJNavigationController.m
//  ListenVideo
//
//  Created by Lee on 1/23/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "YJNavigationController.h"

@interface YJNavigationController ()

@end

@implementation YJNavigationController

+ (void)initialize
{
    // 1. 设置导航栏主题
    [self setupNavBarTheme];
    // 2. 设置导航栏按钮主题
    [self setupBarButtonItemTheme];
}

+ (void)setupNavBarTheme
{
    UINavigationBar *bar = [UINavigationBar appearance];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:13];
    [bar setTitleTextAttributes:attributes];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
