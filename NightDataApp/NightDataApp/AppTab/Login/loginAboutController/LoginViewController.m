//
//  LoginViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "LoginViewController.h"
#import "JKCountDownButton.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "LoginManager.h"

#import "WXApi.h"
#import "AppDelegate.h"
//微信开发者ID
#define URL_APPID @"wx4a720f0ab73c9450"
#define URL_SECRET @"879c0782a5e4aa3574ee1e3fd2d78557"
#import "WeixinPayHelper.h"

@interface LoginViewController ()<YBAttributeTapActionDelegate,WXApiDelegate>

@end

@implementation LoginViewController

{
    UITextField *username;
    UITextField *checkCount;
    JKCountDownButton *sendButton;
    UIButton *login;
    BaseDomain *loginDomin;
    BaseDomain *getDataCount;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:getUIColor(Color_black)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification" object:username];
    getDataCount = [BaseDomain getInstance:NO];
    if (loginDomin == nil) {
        loginDomin = [BaseDomain getInstance:NO];
    }
    
    [self setUp];
    // Do any additional setup after loading the view.
}

-(void)quitClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUp{
    
    
    UIImageView *imageHeadNavi = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [imageHeadNavi setImage:[UIImage imageNamed:@"naviBack"]];
    [self.view addSubview:imageHeadNavi];
    
    UIButton *buttonQuit = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 24, 24)];
    [buttonQuit setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [buttonQuit addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonQuit];
    
    
    
    username = [UITextField new];
    [self.view addSubview:username];
    username.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(self.view, (317.0 / 667.0) * SCREEN_HEIGHT)
    .heightIs(30);         // userName Create (phone number)
    
    username.placeholder = @"请输入11位手机号码";
    username.keyboardType = UIKeyboardTypeNumberPad;
    [username setTextColor:Color_white];
    [username setFont:[UIFont systemFontOfSize:14]];
    UIImageView *imageViewUserName = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140 / 2, 36 / 2)];
    imageViewUserName.image=[UIImage imageNamed:@"userName"];
    username.leftView=imageViewUserName;
    username.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    username.delegate = self;
    
    [username setValue:Color_white forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    //    UIView *lineUserName = [[UIView alloc] initWithFrame:CGRectMake(30, 270, SCREEN_WIDTH - 60, 1)];
    UIView *lineUserName = [UIView new];
    [lineUserName setBackgroundColor:Color_white];
    [self.view addSubview:lineUserName];
    lineUserName.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(username, 0)
    .heightIs(1);
    
    
    
    checkCount = [UITextField new];
    [self.view addSubview:checkCount];
    checkCount.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(lineUserName, 30)
    .heightIs(30);
    // checkNumber (system will send you a checkNumber when you touch this button)
    
    [checkCount setFont:[UIFont systemFontOfSize:14]];
    checkCount.placeholder = @"请输入验证码";
    [checkCount setSecureTextEntry:YES];
    checkCount.keyboardType = UIKeyboardTypeNumberPad;
    [checkCount setValue:Color_white forKeyPath:@"_placeholderLabel.textColor"];
    UIImageView *imageViewCheck = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140 / 2, 36 / 2)];
    imageViewCheck.image=[UIImage imageNamed:@"Check"];
    checkCount.leftView=imageViewCheck;
    checkCount.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    checkCount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    checkCount.delegate = self;
    
    
    //    UIView *lineCheck = [[UIView alloc] initWithFrame:CGRectMake(30, 340, SCREEN_WIDTH - 60, 1)];
    
    UIView *lineCheck = [UIView new];
    [lineCheck setBackgroundColor:Color_white];
    [self.view addSubview:lineCheck];
    lineCheck.sd_layout
    .leftSpaceToView(self.view, 60)
    .rightSpaceToView(self.view, 60)
    .topSpaceToView(checkCount, 0)
    .heightIs(1);
    
    
    sendButton = [JKCountDownButton new];
    [self.view addSubview:sendButton];
    
    sendButton.sd_layout
    .rightSpaceToView(self.view, 60)
    .bottomSpaceToView(lineCheck, 4)
    .heightIs(30)
    .widthIs(90);
    [sendButton.layer setCornerRadius:15];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setUserInteractionEnabled:NO];
    [sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:[UIColor lightGrayColor]];
    //    sendButton.enabled = NO;
    [sendButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"重发(%d)",second];
        return title;
    }];
    [sendButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
    
    // sender CheckNumber , control system to send checkNumber
    
    
    
    login = [UIButton new];
    [self.view addSubview:login];
    
    login.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(lineCheck, 57)
    .heightIs(98 / 2)
    .widthIs(560 / 2);
    
    [login.layer setCornerRadius:22];
    [login.layer setMasksToBounds:YES];
    [login setImage:[UIImage imageNamed:@"CantLogin"] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [login.layer setCornerRadius:1];
    [login.layer setMasksToBounds:YES];
    
    
    
    
    NSString *label_text2 = @"温馨提示:未注册的手机号将自动注册为妙定用户,且代表已阅读并同意《妙定用户协议》";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:label_text2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(0, label_text2.length)];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:getUIColor(Color_black) range:NSMakeRange(32, 7)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label_text2 length])];
    
    UILabel *ybLabel2 = [UILabel new];
    [self.view addSubview:ybLabel2];
    ybLabel2.sd_layout
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 10)
    .heightIs(15);
    [ybLabel2 setTextColor:getUIColor(Color_black)];
    [ybLabel2 setFont:[UIFont systemFontOfSize:8]];
    ybLabel2.numberOfLines = 2;
    [ybLabel2 setText:label_text2];
    ybLabel2.attributedText = attributedString2;
    [ybLabel2 setTextAlignment:NSTextAlignmentCenter];
    
    
    [ybLabel2 yb_addAttributeTapActionWithStrings:@[@"妙定用户协议"] delegate:self];
    //设置是否有点击效果，默认是YES
    
}



