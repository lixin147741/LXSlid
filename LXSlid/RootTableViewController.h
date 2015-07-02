//
//  RootTableViewController.h
//  LXSlid
//
//  Created by 李鑫 on 15/6/20.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewController : UITableViewController

@property (strong, nonatomic) UINib *nib1;
@property (strong, nonatomic) UINib *nib2;

@property (copy, nonatomic) NSString *navigationTitle;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSMutableArray *articals;
@property (nonatomic) int page;
@end
