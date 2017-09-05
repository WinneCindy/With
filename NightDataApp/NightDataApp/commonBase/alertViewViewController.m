//
//  alertViewViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/23.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "alertViewViewController.h"

@interface alertViewViewController ()

@end

@implementation alertViewViewController
{
    NSTimer *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackImage];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
    
    timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closeSelf) userInfo:nil repeats:NO];

    // Do any additional setup after loading the view.
}

-(void)closeSelf
{
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)createBackImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    imageView.center = self.view.center;
    
    [imageView setImage:[UIImage imageNamed:@"qianDaoAlert"]];
    [self.view addSubview:imageView];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UILabel *alertDetail = [UILabel new];
    [self.view addSubview:alertDetail];
    alertDetail.sd_layout
    .topSpaceToView(self.view, 302.0 / 667.0 * SCREEN_HEIGHT)
    .centerXEqualToView(self.view)
    .heightIs(50)
    .widthIs(250);
    [alertDetail setText:_moneyTitle];
    [alertDetail setTextColor:Color_Gold];
    [alertDetail setFont:[UIFont boldSystemFontOfSize:48]];
    [alertDetail setNumberOfLines:0];
    [alertDetail setTextAlignment:NSTextAlignmentCenter];
    
    
    
    UIButton *backBtn = [UIButton new];
    [self.view addSubview:backBtn];
    backBtn.sd_layout
    .rightSpaceToView(self.view, 34.0 / 375.0 * SCREEN_WIDTH)
    .topSpaceToView(self.view, 88.0 / 667.0 * SCREEN_HEIGHT)
    .heightIs(50)
    .widthIs(50);
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
