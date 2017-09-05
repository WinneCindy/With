//
//  setPhontViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/15.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "setPhontViewController.h"

@interface setPhontViewController ()<UITextFieldDelegate>

@end

@implementation setPhontViewController
{
    UITextField *phoneText;
    UITextField *checkText;
    UIButton *checkBtn;
    BaseDomain *bindPhone;
    UIImageView *backImg;
    UIImageView *logoCicle;
    UIImageView *headImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    bindPhone = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    // Do any additional setup after loading the view.
    
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [backImg setImage:[UIImage imageNamed:@"loginBack"]];
    [backImg setUserInteractionEnabled:YES];
    [self.view addSubview:backImg];

    
    [self createView];
    UIButton *buttonBack = [UIButton new];
    [self.view addSubview:buttonBack];
    buttonBack.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 18)
    .heightIs(48)
    .widthIs(48);
    [buttonBack setImage:[UIImage imageNamed:@"mine_back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *labelTitle = [UILabel new];
    [self.view addSubview:labelTitle];
    labelTitle.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 24)
    .heightIs(40)
    .widthIs(120);
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setText:@"绑定手机号"];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setFont:[UIFont systemFontOfSize:16]];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createView
{
    UIView *contentView = self.view;
    
    logoCicle = [UIImageView new];
    [self.view addSubview:logoCicle];
    logoCicle.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 64)
    .heightIs(80)
    .widthIs(80);
    [logoCicle setImage:[UIImage imageNamed:@"loginCircle"]];
    
    
    headImage = [UIImageView new];
    [self.view addSubview:headImage];
    headImage.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 68)
    .heightIs(72)
    .widthIs(72);
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_params stringForKey:@"avatar"]]] placeholderImage:ImagePlaceHolder];
    //    [headImage.layer setCornerRadius:36];
    //    [headImage.layer setMasksToBounds:YES];
    headImage.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    
    UIImageView *phoneImg = [UIImageView new];
    [backImg addSubview:phoneImg];
    phoneImg.sd_layout
    .leftSpaceToView(backImg, 68)
    .topSpaceToView(backImg, 140 + 113.0 / 667.0 * SCREEN_HEIGHT)
    .heightIs(18)
    .widthIs(13);
    [phoneImg setImage:[UIImage imageNamed:@"shouji"]];
    
    
    phoneText = [UITextField new];
    [backImg addSubview:phoneText];
    phoneText.sd_layout
    .leftSpaceToView(phoneImg, 10)
    .topSpaceToView(backImg, 140 + 113.0 / 667.0 * SCREEN_HEIGHT)
    .heightIs(20)
    .rightSpaceToView(backImg, 68);
    [phoneText setTextColor:Color_white];
    [phoneText setFont:[UIFont systemFontOfSize:14]];
    phoneText.delegate = self;
    [phoneText setReturnKeyType:UIReturnKeyNext];
    [phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    
    UIImageView *lineView = [UIImageView new];
    [backImg addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(backImg, 68)
    .topSpaceToView(phoneText, 10)
    .rightSpaceToView(backImg, 68)
    .heightIs(1);
    [lineView setImage:[UIImage imageNamed:@"line"]];
    
    
    UIImageView *checkImg = [UIImageView new];
    [backImg addSubview:checkImg];
    checkImg.sd_layout
    .leftSpaceToView(backImg, 68)
    .topSpaceToView(lineView, 30)
    .heightIs(18)
    .widthIs(13);
    [checkImg setImage:[UIImage imageNamed:@"mima"]];
    
    
    checkText = [UITextField new];
    [backImg addSubview:checkText];
    checkText.sd_layout
    .leftSpaceToView(checkImg, 10)
    .topSpaceToView(lineView, 30)
    .heightIs(20)
    .widthIs(80);
    [checkText setTextColor:Color_white];
    [checkText setFont:[UIFont systemFontOfSize:14]];
    checkText.delegate = self;
    [checkText setReturnKeyType:UIReturnKeyDone];
    
    
    UIImageView *lineView2 = [UIImageView new];
    [backImg addSubview:lineView2];
    lineView2.sd_layout
    .leftSpaceToView(backImg, 68)
    .topSpaceToView(checkText, 10)
    .rightSpaceToView(backImg, 68)
    .heightIs(1);
    [lineView2 setImage:[UIImage imageNamed:@"line"]];
    
    checkBtn  = [UIButton new];
    [backImg addSubview:checkBtn];
    checkBtn.sd_layout
    .rightSpaceToView(backImg, 68)
    .topSpaceToView(lineView, 30)
    .heightIs(20)
    .widthIs(100);
    [checkBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [checkBtn setTitleColor:Color_white forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *loginBtn =[UIButton new];
    [backImg addSubview:loginBtn];
    loginBtn.sd_layout
    .centerXEqualToView(backImg)
    .topSpaceToView(lineView2, 60)
    .widthIs(213)
    .heightIs(40);
    [loginBtn setImage:[UIImage imageNamed:@"bangding"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == phoneText) {
        [phoneText resignFirstResponder];
        [checkText becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

-(void)loginClick
{
    NSUserDefaults *userD= [NSUserDefaults standardUserDefaults];
    [_params setObject:phoneText.text forKey:@"phone"];
    [_params setObject:checkText.text forKey:@"code"];
    [_params setObject:@"1" forKey:@"type"];
    [_params setObject:[userD stringForKey:@"cId"] forKey:@"device_id"];
    [bindPhone postData:URL_bindPhone PostParams:_params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            [userd setObject:phoneText.text forKey:@"phone"];
            [SelfPersonInfo getInstance].personPhone = phoneText.text;
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:domain.dataRoot];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


-(void)checkClickAction
{
    
    if (phoneText.text.length == 0) {
        [self alertViewShowOfTime:@"请输入手机号" time:1];
    } else if (phoneText.text.length != 11) {
        [self alertViewShowOfTime:@"请输入正确的手机号" time:1];
    } else {
        NSMutableDictionary *paramsdic = [NSMutableDictionary dictionary];
        [paramsdic setObject:phoneText.text forKey:@"phone"];
        [bindPhone postData:URL_getCheckNumber PostParams:paramsdic finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                
                NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"token"] forKey:@"token"];
                
                [self alertViewShowOfTime:@"验证码已经发送，请注意查收" time:1];
                
                
            }
        }];

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
