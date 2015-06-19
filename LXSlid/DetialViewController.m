//
//  DetialViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/18.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "DetialViewController.h"

@interface DetialViewController ()

@end

@implementation DetialViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, 400, 100, 44);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goback) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
