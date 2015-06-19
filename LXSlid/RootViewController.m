//
//  ViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/13.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "RootViewController.h"
#import "SWRevealViewController.h"
#import "UINavigationBar+Awesome.h"
#import "DetialViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *MenuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *banners;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RootViewController

#define PictureHeight 220  //轮播图片的高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define ShowWidth 0.5 //左边的菜单弹出来时占屏幕多少
#define RootViewCell @"RootViewCell"

#define NAVBAR_CHANGE_POINT 50

//添加图片轮播
- (void)loadView {
    [super loadView];
    
    [self loadData];
    
    self.tableView.tableHeaderView = ({
        
        //UIScrollView Settings
        UIScrollView *headerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, PictureHeight)];
        headerView.contentSize = CGSizeMake(_banners.count * ScreenWidth, PictureHeight);
        
        for (int i = 0; i < _banners.count; i++) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, PictureHeight)];
            image.image = [_banners objectAtIndex:i];
            [headerView addSubview:image];
        }
        
        //隐藏横向进度条
        headerView.showsHorizontalScrollIndicator = NO;
        //允许分页
        headerView.pagingEnabled = YES;
        headerView.delegate = self;
        
        //UIPageController Settings
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, PictureHeight - 20, _tableView.frame.size.width, 20)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = _banners.count;
        [_pageControl addTarget:self action:@selector(pageControlTouched) forControlEvents:UIControlEventValueChanged];
        
        [_tableView addSubview:_pageControl];
        
        headerView;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //SWRevealViewController  Settings
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.MenuButton setTarget:revealViewController];
        [self.MenuButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        revealViewController.rearViewRevealOverdraw = 0;
        revealViewController.rearViewRevealWidth = ScreenWidth * ShowWidth;
    }
    
    //TableView Settings
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RootViewCell];
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //NavagationBar Settings
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(nextBanner) userInfo:nil repeats:YES];
}

- (void)nextBanner {
    
    NSInteger currentPage = _pageControl.currentPage;
    currentPage++;
    
    if (currentPage == [_banners count]) {
        currentPage = 0;
    }

    UIScrollView *header = (UIScrollView *)_tableView.tableHeaderView;
    
    if (currentPage == 0) {
        [header scrollRectToVisible:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height) animated:NO];
    } else {
        [header setContentOffset:CGPointMake(currentPage * header.frame.size.width, 0) animated:YES];
    }

}

#pragma UIpageControl Target

- (void)pageControlTouched {
    
    [_timer invalidate];
    
    NSInteger currentPage = _pageControl.currentPage;
    
    UIScrollView *header = (UIScrollView *)_tableView.tableHeaderView;
    
    [header setContentOffset:CGPointMake(currentPage * header.frame.size.width, 0) animated:YES];

}

#pragma ScrollView delegate

//监听了两个ScrollView，一个是TableView，一个是TableHeaderView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.class == UITableView.class) {
        
        //如果是TableView的下拉事件
        UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
            
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }

    } else {
        //如果是滑动Banner事件
        [_timer invalidate];
        
        NSInteger pageWidth = _tableView.bounds.size.width;
        
        NSInteger page = [NSNumber numberWithInt:(scrollView.contentOffset.x + pageWidth / 2) / pageWidth].intValue;
        _pageControl.currentPage = page;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}


- (void)loadData {
    //加载tableView中的数据
    _items = [[NSMutableArray alloc] init];
    for (int i = 0;i <= 20; i++) {
        [_items addObject:[NSString stringWithFormat:@"第%d个",i]];
    }
    //加载TableView TableHeaderView中的图片
    _banners = [[NSMutableArray alloc] init];
    [_banners addObject:[UIImage imageNamed:@"bg.jpg"]];
    [_banners addObject:[UIImage imageNamed:@"bg.jpg"]];
    [_banners addObject:[UIImage imageNamed:@"bg.jpg"]];
    [_banners addObject:[UIImage imageNamed:@"bg.jpg"]];
}

#pragma tableView Datasouse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RootViewCell];
    
    cell.textLabel.text = [_items objectAtIndex:[indexPath row]];
    cell.imageView.image = [UIImage imageNamed:@"user"];
    
    return cell;
}

#pragma tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetialViewController *detialViewController = [[DetialViewController alloc] init];
    
    [self.navigationController pushViewController:detialViewController animated:YES];
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.title = [NSString stringWithFormat:@"第%ld个", (long)indexPath.row];
}

@end
