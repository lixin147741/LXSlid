//
//  DetialViewController.h
//  LXSlid
//
//  Created by 李鑫 on 15/6/18.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetialViewController : UIViewController

@property (nonatomic) NSInteger articalID;
@property (strong, nonatomic) NSString *headerImageURL;
@property (strong, nonatomic) NSString *webViewURL;


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
//中间那一部分的父容器
@property (weak, nonatomic) IBOutlet UIImageView *blueImageView;
@property (weak, nonatomic) IBOutlet UILabel *cateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForWebview;

@end
