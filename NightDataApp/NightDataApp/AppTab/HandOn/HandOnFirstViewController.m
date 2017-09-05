//
//  HandOnFirstViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/11.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "HandOnFirstViewController.h"

@interface HandOnFirstViewController ()

@end

@implementation HandOnFirstViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@"Send"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
