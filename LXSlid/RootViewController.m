//
//  ViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/13.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "RootViewController.h"
#import "SWRevealViewController.h"
#import "DetialViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CocoaSecurity.h"
#import "SDWebImage/UIImageView+WebCache.h"

#import "Section.h"
#import "Artical.h"
#import "OnePictureTableViewCell.h"
#import "ThreePictureTableViewCell.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *articals;
@property (nonatomic) int page;
//@property (strong, nonatomic) NSMutableArray *banners;
//@property (strong, nonatomic) UIPageControl *pageControl;
//@property (strong, nonatomic) NSTimer *timer;

@end

@implementation RootViewController

//#define PictureHeight 220  //轮播图片的高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width//屏幕宽度
#define ShowWidth 0.7 //左边的菜单弹出来时占屏幕多少

#define baseURL "http://www.pentaq.com/api/articledaily"
#define privateKey "d2VuZGFjcC4zMTU4LmNudsdf"


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _articals = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    //SWRevealViewController  Settings
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.menuButton setTarget:revealViewController];
        [self.menuButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
        
        revealViewController.rearViewRevealOverdraw = 0;
        revealViewController.rearViewRevealWidth = ScreenWidth * ShowWidth;
    }
    
    //TableView Settings
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self.tableView registerClass:[OnePictureTableViewCell class] forCellReuseIdentifier:@"cellForOnePicture"];
    if (!_nib1 || !_nib2) {
        _nib1 = [UINib nibWithNibName:@"CellForOnePicture" bundle:nil];
        [self.tableView registerNib:_nib1 forCellReuseIdentifier:@"cellForOnePicture"];
        _nib2 = [UINib nibWithNibName:@"CellForThreePicture" bundle:nil];
        [self.tableView registerNib:_nib2 forCellReuseIdentifier:@"cellForThreePicture"];
    }
    

    self.tableView.backgroundColor = [UIColor grayColor];
    //NavagationBar Settings
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"首页";
    [self.navigationItem setTitleView:label];
    
    _page = 1;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //加载完界面马上开始加载数据
    [self.tableView.header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   // [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//传入要加载的页数
- (void)loadData {
    
    NSLog(@"%d",_page);
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }
    
    return ((Section *)_articals[section]).ymd;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_articals count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((Section *)_articals[section]).articals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Artical *artical = (((Section *)_articals[indexPath.section])).articals[indexPath.row];

    /*
    artical.images = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (NSString *s in artical.cover) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:s]]];
            [artical.images addObject:image];
        }
    });
     */
    
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
    
    DetialViewController *detialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetialViewController"];
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
