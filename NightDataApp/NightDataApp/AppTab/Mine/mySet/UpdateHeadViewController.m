//
//  UpdateHeadViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//
#import "UIViewController+XHPhoto.h"

#import "UpdateHeadViewController.h"

@interface UpdateHeadViewController ()

@end

@implementation UpdateHeadViewController
{
    BaseDomain *postUserInfo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的头像";
    [self.view setBackgroundColor:getUIColor(Color_black)];
    postUserInfo = [BaseDomain getInstance:NO];
    UIButton *buttonMenu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [buttonMenu setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonMenu];
    [buttonMenu addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    [self createHeadView];
    // Do any additional setup after loading the view.
}

-(void)menuClick
{
    [self showCanEdit:YES photo:^(UIImage *photo) {
        
        NSData * imageData = UIImagePNGRepresentation(photo);
        
        NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:base64 forKey:@"avatar"];
        
        [postUserInfo postData:URL_UpdataUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                
                
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSuccess" object:nil];
            }
            
        }];
        
    }];
}

-(void)createHeadView
{
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:head];
    
    head.center = self.view.center;
    [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:ImagePlaceHolderHead];
    
    
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
