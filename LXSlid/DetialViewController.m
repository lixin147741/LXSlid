//
//  DetialViewController.m
//  LXSlid
//
//  Created by 李鑫 on 15/6/18.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//
//
//  www.pentaq.com/api/ArticleDetail
//
#import "DetialViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "CocoaSecurity.h"
//#import "Global.h"

#define baseURL "http://www.pentaq.com/api/ArticleDetail"
#define privateKey "d2VuZGFjcC4zMTU4LmNudsdf"

@interface DetialViewController () <UIWebViewDelegate>

@end

@implementation DetialViewController

#pragma Mark - private method
- (void)loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSInteger time = [NSDate date].timeIntervalSince1970;
    CocoaSecurityResult *result = [CocoaSecurity md5:[NSString stringWithFormat:@"%s%ld", privateKey, (long)time]];
    NSString *token = result.base64;
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:[NSNumber numberWithInteger:time] forKey:@"time"];
    [para setObject:token forKey:@"token"];
    [para setObject:[NSNumber numberWithInteger:_articalID] forKey:@"id"];
    
    [manager GET:@baseURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            
            if ([[responseObject objectForKey:@"state"] integerValue] == 1) {
                
                //取数据成功
                NSArray *sectionsArray = [(NSDictionary *)responseObject objectForKey:@"data"];
                
                _cateNameLabel.text = [sectionsArray valueForKey:@"cate_name"];
                _authorLabel.text = [sectionsArray valueForKey:@"author"];
                _titleLabel.text = [sectionsArray valueForKey:@"title"];
                _timeLabel.text = [sectionsArray valueForKey:@"updateymd"];
                _headerImageURL = [sectionsArray valueForKey:@"author_headerurl"];
                _webViewURL = [sectionsArray valueForKey:@"html"];
                
                _webView.delegate = self;
                //_webview.
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewURL]]];
            }
        
        }
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF%@",error);
    }];

}

- (void)hideAllSubviews {
    _headerImageView.hidden = YES;
    _myImageView.hidden = YES;
    _blueImageView.hidden = YES;
    _cateNameLabel.hidden = YES;
    _timeLabel.hidden = YES;
    _authorLabel.hidden = YES;
    _titleLabel.hidden = YES;
    _webView.hidden = YES;
}

- (void)showAllSubviews {
    _headerImageView.hidden = NO;
    _myImageView.hidden = NO;
    _blueImageView.hidden = NO;
    _cateNameLabel.hidden = NO;
    _timeLabel.hidden = NO;
    _authorLabel.hidden = NO;
    _titleLabel.hidden = NO;
    _webView.hidden = NO;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self showAllSubviews];
    //CGFloat height = _webView.frame.size.height;
    
    CGRect frame = _webView.frame;
    frame.size.height = 1;
    _webView.frame = frame;
    CGSize fittingSize = [_webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    _webView.frame = frame;
    
    _heightForWebview.constant = frame.size.height;
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    //fittingSize就是这个webview load完网页之后的真实大小
    
    [_scrollView setContentSize:_webView.frame.size];
    [SVProgressHUD dismiss];
}

- (void)loadView {
    
    [super loadView];
    
    [SVProgressHUD show];
    
    [self loadData];
    
    [self hideAllSubviews];
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    //[self.navigationItem setHidesBackButton:YES];
    //self.navigationItem.hidesBackButton = NO;
    
}

- (void)viewDidLoad {\
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(goback)];
    [self.view addGestureRecognizer:pan];
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
