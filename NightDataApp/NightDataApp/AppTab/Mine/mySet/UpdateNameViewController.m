//
//  UpdateNameViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/1.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "UpdateNameViewController.h"

@interface UpdateNameViewController ()<UITextFieldDelegate>

@end

@implementation UpdateNameViewController
{
    NSMutableDictionary *params;
    BaseDomain *postUserName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    postUserName = [BaseDomain getInstance:NO];
    params = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:Color_blackBack];
    [self crecteNameTextField];
    
    UIButton *butDone = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [butDone setTitle:@"完成" forState:UIControlStateNormal];
    
    
    [butDone.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:butDone];
    [butDone addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}


-(void)doneClick
{
    [self.view endEditing:YES];
    [postUserName postData:URL_UpdataUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSuccess" object:nil];
        }
        
    }];
}

-(void)crecteNameTextField
{
    UIView *BackView = [[UIView alloc] initWithFrame:CGRectMake(0, 12 + 64, SCREEN_WIDTH, 50)];
    [self.view addSubview:BackView];
    [BackView setBackgroundColor:getUIColor(Color_black)];
    
    
    UITextField *nameText = [UITextField new];
    [BackView addSubview:nameText];
    nameText.delegate = self;
    nameText.sd_layout
    .leftSpaceToView(BackView, 12)
    .centerYEqualToView(BackView)
    .heightIs(40)
    .rightSpaceToView(BackView, 12);
    [nameText setTintColor:[UIColor whiteColor]];
    [nameText setFont:[UIFont systemFontOfSize:14]];
    [nameText setTextColor:[UIColor whiteColor]];
    [nameText setPlaceholder:@"请输入15个字以内的昵称"];
    [nameText setText:[SelfPersonInfo getInstance].cnPersonUserName];
    [nameText setValue:Color_white forKeyPath:@"_placeholderLabel.textColor"];
    [nameText setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    nameText.clearButtonMode = UITextFieldViewModeAlways;
    
}


- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:20];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [params setObject:textField.text forKey:@"name"];
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
