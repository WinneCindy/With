//
//  actionSuccessViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "actionSuccessViewController.h"

@interface actionSuccessViewController ()

@end

@implementation actionSuccessViewController
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
    
   
    [self.view addSubview:imageView];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFill];

    
    if (_ifsuccess) {
         [imageView setImage:[UIImage imageNamed:@"alertSuccess"]];
    } else {
         [imageView setImage:[UIImage imageNamed:@"alertFalid"]];
    }

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
