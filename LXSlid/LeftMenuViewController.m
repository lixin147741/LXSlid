//
//  LeftMenuViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/13.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SWRevealViewController.h"
#import "RootViewController.h"

@interface LeftMenuViewController () 
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger _presentedRow;
@end

@implementation LeftMenuViewController
- (IBAction)showConfigureViewController:(id)sender {
    //显示设置页面
}

//菜单中的数据
NSMutableArray *menuArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:42.0/255.0 blue:48.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    /*
    self.tableView.tableHeaderView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        //自动调整图片的位置，保证水平居中
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        //FIXME 增加网络请求加载图片
        imageView.image = [UIImage imageNamed:@"user"];
        
        //启用裁剪，超过父视图的部分被剪掉
        imageView.layer.masksToBounds = YES;
        //设置圆角
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        //光栅化
        imageView.layer.shouldRasterize = YES;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        //Fixme  增加网络请求
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Kee";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        //调整位置
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        
        view;
    });
    */
    [self loadData];

}

#pragma mark - loadData

- (void)loadData {
    menuArray = [[NSMutableArray alloc] init];
    [menuArray addObject:@"今日"];
    [menuArray addObject:@"赛事"];
    [menuArray addObject:@"特稿"];
    [menuArray addObject:@"魔鬼数据"];
    [menuArray addObject:@"人物"];
    [menuArray addObject:@"刺猬专栏"];
    [menuArray addObject:@"拳头解密"];
    [menuArray addObject:@"图说"];
    [menuArray addObject:@"PentaQ News"];
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    //如果是刚才的，直接返回
    if (row == self._presentedRow) {
        [revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    
    //否则创建一个新的，然后返回
    UIViewController *newFrontController = nil;
    
    RootViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    
    newFrontController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    /*
    switch (row) {
        case 0: {
            //今日
            RootViewController *rootViewController = [[RootViewController alloc] init];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        }
            break;
        case 1: {
            //赛事
        }
            break;
        case 2: {
            //特稿
        }
            
            break;
        case 3: {
            //魔鬼数据
        }
            
            break;
        case 4: {
            //人物
        }
            
            break;
        case 5: {
            //刺猬专栏
        }
            
            break;
        case 6: {
            //拳头解密
        }
            
            break;
        case 7: {
            //图说
        }
            
            break;
        case 8: {
            //PentaQ News
        }
            
            break;
        default:
            break;
    }
    */
    [revealViewController pushFrontViewController:newFrontController animated:YES];
    
    
    self._presentedRow = row;
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [menuArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    NSString *imageName = [NSString stringWithFormat:@"%@－2", [menuArray objectAtIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
