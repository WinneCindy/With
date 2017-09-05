//
//  MainTabBarController.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/19.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "MainTabBarController.h"
#import "JYHColor.h"
#import "JYHTabBarItem.h"
#import "JYHNavigationController.h"
#import "RDVTabBarItem.h"
#import "ViewController.h"

#import "WithFirstFloorViewController.h"
#import "ActivityViewController.h"
#import "ChatFirstFloorViewController.h"
#import "MineFirstFloorViewController.h"
#import "MineTabViewController.h"
#import "HandOnFirstViewController.h"

@interface MainTabBarController ()

@property (retain,nonatomic) RDVTabBarItem * homeItem;

- (void) initTabBarDefaultStyle;

//- (IBAction)onHomeItemClick:(id)sender;

@end

@implementation MainTabBarController

@synthesize homeItem = _homeItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.navigationItem != nil){
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    UIView * mView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];//这是整个tabbar的颜色
    [mView setBackgroundColor:getUIColor(Color_black)];
    [self.tabBar insertSubview:mView atIndex:1];
    [self setTabBarHidden:YES];
    
    [self setRigthButtonDefaultStyle];
//    [[UITabBar appearance] setBackgroundColor:getUIColor(Color_tabbarbackcolor)];
    
//    [self.tabBar.backgroundView setBackgroundColor:getUIColor(Color_tabbarbackcolor)]; 
    
    [[RDVTabBarItem appearance] setSelectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil]];
    
    [[RDVTabBarItem appearance] setUnselectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil]];
    
    // Add TabItem
    [self initTabBarDefaultStyle];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBar layoutSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initTabBarDefaultStyle {
    // 1
    UIViewController *With = [[WithFirstFloorViewController alloc] init];
    UIViewController * Activity = [[ActivityViewController alloc] init];
//    UIViewController *hand = [[HandOnFirstViewController alloc] init];
    UIViewController *chat = [[ChatFirstFloorViewController alloc] init];
    UIViewController *mine = [[MineFirstFloorViewController alloc] init];
    self.viewControllers = [[NSArray alloc] initWithObjects:Activity,With,chat,mine,nil];
    RDVTabBarItem *aTabBarItem = [self.tabBar.items objectAtIndex:0];
    // Set Title
    aTabBarItem.title = @"WITH";;
    [aTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home"] withFinishedUnselectedImage:[UIImage imageNamed:@"home-hui"]];
    
    RDVTabBarItem *bTabBarItem = [self.tabBar.items objectAtIndex:1];
    // Set Title
    bTabBarItem.title = @"ACTIVITY";;
    [bTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"youpin"] withFinishedUnselectedImage:[UIImage imageNamed:@"youpin-hui"]];
    
    RDVTabBarItem *cTabBarItem = [self.tabBar.items objectAtIndex:2];
    // Set Title
    cTabBarItem.title = @"";;
    [cTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"jiangxin"] withFinishedUnselectedImage:[UIImage imageNamed:@"jiangxin-hui"]];
//
//    RDVTabBarItem *dTabBarItem = [self.tabBar.items objectAtIndex:3];
//    // Set Title
//    dTabBarItem.title = @"CHAT";;
//    [dTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"wode"] withFinishedUnselectedImage:[UIImage imageNamed:@"wode-hui"]];
    

    RDVTabBarItem *eTabBarItem = [self.tabBar.items objectAtIndex:2];
    // Set Title
    eTabBarItem.title = @"MINE";;
    [eTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"wode"] withFinishedUnselectedImage:[UIImage imageNamed:@"wode-hui"]];
    
    
//    [aTabBarItem setSelectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil]];
//    
//    [aTabBarItem setUnselectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil]];
    
}


- (void) setRigthButtonDefaultStyle {
    
    UIButton * buttonImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    [buttonImage setBackgroundImage:[UIImage imageNamed:@"navbarrightbutton"] forState:UIControlStateNormal];
    [buttonImage setBackgroundImage:[UIImage imageNamed:@"navbarrightbutton_selected"] forState:UIControlStateHighlighted];
    
//    [buttonImage addTarget:self action:@selector(viewMoreViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonImage];
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
