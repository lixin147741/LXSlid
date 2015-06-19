//
//  LeftMenuHeaderViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/19.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "LeftMenuHeaderViewController.h"

@interface LeftMenuHeaderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation LeftMenuHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 28;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
