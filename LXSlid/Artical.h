//
//  Artical.h
//  LXSlid
//
//  Created by 李鑫 on 15/6/21.
//  Copyright (c) 2015年 李鑫. All rights reserved.
//

#ifndef LXSlid_Artical_h
#define LXSlid_Artical_h
#import <UIKit/UIKit.h>

@interface Artical : NSObject

@property (nonatomic) NSInteger articalID;//文章编号
@property (copy, nonatomic) NSString *author;//文章作者
@property (strong, nonatomic) NSMutableArray *cover;//封面
@property (copy, nonatomic) NSString *imgURL;//文章首页大图
@property (copy, nonatomic) NSString *ios_img;
@property (copy, nonatomic) NSString *last_time; //1434556800
@property (copy, nonatomic) NSString *last_ymd;  //2015-06-18
@property (copy, nonatomic) NSString *title; //文章标题
@property (copy, nonatomic) NSString *type;

@end

#endif
