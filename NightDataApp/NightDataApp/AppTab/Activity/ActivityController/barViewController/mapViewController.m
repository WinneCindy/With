//
//  mapViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/3.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "mapViewController.h"

#define URL_MapUrl @"https://www.with17.cn/web/jquery-obj/static/webview/html/gaode.html"

@interface mapViewController ()<UIWebViewDelegate>

@end

@implementation mapViewController
{
    UIWebView *web;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置";
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [self createScrollerView];
    // Do any additional setup after loading the view.
}

-(void)createScrollerView
{
    
    //
    
    
    
    
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:web];
    
    web.scrollView.scrollsToTop = YES;
    
    UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    
    NSURLRequest *request;
    web.delegate = self;
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?position_start_x=%@&position_start_y=%@&position_end_x=%@&position_end_y=%@",URL_MapUrl,_positionStart_x,_positionStart_y,_positionEnd_x,_positionEnd_y]];
    
    request =[NSURLRequest requestWithURL:url];
    
    
    [web loadRequest:request];
    
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
