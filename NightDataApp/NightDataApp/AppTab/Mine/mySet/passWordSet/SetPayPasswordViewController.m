//
//  SetPayPasswordViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/10.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "setPayPasswordResultViewController.h"
@interface SetPayPasswordViewController ()<UITextFieldDelegate>

@end

@implementation SetPayPasswordViewController
{
    BaseDomain *getPayCheck;
    
    UITextField *nameText;
    UITextField *checkText;
    UIButton *buttonCheck;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    getPayCheck = [BaseDomain getInstance:NO];
    
    [self.view setBackgroundColor:Color_blackBack];
    [self crecteNameTextField];
    
    UIButton *butDone = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 69, 40)];
    [butDone setTitle:@"下一步" forState:UIControlStateNormal];
    [butDone setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    
    
    [butDone.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:butDone];
    [butDone addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

-(void)nextClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:checkText.text forKey:@"code"];
    [getPayCheck postData:URL_CheckPayCheck PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            setPayPasswordResultViewController *setPay = [[setPayPasswordResultViewController alloc] init];
            [self.navigationController pushViewController:setPay animated:YES];
        }
    }];
}

-(void)crecteNameTextField
{
    UIView *BackView = [[UIView alloc] initWithFrame:CGRectMake(0, 12 + 64, SCREEN_WIDTH, 50)];
    [self.view addSubview:BackView];
    [BackView setBackgroundColor:getUIColor(Color_black)];
    
    
    nameText = [UITextField new];
    [BackView addSubview:nameText];
    nameText.delegate = self;
    nameText.sd_layout
    .leftSpaceToView(BackView, 12)
    .centerYEqualToView(BackView)
    .heightIs(40)
    .rightSpaceToView(BackView, 100);
    [nameText setTintColor:[UIColor whiteColor]];
    [nameText setFont:[UIFont systemFontOfSize:14]];
    [nameText setTextColor:[UIColor whiteColor]];
//    [nameText setPlaceholder:@"请输入账户手机号"];
    [nameText setUserInteractionEnabled:NO];
    NSString *phoneScr = [[SelfPersonInfo getInstance].personPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [nameText setText:phoneScr];
    [nameText setValue:Color_white forKeyPath:@"_placeholderLabel.textColor"];
    [nameText setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    nameText.clearButtonMode = UITextFieldViewModeAlways;
    
    buttonCheck = [UIButton new];
    [BackView addSubview:buttonCheck];
    buttonCheck.sd_layout
    .leftSpaceToView(nameText, 5)
    .rightSpaceToView(BackView, 5)
    .heightIs(40)
    .centerYEqualToView(BackView);
    [buttonCheck setTitle:@"获取验证码" forState:UIControlStateNormal];
    [buttonCheck.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonCheck addTarget:self action:@selector(getCheck) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    [BackView addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(nameText, 2)
    .centerYEqualToView(BackView)
    .heightIs(20)
    .widthIs(1);
    [lineView setBackgroundColor:Color_white];
    
    
    UIView *BackView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 12 + 64 + 62, SCREEN_WIDTH, 50)];
    [self.view addSubview:BackView1];
    [BackView1 setBackgroundColor:getUIColor(Color_black)];
    
    
    checkText = [UITextField new];
    [BackView1 addSubview:checkText];
    checkText.delegate = self;
    checkText.sd_layout
    .leftSpaceToView(BackView1, 12)
    .centerYEqualToView(BackView1)
    .heightIs(40)
    .rightSpaceToView(BackView1, 100);
    [checkText setTintColor:[UIColor whiteColor]];
    [checkText setFont:[UIFont systemFontOfSize:14]];
    [checkText setTextColor:[UIColor whiteColor]];
    [checkText setPlaceholder:@"请输入验证码"];
    [checkText setKeyboardType:UIKeyboardTypeNumberPad];
    [checkText setValue:Color_white forKeyPath:@"_placeholderLabel.textColor"];
    [checkText setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    checkText.clearButtonMode = UITextFieldViewModeAlways;
    
    
}

-(void)getCheck
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getPayCheck postData:URL_GetPayCheck PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            [buttonCheck setTitle:@"已发送" forState:UIControlStateNormal];
            [buttonCheck setTitleColor:Color_Gold forState:UIControlStateNormal];
            [buttonCheck setUserInteractionEnabled:NO];
        }
    }];
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
