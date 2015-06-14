//
//  AppDelegate.m
//  YJListenDay
//
//  Created by Lee on 15/2/12.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "YJListViewController.h"
#import "YJWordViewController.h"

@interface AppDelegate () <UIApplicationDelegate,UISplitViewControllerDelegate>
@property(nonatomic,weak) UISplitViewController *splitViewController;
@property(nonatomic,weak) UINavigationController *listNavigationController;
@property(nonatomic,weak) UINavigationController *wordNavigationViewController;
@property(nonatomic,weak) YJListViewController *listViewController;
@property(nonatomic,weak) YJWordViewController *wordViewController;
@end

@implementation AppDelegate
- (UISplitViewController *)splitViewController
{
  return (UISplitViewController *)self.window.rootViewController;
}

- (UINavigationController *)listNavigationController
{
  return self.splitViewController.viewControllers.firstObject;
}

- (YJListViewController *)listViewController
{
  return (YJListViewController *)self.listNavigationController.topViewController;
}

- (UINavigationController *)wordNavigationViewController
{
  return self.splitViewController.viewControllers.lastObject;
}

- (YJWordViewController *)wordViewController
{
  return (YJWordViewController *)self.wordNavigationViewController.topViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  [self customizeAppearance];
  self.wordViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  self.listViewController.splitViewDetail = self.wordViewController;
  self.splitViewController.delegate = self;
  

  return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
  if ([secondaryViewController isKindOfClass:[UINavigationController class]]) {
    return YES;
  }
  return NO;
}

- (void)customizeAppearance {
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [UINavigationBar appearance].barTintColor = [UIColor blackColor];
  NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
  textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
  [UINavigationBar appearance].titleTextAttributes = textAttrs;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
