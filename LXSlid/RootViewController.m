//
//  ViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/13.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "RootViewController.h"
#import "SWRevealViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *MenuButton;

@end

@implementation RootViewController

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ShowWidth 0.5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.MenuButton setTarget:revealViewController];
        [self.MenuButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        revealViewController.rearViewRevealOverdraw = 0;
        revealViewController.rearViewRevealWidth = ScreenWidth * ShowWidth;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
