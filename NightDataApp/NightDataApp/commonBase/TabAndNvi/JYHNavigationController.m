//
//  JYHNavigationController.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "JYHNavigationController.h"
#import "JYHColor.h"

@interface JYHNavigationController ()

@end

@implementation JYHNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  

        
        // 禁用右滑切换
        self.interactivePopGestureRecognizer.enabled = NO;
        
        // 设置Bar背景色
        [self.navigationBar setBarTintColor:Color_blackBack];
    
//        [self.navigationBar setTintColor:Color_white];
        
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBack"] forBarMetrics:UIBarMetricsDefault];
        // 设置Bar不透明
        [self.navigationBar setTranslucent:YES];
   
    
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:Color_white forKey:UITextAttributeTextColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (MMDrawerController *) getMainFrameControllerClass {
//    UIViewController *parentViewController = self.parentViewController;
//    while (parentViewController != nil) {
//        if([parentViewController isKindOfClass:[MMDrawerController class]]){
//            return (MMDrawerController *)parentViewController;
//        }
//        parentViewController = parentViewController.parentViewController;
//    }
//    return nil;
//}

- (UINavigationItem *)navigationItem{
    UINavigationItem * item = [super navigationItem];
    
    item.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    return item;
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    self.navigationItem.backBarButtonItem = item;
    
    
//    if (self.viewControllers.count > 0) {
//        
//        viewController.hidesBottomBarWhenPushed = YES;
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.5f;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.type = kCATransitionPush;
//        animation.subtype = kCATransitionFromRight;
//        [self.navigationController.view.layer addAnimation:animation forKey:nil];
//        [super pushViewController:viewController animated:NO];
//        return;
//    }
//    [super pushViewController:viewController animated:YES];
    
    
    
    [super pushViewController:viewController animated:YES];
}

//- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    [[self getMainFrameControllerClass] setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//
//    [super pushViewController:viewController animated:animated];
//}
//
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//
//
////    if([self.parentViewController isKindOfClass:[MMDrawerController class]]){
////        [[self getMainFrameControllerClass] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
////    }
//    
//    return [super popViewControllerAnimated:animated];
//}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    if(self.mm_drawerController.showsStatusBarBackgroundView){
//        return UIStatusBarStyleLightContent;
//    }
//    else {
//        return UIStatusBarStyleDefault;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
