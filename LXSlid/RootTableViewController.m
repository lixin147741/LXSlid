//
//  RootTableViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/20.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "RootTableViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "CocoaSecurity.h"
#import "MJRefresh.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DetialViewController.h"
#import "Section.h"
#import "Artical.h"
#import "OnePictureTableViewCell.h"
#import "ThreePictureTableViewCell.h"

#define baseURL "http://www.pentaq.com/api/articledaily"
#define privateKey "d2VuZGFjcC4zMTU4LmNudsdf"

@interface RootTableViewController ()
- (void)loadData:(NSString *)singleURL;
@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _articals = [[NSMutableArray alloc] init];
    
    [self setNeedsStatusBarAppearanceUpdate];
    if (!_navigationTitle) {
        [self.navigationItem setTitle:_navigationTitle];
    }
    //导航栏上面的title
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = _navigationTitle;
    [self.navigationItem setTitleView:_label];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    //导航栏添加右滑手势
    [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    //tableView添加右滑手势
    [self.tableView addGestureRecognizer:revealViewController.panGestureRecognizer];
    //设置右上角的BarButtonItem
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    //注册TableViewCell
    if (!_nib1 || !_nib2) {
        _nib1 = [UINib nibWithNibName:@"CellForOnePicture" bundle:nil];
        [self.tableView registerNib:_nib1 forCellReuseIdentifier:@"cellForOnePicture"];
        _nib2 = [UINib nibWithNibName:@"CellForThreePicture" bundle:nil];
        [self.tableView registerNib:_nib2 forCellReuseIdentifier:@"cellForThreePicture"];
    }
    self.tableView.backgroundColor = [UIColor grayColor];
    
    _page = 1;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    //加载完界面马上开始加载数据
    [self.tableView.header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];


}

#pragma public methods

- (void)loadData: (NSString *)singleURL {
    //加载tableView中的数据
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSInteger time = [NSDate date].timeIntervalSince1970;
    CocoaSecurityResult *result = [CocoaSecurity md5:[NSString stringWithFormat:@"%s%ld", privateKey, (long)time]];
    NSString *token = result.base64;
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:[NSNumber numberWithInteger:time] forKey:@"time"];
    [para setObject:token forKey:@"token"];
    [para setObject:[NSNumber numberWithInt:2] forKey:@"today"];
    [para setObject:[NSNumber numberWithInt:_page] forKey:@"page"];
    [para setObject:[NSNumber numberWithInt:20] forKey:@"limit"];
    
    [manager GET:@"http://www.pentaq.com/api/articledaily" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            
            if ([[responseObject objectForKey:@"state"] integerValue] == 1) {
                
                //取数据成功
                NSArray *sectionsArray = [(NSDictionary *)responseObject objectForKey:@"daily"];
                
                for (NSDictionary *sec in sectionsArray) {
                    Section *section = [[Section alloc] init];
                    section.ymd = [sec objectForKey:@"ymd"];
                    section.articals = [[NSMutableArray alloc] init];
                    NSArray *arts = [sec objectForKey:@"data"];
                    for (NSDictionary *art in arts) {
                        Artical *artical = [[Artical alloc] init];
                        artical.author = [art objectForKey:@"author"];//作者
                        artical.cover = [art objectForKey:@"cover"];//封面
                        artical.articalID = [[art objectForKey:@"id"] integerValue];//ID
                        artical.imgURL = [art objectForKey:@"imgurl"];//大图地址
                        artical.ios_img = [art objectForKey:@"ios_img"];
                        artical.last_time = [art objectForKey:@"last_time"];
                        artical.last_ymd = [art objectForKey:@"last_ymd"];
                        artical.title = [art objectForKey:@"title"];//标题
                        artical.type = [art objectForKey:@"type"];//类型
                        [section.articals addObject:artical];
                    }
                    [_articals addObject:section];
                }
            }
            
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%@",error);
    }];
    
    _page++;

    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //根据类型判断行高
    if ([((Artical *)((Section *)_articals[indexPath.section]).articals[indexPath.row]).type isEqualToString:@"1"]) {
        return 90;
    } else {
        return 150;
    }
}
#pragma mark - 有一个问题。。
//如果不写这个方法，section header显示不出来
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"sss";
}

//设置section header的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = ((Section *)_articals[section]).ymd;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    label.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    label.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    if (section == 0) {
        label.textColor = [UIColor blackColor];
        return label;
    }
    
    return label;
    
}

//也有一个问题，默认值跟主页的默认值不一样。要比主页的默认值宽。必须手动更改
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_articals count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((Section *)_articals[section]).articals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Artical *artical = (((Section *)_articals[indexPath.section])).articals[indexPath.row];
    
    UITableViewCell *cell;
    
    if ([artical.type isEqualToString:@"1"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellForOnePicture"];
        ((OnePictureTableViewCell *)cell).label.text = artical.title;
        [((OnePictureTableViewCell *)cell).rightImageView sd_setImageWithURL:[NSURL URLWithString:artical.cover[0]] placeholderImage:[UIImage imageNamed:@"LOGO－z"]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellForThreePicture"];
        ((ThreePictureTableViewCell *)cell).label.text = artical.title;
        
        [((ThreePictureTableViewCell *)cell).imageView1 sd_setImageWithURL:[NSURL URLWithString:artical.cover[0]] placeholderImage:[UIImage imageNamed:@"LOGO－z"]];
        [((ThreePictureTableViewCell *)cell).imageView2 sd_setImageWithURL:[NSURL URLWithString:artical.cover[1]] placeholderImage:[UIImage imageNamed:@"LOGO－z"]];
        [((ThreePictureTableViewCell *)cell).imageView3 sd_setImageWithURL:[NSURL URLWithString:artical.cover[2]] placeholderImage:[UIImage imageNamed:@"LOGO－z"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Artical *artical = (((Section *)_articals[indexPath.section])).articals[indexPath.row];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetialViewController *detialViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DetialViewController"];
    detialViewController.articalID = artical.articalID;
    
    
    [self.navigationController pushViewController:detialViewController animated:YES];
    //如果在侧滑菜单显示的时候触发，则隐藏侧滑菜单
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    /*
     //隐藏导航栏
     [self.navigationController setNavigationBarHidden:YES animated:NO];
     self.navigationController.title = [NSString stringWithFormat:@"第%ld个", (long)indexPath.row];
     */
}







@end
