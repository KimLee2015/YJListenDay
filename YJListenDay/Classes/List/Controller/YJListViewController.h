//
//  YJListViewController.h
//  ListenVideo
//
//  Created by Lee on 1/24/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJWordViewController.h"

@interface YJListViewController : UITableViewController
@property(nonatomic,weak) YJWordViewController *splitViewDetail;
@end