-(void)textFiledEditChanged:(NSNotification *)obj
{
    
    
    UITextField *textField = (UITextField *)obj.object;
    
    
    if (textField == username) {
        
        NSString *toBeString = textField.text;
        
        if ([toBeString length] > 0) {
            [sendButton setUserInteractionEnabled:YES];
            [sendButton setBackgroundColor:getUIColor(Color_black)];
        } else {
            [sendButton setUserInteractionEnabled:NO];
            [sendButton setBackgroundColor:Color_white];
        }
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > 11)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:11];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:11];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 11)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    } else {
        NSString *toBeString = textField.text;
        if ([toBeString length] > 0 && [username.text length] > 0) {
            [login setUserInteractionEnabled:YES];
            [login setImage:[UIImage imageNamed:@"LoginCanClick"] forState:UIControlStateNormal];
        } else {
            [login setUserInteractionEnabled:NO];
            [login setImage:[UIImage imageNamed:@"LoginCantClick"] forState:UIControlStateNormal];
        }
    }
    
}



//-(CAGradientLayer *)backgroundLayer{
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.view.bounds;
//    gradientLayer.colors = @[(__bridge id)getUIColor(Color_background).CGColor,(__bridge id)getUIColor(Color_background).CGColor];
//    gradientLayer.startPoint = CGPointMake(0.5, 0);
//    gradientLayer.endPoint = CGPointMake(0.5, 1);
//    gradientLayer.locations = @[@0.65,@1];
//    return gradientLayer;
//}




- (void)LoginClick{
    
    // 检测手机号码是否输入
    if (username.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:NSLocalizedString(@"login_auth_isemptrytip", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
        
        [alertView show];
        
        [username becomeFirstResponder];
        
        return;
    }
    
    // 检测密码是否输入
    if (checkCount.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:NSLocalizedString(@"login_auth_isemptrytip", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
        
        [alertView show];
        
        [checkCount becomeFirstResponder];
        
        return;
    }
    
    
    
    
//    
//    [[LoginManager getInstance] postLoginAuth:username.text userPwd:checkCount.text isAuto:YES finish:^(Boolean success) {
//        if (success) {
//            
//            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//            [userd setObject:username.text forKey:@"phone"];
//            [SelfPersonInfo getInstance].personPhone = username.text;
//            [self dismissViewControllerAnimated:YES completion:nil];
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
//            
//        } else {
//            
//        }
//    }];
    
}

-(void)sendClick:(JKCountDownButton *)sender
{
    
    if (username.text.length == 0) {
        
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:username.text forKey:@"phone"];
        [getDataCount postData:URL_getCheckNumber PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            NSLog(@"%@", getDataCount.dataRoot);
            
            if ([self checkHttpResponseResultStatus:getDataCount]) {
                
                NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                [used setObject:[[getDataCount.dataRoot objectForKey:@"data"] stringForKey:@"token"] forKey:@"token"];
                
                sender.enabled = NO;
                [sender startWithSecond:120];
                [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                    NSString *title = [NSString stringWithFormat:@"重发(%d)",second];
                    return title;
                }];
                [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                    countDownButton.enabled = YES;
                    return @"重新获取";
                }];
                
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
